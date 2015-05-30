angular
.module('mepedia.controllers')
.controller("employerSignupController",
    ['$scope', '$q', '$http', '$state', 'sessionService', 'Skill', 'Employer','Interest', 'EmployerNationalities', 'Company', 'EmployerCompany', 'EmployerSkills', 'EmployerInterests', 'Utils'
        ($scope, $q, $httpProvider, $state, sessionService, Skill, Employer, Interest, EmployerNationalities, Company, EmployerCompany, EmployerSkills, EmployerInterests, Utils) ->

            init = ->
                $scope.selectedInterests = []
                $scope.selectedSkills = []
                $scope.addCompanyEnabled = false
                $scope.skills = new EmployerSkills()
                $scope.interests = new EmployerInterests();
                $scope.employerCompany = new EmployerCompany()
                $scope.employerNationality = new EmployerNationalities();
                $scope.newCompany = new Company()

                $scope.genders = [
                    "Male",
                    "Female",
                    "Other"
                ]
                
                $scope.userGender = "Select Gender"
                $scope.selectedFrom = "From"
                $scope.selectedTo = "To"

                Company.query (companies) ->
                    $scope.companies = companies.companies

                $scope.onGender = (index) ->
                  $scope.user.gender = index
                  $scope.gender = $scope.userGender = $scope.genders[index]

                $scope.onCountry = (country) ->
                    if(country?)
                        $scope.country = country
                        $scope.user.country_id = country.id

                $scope.onState = (state) ->
                    if(state?)
                        $scope.state = state
                        $scope.user.state_id = state.id

                $scope.onNationality = (nationality) ->
                    if(nationality?)
                        $scope.nationality = nationality
                        $scope.employerNationality.nationality_id = nationality.id
                        $scope.employerNationality.emloyer_id = $scope.user.uid

                $scope.onCompany = (company) ->
                    if company?
                        $scope.company = company
                        $scope.employerCompany.company_id = company.id

                $scope.onCompanyCountry = (country) ->
                    if(country?)
                        $scope.companyCountry = country
                        $scope.employerCompany.country_id = country.id

                $scope.onCompanyState = (state) ->
                    if(state?)
                        $scope.companyState = state
                        $scope.employerCompany.state_id = state.id

                ####### Skills ######
                Skill.query (skills)->
                    $scope.skillsTags = skills.skills

                Interest.query (interests) ->
                    $scope.interestsTags = interests.interests

                sessionService.requestCurrentUser().then(
                    (user) ->
                        $state.go 'home.page' if !user?
                        $scope.user = Utils.employerFromObject(user.employer)
                        $scope.employerCompany.employer_id = $scope.user.uid
                        $scope.skills.employer_id = $scope.user.uid
                        $scope.interests.employer_id = $scope.user.uid
                        $scope.employerNationality.employer_id = $scope.user.uid
                ).catch(
                    (error) ->
                        console.log error
                        $state.go 'home.page'
                )

                $scope.validatePersonal = (valid) ->
                    $state.go 'main.signup_employer.company' if valid

                $scope.validateCompany = (valid) ->
                    $state.go 'main.signup_employer.looking' if valid

                $scope.backToPersonal =  ->
                    $state.go 'main.signup_employer.personal'

                $scope.backToCompany = ->
                    $state.go 'main.signup_employer.company'

                $scope.validateAndCreate = validateAndCreate
                $scope.toggleAddCompany = toggleAddCompany

            validateAndCreate = (valid) ->
                createUser() if valid

            createUser = () ->
                $httpProvider.defaults.headers.common['Authorization'] = sessionService.authenticationToken()
                createCompany().then(
                    (company) ->
                        $q.all([saveEmployerNationality(), saveCompany(company.company.id), saveSkills(), saveInterests(), saveUser()])
                        .then(
                            (data) ->
                                console.log(data)
                                $state.go 'main.employer_profile'
                        ).catch(
                            (error) ->
                                $scope.serverErrors = error.data.error
                        )
                ).catch(
                    (error) ->
                        console.log error
                )

            createCompany = ->
                deferred = $q.defer()
                if !$scope.addCompanyEnabled
                    deferred.resolve({company: {id: $scope.employerCompany.company_id}})
                else
                    $scope.newCompany.$save().then(
                        (company) ->
                            deferred.resolve({company: {id: company.company.id}})
                    ).catch(
                        (error) ->
                            deferred.reject(error)
                    )
                deferred.promise

            saveCompany = (id) ->
                $scope.employerCompany.company_id = id
                $scope.employerCompany.$save()

            saveEmployerNationality = ->
                $scope.employerNationality.$save()

            saveSkills = ->
                $scope.skills.skills = $scope.selectedSkills.map((skill) -> {name: skill})
                $scope.skills.$update()

            saveInterests = ->
                $scope.interests.interests = $scope.selectedInterests.map((interest) -> {name: interest})
                $scope.interests.$update()

            saveUser = ->
                $scope.user.$update()

            toggleAddCompany = ->
                if ($scope.addCompanyEnabled)
                    $scope.addCompanyEnabled = false
                else
                    $scope.addCompanyEnabled = true
            
            init()
    ])
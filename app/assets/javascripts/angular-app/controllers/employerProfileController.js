angular.module('mepedia.controllers').controller('employerProfileController',
    ['$scope', '$rootScope', '$http', '$upload', 'sessionService', '$state', 'Skill', 'Country', 'State', 'EmployerSkills', 'EmployerCompany', 'Utils', 'EmployerInterests',

        function($scope, $rootScope,$httpProvider, $upload, sessionService, $state, Skill, Country, State, EmployerSkills, EmployerCompany, Utils, EmployerInterests) {
            var init = function () {
                getData();

                /* SKILLS */
                initSkills();

                /* INTERESTS */
                initInterests();

                sessionService.requestCurrentUser().then(
                    function (user) {
                        $scope.user = user.employer;
                        initEmployerProfile();

                        // Fire event to catch it in editCompany directive
                        $scope.$broadcast('userLoaded');
                    },
                    function (error) {
                        console.log(error);
                        $state.go('home.page');
                    }
                );
            };

            var initEmployerProfile = function(){

                /* this is static, 
                 * TODO: GET COMPANY FROM SERVER
                 */

                $scope.user.company = {
                    company_id: 1,
                    name: 'Ceibal',
                    industry: 'Information Techonology',
                    description: 'Mi descripcion man',
                    state: 'Montevideo',
                    country: 'Uruguay',
                    companyUrl: 'www.ceibal.edu.uy'
                };

                $scope.employerCompany = $scope.user.company;

                // hide
                $scope.descriptionEnable = false;

                $scope.selectedSkills = $scope.user.skills.map(function (skill) {
                    return skill.name;
                });

                $scope.selectedInterests = $scope.user.interests.map(function (interest) {
                    return interest.name;
                });
            }

            // Description
            $scope.enableDescriptionEditor = function() {
                $scope.summary = $scope.employerDescription;
                $scope.descriptionEnable = true;
                $scope.editorDescriptionEnabled = true;
            }

            $scope.saveDescription = function() {
                $scope.employerDescription = $scope.summary;

                // Asign value to user variable
                $scope.user.description = $scope.employerDescription;




                // HIDE:
                $scope.descriptionEnable = false;
                $scope.editorDescriptionEnabled = false;
            }

            $scope.disableDescriptionEditor = function() {
                $scope.descriptionEnable = false;
                $scope.editorDescriptionEnabled = false;
            }

            var updateUser = function () {
                $httpProvider.defaults.headers.common['Authorization'] = sessionService.authenticationToken();
                Utils.employerFromObject($scope.user).$update(function (response) { //Creates resource User from object $scope.user
                    $scope.user = response.employer;
                }, function (error) {
                    console.log(error);
                });
            }

            // Skills
            var initSkills = function() {
                $scope.employerSelectedSkills = [];
                $scope.selectedSkills = [];
                $scope.editorSkillsEnabled = false;

                $scope.enableSkillsEditor = function() {
                    $scope.editorSkillsEnabled = true;
                    if($scope.selectedSkills.length > 0) {
                        console.log($scope.selectedSkills);
                        $scope.employerSelectedSkills = $scope.selectedSkills.slice();
                    }
                };

                $scope.disableSkillsEditor = function() {
                    $scope.editorSkillsEnabled = false;
                };

                $scope.saveSkills = saveSkills;
            };


            var saveSkills = function(){
                $scope.disableSkillsEditor();
                $scope.selectedSkills = $scope.employerSelectedSkills.slice();

                var employerSkills = new EmployerSkills();
                employerSkills.employer_id = $scope.user.uid;
                employerSkills.skills = $scope.selectedSkills.map(function(skillName) {
                    return {name: skillName}
                });

                // need to be updated in backend.
                $httpProvider.defaults.headers.common['Authorization'] = sessionService.authenticationToken();
                employerSkills.$update(
                    function (response) {
                        console.log(response);
                        $scope.selectedSkills = response.skills.map(function (skill) {
                            return skill.name;
                        });
                        //refreshSkills();
                    },
                    function(error) {
                        console.log(error)
                });
            };


            var refreshSkills = function () {
                EmployerSkills.query({candidate_id: $scope.user.uid}, function (skills) {
                    $scope.employerSelectedSkills = skills.skills;
                })
            };

            // interests
            var initInterests = function() {
                $scope.employerSelectedInterests = [];
                $scope.selectedInterests = [];
                $scope.editorInterestsEnabled = false;

                $scope.enableInterestsEditor = function() {
                    $scope.editorInterestsEnabled = true;
                    if($scope.selectedInterests.length > 0) {
                        $scope.employerSelectedInterests = $scope.selectedInterests.slice();
                    }
                };

                $scope.disableInterestsEditor = function() {
                    $scope.editorInterestsEnabled = false;
                };

                $scope.saveInterests = saveInterests;
            };


            var saveInterests = function() {
                $scope.disableInterestsEditor();
                $scope.selectedInterests = $scope.employerSelectedInterests.slice();
                
                var employerInterests = new EmployerInterests();
                employerInterests.employer_id = $scope.user.uid;
                employerInterests.interests = $scope.selectedInterests.map(function(skillName) {
                    return {name: skillName}
                });
                // need to be updated in backend.
                $httpProvider.defaults.headers.common['Authorization'] = sessionService.authenticationToken();
                employerInterests.$update(
                    function (response) {
                        console.log(response);
                        refreshSkills();
                    },
                    function(error) {
                        console.log(error)
                });
            };


            var refreshInterests = function () {
                EmployerInterests.query({employer_id: $scope.user.uid}, function (skills) {
                    $scope.employerSelectedInterests = skills.skills;
                })
            };

            
            // company info
            $scope.saveEmployerCompany = function() {

                var empCom = $scope.employerCompany;
                console.log(empCom);

                // save 
                var employerCompany = new EmployerCompany();
                employerCompany.employer_id = $scope.user.uid;
                employerCompany.description = empCom.description;
                employerCompany.state = empCom.state;
                employerCompany.country = empCom.country;
                employerCompany.companyUrl = empCom.companyUrl;
                console.log('1 - ');
                console.log(employerCompany);

                $httpProvider.defaults.headers.common['Authorization'] = sessionService.authenticationToken();
                
                employerCompany.$update(
                    function(employerCompanyUpdated) {
                        console.log('Hecho!');
                        $scope.user.company = employerCompanyUpdated.company;  
                    }, function(error) {
                        console.log(error);
                });


            }


            // get data from db
            var getData = function() {
                Country.query(function(countries) {
                    $scope.countries = countries.countries;
                });

                $scope.getStateByCountryId = function(countryId) {
                    State.query({country_id: countryId}, function(states) {
                        $scope.states = states.states;
                        console.log($scope.states);
                    });
                };

                Skill.get(function(skills) {
                    $scope.skillsTags = skills.skills;
                });
              
            };
            init();
        }]);



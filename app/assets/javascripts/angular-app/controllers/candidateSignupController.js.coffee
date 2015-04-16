angular
	.module('mepedia.controllers')
	.controller("candidateSignupController",
	['$scope', '$q', '$http', '$state', 'sessionService', 'Skill', 'Candidate', 'Interest', 'CandidateNationalities', 'Education', 'CandidateSkills', 'Utils', 'alertService',
	($scope, $q, $httpProvider, $state, sessionService, Skill, Candidate, Interest, CandidateNationalities, Education, CandidateSkills, Utils, alertService)->

		init = ->
			$scope.selectedTags = []
			$scope.education = new Education()
			$scope.skills = new CandidateSkills()
			$scope.candidateNationality = new CandidateNationalities();

			$scope.selectedFrom = "From"
			$scope.selectedTo = "To"

			$scope.onCountry = (country) ->
				if(country?)
					$scope.user.country_id = country.id

			$scope.onState = (state) ->
				if(state?)
					$scope.user.state_id = state.id

			$scope.onNationality = (nationality) ->
				if(nationality?)
					$scope.candidateNationality.name = nationality.name
					$scope.candidateNationality.candidate_id = $scope.user.uid;

			####### Eduaction ######

			$scope.onSchool = (school) ->
				if(school?)
					$scope.education.school_id = school.id

			$scope.onSchoolCountry = (country) ->
				if(country?)
					$scope.education.country_id = country.id

			$scope.onSchoolState = (state) ->
				if(state?)
					$scope.education.state_id = state.id

			$scope.onMajor = (major) ->
				if(major?)
					$scope.education.major_id = major.id

			$scope.onDegree = (degree) ->
				if(degree?)
					$scope.education.degree_id = degree.id

			####### Skills ######
			Skill.query (skills) ->
				$scope.skillsTags = skills.skills

			$scope.selectedSkills = [];

			sessionService.requestCurrentUser().then(
				(user) ->
					$state.go 'home.page' if !user?
					$scope.user = Utils.candidateFromObject(user.candidate)
					$scope.education.candidate_id = $scope.user.uid
					$scope.skills.candidate_id = $scope.user.uid
				,
				(error) ->
					console.log error
					$state.go 'home.page'
			)

			$scope.validatePersonal = (valid) ->
				$state.go 'main.signup_candidate.education' if valid

			$scope.validateEducation = (valid) ->
				$state.go 'main.signup_candidate.interests' if valid

			$scope.validateAndCreate = validateAndCreate

		validateAndCreate = (valid) ->
			createUser() if valid

		createUser = () ->
			$httpProvider.defaults.headers.common['Authorization'] = sessionService.authenticationToken()
			$q.all([saveCandidateNationality(), saveEducation(), saveSkills(), saveUser()])
				.then(
					(data) ->
						console.log(data)
						$state.go 'main.candidate_profile'
					,
					(error) ->
						$scope.serverErrors = error.data.error
				)

		saveEducation = ->
			$scope.education.$save()

		saveCandidateNationality = ->
			$scope.candidateNationality.$save()

		saveSkills = ->
			$scope.skills.skills = [{name: skill.name} for skill in $scope.selectedSkills]
			$scope.skills.$update()

		saveUser = ->
			$scope.user.$update()

		init()
])
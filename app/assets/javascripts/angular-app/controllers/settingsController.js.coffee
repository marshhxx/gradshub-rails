angular
.module('mepedia.controllers')
.controller("settingsController",
  ['$scope', '$rootScope', '$q', '$http', '$state', 'sessionService', '$stateParams', 'Candidate', 'Utils', 'errors', 
    'alertService', 'ALERT_CONSTANTS', 'Country', 'CandidateNationalities', '$animate', '$timeout'
    ($scope, $rootScope, $q, $httpProvider, $state, sessionService, $stateParams, Candidate, Utils, errors, alertService, ALERT_CONSTANTS, Country, CandidateNationalities, animate, $timeout) ->

      init = ()->
        $scope.notMe = Utils.notMe()

        if $scope.notMe 
          Candidate.get id: $stateParams.uid, setUser, errors.userNotFound
        else
          $scope.userPromise.then checkAndSetUser, errors.notLoggedIn

        $scope.editFullName = true
        $scope.editPassword = true
        $scope.editBirthday = true
        $scope.editGender = true
        $scope.editHeadline = true
        $scope.editLocation = true
        $scope.editNationality = true

        $scope.genders = [
          "male",
          "female",
          "other"
        ]


      setUser = (user) ->
        $scope.user = user.candidate
        initCandidateUser()

      checkAndSetUser = (user) ->
        if sessionService.sessionType() == 'Employer'
          $state.go 'main.employer_profile', {uid: 'me'}, { reload: true }
        else
          setUser(user)

      initCandidateUser = ->
        day = $scope.user.birth.charAt(8)
        $scope.birthday = $scope.user.birth
        if day = '0' then $scope.birthday = $scope.birthday.substr(0, 8) + $scope.birthday.substr(9)

      $scope.toggleFullNameEditing = (condition)->
        $scope.editFullName = !$scope.editFullName

      $scope.togglePasswordEditing = (condition) ->
        $scope.editPassword = !$scope.editPassword

      $scope.toggleBirthdayEditing = (condition) ->
        $scope.editBirthday = !$scope.editBirthday

      $scope.toggleGenderEditing = (condition) ->
        $scope.editGender = !$scope.editGender

      $scope.toggleHeadlineEditing = (condition) ->
        $scope.editHeadline = !$scope.editHeadline

      $scope.toggleLocationEditing = (condition) ->
        $scope.editLocation = !$scope.editLocation

      $scope.toggleNationalityEditing = (condition) ->
        $scope.nationality = null
        $scope.editNationality = !$scope.editNationality


      $scope.onCountry = (country) ->
        $scope.user.country_id = country.id if country?
        $scope.user.country = country

      $scope.onState = (state) ->
        $scope.user.state.state_id = state.id if state?
        $scope.user.state = state

      $scope.onNationality = (nationality) ->
        $scope.candidateNationality = new CandidateNationalities()
        $scope.candidateNationality.candidate_id = $scope.user.uid
        $scope.candidateNationality.id = $scope.user.nationalities[0].id if $scope.user.nationalities.length > 0

        $scope.newNationality = new CandidateNationalities()
        $scope.newNationality.candidate_id = $scope.user.uid
        $scope.newNationality.nationality_id = nationality.id if nationality?

      # Save functions
      saveUser = () ->
        $httpProvider.defaults.headers.common['Authorization'] = sessionService.authenticationToken()
        Utils.candidateFromObject($scope.user).$update((response) ->
          console.log response
          $scope.user = response.candidate
          $scope.tag = ''
        ).catch alertService.defaultErrorCallback

      $scope.saveUserFullName = ->
        saveUser()
        alertService.addInfo 'Name successfully edited', ALERT_CONSTANTS.SUCCESS_TIMEOUT
        $scope.toggleFullNameEditing()

      $scope.saveUserBirth = ->
        console.log $scope.birthday
        $scope.user.birth = $scope.birthday
        saveUser()
        alertService.addInfo 'Birthday successfully edited', ALERT_CONSTANTS.SUCCESS_TIMEOUT
        $scope.toggleBirthdayEditing()

      $scope.saveUserGender = ->
        saveUser()
        alertService.addInfo 'Gender successfully edited', ALERT_CONSTANTS.SUCCESS_TIMEOUT
        $scope.toggleGenderEditing()

      $scope.saveUserTag = ->
        $scope.user.tag = $scope.tag
        saveUser()
        alertService.addInfo 'Headline successfully edited', ALERT_CONSTANTS.SUCCESS_TIMEOUT
        $scope.toggleHeadlineEditing()

      $scope.saveUserLocation = ->
        saveUser()
        alertService.addInfo 'Location successfully edited', ALERT_CONSTANTS.SUCCESS_TIMEOUT
        $scope.toggleLocationEditing()

      $scope.seveUserNationality = ->
        $httpProvider.defaults.headers.common['Authorization'] = sessionService.authenticationToken()
        
        $scope.candidateNationality.$delete().catch(alertService.defaultErrorCallback)

        $scope.newNationality.$save().then( (data) ->
          alertService.addInfo 'Nationality successfully edited', ALERT_CONSTANTS.SUCCESS_TIMEOUT
          $scope.user.nationalities[0] = data.nationality
          $scope.toggleNationalityEditing()
        ).catch(alertService.defaultErrorCallback)

      init()
  ])
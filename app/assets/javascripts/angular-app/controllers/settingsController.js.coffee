angular
.module('mepedia.controllers')
.controller("settingsController",
  ['$scope', '$rootScope', '$q', '$http', '$state', 'sessionService', '$stateParams', 'Candidate', 'Utils', 'errors',
    ($scope, $rootScope, $q, $httpProvider, $state, sessionService, $stateParams, Candidate, Utils, errors) ->

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

        $scope.genders = [
          "male",
          "female",
          "other"
        ]


      setUser = (user) ->
        $scope.user = user.candidate
        #initCandidateProfile()

      checkAndSetUser = (user) ->
        if sessionService.sessionType() == 'Employer'
          $state.go 'main.employer_profile', {uid: 'me'}, { reload: true }
        else
          setUser(user)

      $scope.toggleFullNameEditing = (condition)->
        if condition then $scope.editFullName = false else $scope.editFullName = true

      $scope.togglePasswordEditing = (condition) ->
        if condition then $scope.editPassword = false else $scope.editPassword = true

      $scope.toggleBirthdayEditing = (condition) ->
        if condition then $scope.editBirthday = false else $scope.editBirthday = true

      $scope.toggleGenderEditing = (condition) ->
        if condition then $scope.editGender = false else $scope.editGender = true

      $scope.toggleHeadlineEditing = (condition) ->
        if condition then $scope.editHeadline = false else $scope.editHeadline = true

      init()
  ])
angular
.module('gradshub-ng.controllers')
.controller("settingsController",
  ['$scope', '$rootScope', '$q', '$http', '$state', 'sessionService', '$stateParams', 'Candidate', 'Utils', 'errors', 
    'alertService', 'ALERT_CONSTANTS', 'Country', 'CandidateNationalities', '$animate', '$timeout', 'EmployerNationalities',
    'Employer',
    ($scope, $rootScope, $q, $httpProvider, $state, sessionService, $stateParams, Candidate, Utils, errors, alertService, ALERT_CONSTANTS, Country, CandidateNationalities, animate, $timeout, EmployerNationalities, Employer) ->

      init = ()->
        $scope.notMe = Utils.notMe()

        if $scope.notMe 
          Candidate.get id: $stateParams.uid, setUser, errors.userNotFound
        else
          $scope.userPromise.then checkAndSetUser, errors.notLoggedIn

        $scope.viewForm = ''

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
        if user.candidate 
          $scope.user = user.candidate
          $scope.isCandidate = true
          $scope.newUserNationality = new CandidateNationalities()
        else
          $scope.user = user.employer
          $scope.newUserNationality = new EmployerNationalities()
        
        $scope.realUser = angular.copy $scope.user
        formatDate()

      checkAndSetUser = (user) ->
        setUser(user)

      formatDate = ->
        day = $scope.user.birth.charAt(8)
        $scope.birthday = $scope.user.birth
        if day = '0' then $scope.birthday = $scope.birthday.substr(0, 8) + $scope.birthday.substr(9)

      $scope.toggleSection = (show) ->
        if show == 'save' then show = '' else $scope.user = angular.copy $scope.realUser
          
        $scope.viewForm = show

      $scope.toggleLocationSection = (show) ->
        if show == 'save' then show = '' else $scope.user = angular.copy $scope.realUser

        $scope.viewForm = show
        $scope.country = ''
        $scope.state = ''

      $scope.toggleNationalitySection = (show) ->
        if show == 'save' then show = '' else $scope.user = angular.copy $scope.realUser

        $scope.nationality = ''
        $scope.viewForm = show

      $scope.onCountry = (country) ->
        $scope.user.country_id = country.id if country?
        $scope.user.country = country

      $scope.onState = (state) ->
        $scope.user.state_id = state.id if state?
        $scope.user.state = state

      $scope.onNationality = (nationality) ->
        if $scope.isCandidate then $scope.newUserNationality.candidate_id = $scope.user.uid else $scope.newUserNationality.employer_id = $scope.user.uid
        $scope.newUserNationality.nationality_id = nationality.id if nationality?

      # Save functions
      saveUser = () ->
        $httpProvider.defaults.headers.common['Authorization'] = sessionService.authenticationToken()
        if $scope.isCandidate
          Utils.candidateFromObject($scope.user).$update((response) ->
            $scope.user = response.candidate
            $scope.realUser = angular.copy $scope.user
            return true
          ).catch( ->
            alertService.defaultErrorCallback
            return false
          )
        else
          Utils.employerFromObject($scope.user).$update((response) ->
            $scope.user = response.employer
            $scope.realUser = angular.copy $scope.user
            return true
          ).catch( ->
            alertService.defaultErrorCallback
            return false
          )

      $scope.saveUserFullName = (valid) ->
        if !valid
          return

        if saveUser()
          alertService.addInfo 'Name successfully edited', ALERT_CONSTANTS.SUCCESS_TIMEOUT
          $scope.toggleSection 'save'

      clearInput = (formName, inputName) ->
        $scope[inputName] = ''
        $scope[formName][inputName].$setPristine()

      $scope.savePassword = (valid) ->
        if !valid
          return

        if $scope.isCandidate then user = new Candidate() else user = new Employer()

        user.uid = $scope.user.uid
        user.old_password = $scope.oldPassword
        user.new_password = $scope.newPassword
        $httpProvider.defaults.headers.common['Authorization'] = sessionService.authenticationToken()
        user.$changePassword().then((response) ->
          alertService.addInfo 'Password successfully changed', ALERT_CONSTANTS.SUCCESS_TIMEOUT
          
          $scope.toggleSection 'save'

        ).catch(alertService.defaultErrorCallback)
        .finally( ->
          clearInput 'passwordForm', 'oldPassword'
          clearInput 'passwordForm', 'newPassword'
          clearInput 'passwordForm', 'reNewPassword'
        )      

      $scope.saveUserBirth = (valid) ->
        $scope.user.birth = $scope.birthday
        if saveUser()
          alertService.addInfo 'Birthday successfully edited', ALERT_CONSTANTS.SUCCESS_TIMEOUT
          $scope.toggleSection 'save'

      $scope.saveUserGender = ->
        if saveUser()
          alertService.addInfo 'Gender successfully edited', ALERT_CONSTANTS.SUCCESS_TIMEOUT
          $scope.toggleSection 'save'

      $scope.saveUserTag = ->
        if saveUser()
          alertService.addInfo 'Headline successfully edited', ALERT_CONSTANTS.SUCCESS_TIMEOUT
          $scope.toggleSection 'save'

      $scope.saveUserLocation = ->
        if saveUser()
          alertService.addInfo 'Location successfully edited', ALERT_CONSTANTS.SUCCESS_TIMEOUT
          $scope.toggleLocationSection 'save'

      $scope.saveUserNationality = ->

        $httpProvider.defaults.headers.common['Authorization'] = sessionService.authenticationToken()

        if user.nationalities.length > 0
          if $scope.isCandidate 
            nationality = new CandidateNationalities()
            nationality.candidate_id = $scope.user.uid
          else 
            nationality = new EmployerNationalities()
            nationality.employer_id = $scope.user.uid
          nationality.id = $scope.user.nationalities[0].id if $scope.user.nationalities.length > 0
        
        deferred = $q.defer()

        deleteNationality(nationality).then( (data) ->
          return saveNationality()
        ).then( (data) ->
          $scope.user.nationalities[0] = data.nationality
          $scope.toggleNationalitySection 'save'

          if $scope.isCandidate then $scope.newUserNationality = new CandidateNationalities() else $scope.newUserNationality = new EmployerNationalities()

          alertService.addInfo 'Nationality successfully edited', ALERT_CONSTANTS.SUCCESS_TIMEOUT
        ).catch alertService.defaultErrorCallback

      deleteNationality = (nationality)->
        nationality.$delete() if $scope.user.nationalities.length > 0

      saveNationality = ->
        $scope.newUserNationality.$save()

      init()
  ])

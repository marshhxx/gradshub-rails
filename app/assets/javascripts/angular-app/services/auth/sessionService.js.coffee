SessionService = ($location, $http, $q, $localStorage, oauthService, Candidate, Employer) ->

  login = (email, password) ->
    deferred = $q.defer()
    $http.post('/api/sessions', {session: {email: email, password: password}}).then((response) ->
      createSession(response.data.session)
      deferred.resolve({session: response.data.session})
    ).catch((response) ->
      deferred.reject(response)
    )
    deferred.promise

  logout = ->
    delete $localStorage.token
    delete $localStorage.userInfo

  requestCurrentUser = ->
    userInfo = parseUserInfo()
    deferred = $q.defer()
    if !userInfo or !userInfo.type
      deferred.reject({error: {reasons: ['There is no active session']}})
    else if userInfo.type == 'Candidate'
      Candidate.get({id: userInfo.user_uid}, (candidate) ->
        deferred.resolve(candidate)
      )
    else if userInfo.type == 'Employer'
      Employer.get({id: userInfo.user_uid}, (employer) ->
        deferred.resolve(employer)
      )
    deferred.promise

  isAuthenticated = ->
    $localStorage.token != undefined and $localStorage.token != null

  sessionType = ->
    info = parseUserInfo()
    if info then info.type else 'undefined'

  authenticationToken = ->
    $localStorage.token

  sendFgtPsswEmail = (email) ->
    $http.get('/api/sessions/password_reset?email=' + email)

  resetPassword = (user) ->
    $http.post('/api/sessions/password_reset', {user: user})

  loginLinkedin = (memberId, oauthToken, type)->
    deferred = $q.defer()
    oauthService.linkedin(memberId, oauthToken, type).then(
      (response) ->
        createSession(response.data.session)
        deferred.resolve({session: response.data.session})
    ).catch(
      (response) ->
        deferred.reject(response)
    )
    return deferred.promise

  refreshSession = ->
    deferred = $q.defer()
    $http.get('/api/sessions/refresh').then(
      (response) ->
        createSession(response.data.session)
        deferred.resolve({session: response.data.session})
    ).catch(
      (response) ->
        logout()
        deferred.reject(response)
    )

  parseUserInfo = ->
    JSON.parse($localStorage.userInfo) if $localStorage.userInfo

  createSession = (session)->
    $localStorage.token = session.auth_token
    $localStorage.userInfo = JSON.stringify({
      user_uid: session.uid,
      type: session.type
    })

  return {
    login: login,
    logout: logout,
    sessionType: sessionType,
    isAuthenticated: isAuthenticated,
    requestCurrentUser: requestCurrentUser,
    authenticationToken: authenticationToken,
    sendFgtPsswEmail: sendFgtPsswEmail,
    resetPassword: resetPassword,
    loginLinkedin: loginLinkedin,
    refreshSession: refreshSession
  }

angular.module('gradshub-ng.services')
  .factory('sessionService', SessionService)
OauthService = ($http)->
  service = {}

  service.linkedin = (uid, token, user_type) ->
    $http.get('/oauth/linkedin', params: {
      uid: uid,
      oauth_token: token,
      user_type: user_type
    })

  service

angular
  .module('mepedia.services')
  .factory("oauthService", OauthService)
PresenceService = (PubNub, $q) ->
  candidateChannel = 'gradshub_candidates'

  initialize = (uid) ->
    PubNub.init({
      publish_key: 'pub-c-23d6cfa9-2ab2-4dd8-97a0-47984369d1a4',
      subscribe_key: 'sub-c-7203d542-7782-11e5-8f88-02ee2ddab7fe',
      uuid: uid
    })

  join = (uid = null) ->
    if uid and !PubNub.initialized()
      initialize(uid)
    if PubNub.initialized()
      PubNub.ngSubscribe {channel: candidateChannel}

  leave = () ->
    if PubNub.initialized()
      PubNub.ngUnsubscribe {channel: candidateChannel}

  isOnline = (uid) ->
    deferred = $q.defer()
    if PubNub.initialized()
      channels = PubNub.ngWhereNow({
        uuid: uid,
        state: false
        callback: (message) ->
          deferred.resolve({isPresent: candidateChannel in message.channels})
        error: (error) ->
          deferred.reject(error)
      })
    deferred.promise

  return {
    initialize: initialize
    join: join
    leave: leave,
    isOnline: isOnline
  }

angular
  .module('gradshub-ng.services')
  .factory('presenceService', PresenceService);
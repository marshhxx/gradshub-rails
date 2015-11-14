PresenceService = (PubNub, $q, $rootScope) ->
  presenceChannel = 'gradshub_presence'
  userUid = null

  initialize = (uid) ->
    PubNub.init({
      publish_key: 'pub-c-23d6cfa9-2ab2-4dd8-97a0-47984369d1a4',
      subscribe_key: 'sub-c-7203d542-7782-11e5-8f88-02ee2ddab7fe',
      uuid: uid
    })
    userUid = uid

  join = (uid = null) ->
    if uid and !PubNub.initialized()
      initialize(uid)
    if PubNub.initialized()
      PubNub.ngSubscribe {
        channel: presenceChannel,
        presence: presence,
        message: message
        error: error
      }

  leave = () ->
    if PubNub.initialized()
      PubNub.ngUnsubscribe {channel: presenceChannel}

  isOnline = (uid) ->
    deferred = $q.defer()
    if PubNub.initialized()
      PubNub.ngWhereNow({
        uuid: uid,
        state: false
        callback: (message) ->
          deferred.resolve({isPresent: presenceChannel in message.channels})
        error: (error) ->
          deferred.reject(error)
      })
    deferred.promise

  call = (fromUid, toUid) ->
    if PubNub.initialized()
      PubNub.ngPublish({
        channel: presenceChannel,
        message: {
          action: 'call',
          timestamp: new Date().getTime(),
          caller: fromUid,
          receiver: toUid
        }
        error: (error) ->
          console.log error
      })


  # fire presence events
  presence = (details) ->
    event = details[0]
    $rootScope.$broadcast("#{presenceChannel}-#{event.uuid}-event", {event})
  # fire messages events
  message = (details) ->
    event = details[0]
    if event.action == 'call'
      $rootScope.$broadcast("calling-event", {event}) if event.receiver == userUid

  error = (error) ->
    console.log(error)

  return {
    initialize: initialize
    join: join
    leave: leave,
    isOnline: isOnline,
    call: call
  }

angular
  .module('gradshub-ng.services')
  .factory('presenceService', PresenceService);
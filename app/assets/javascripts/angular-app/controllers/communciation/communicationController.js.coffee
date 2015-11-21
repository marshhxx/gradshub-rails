class CommunicationController extends BaseController
  @register()
  # inject the dependencies
  @inject '$scope', '$stateParams', '$state', '$rootScope', '$timeout'

  # initialize the controller
  initialize: ->
    self = @
    @$scope.userPromise.then( ->
      if not self.$stateParams.beingCalled and not self.$scope.isEmployer
        self.$state.go('main.candidate_profile', {uid: 'me'}, { reload: true })
      else
        self._initPhone()
    )

  sendMessage: ->
    @session.send({ text : @$scope.message })
    displayMessage('ME', @$scope.message)
    @$scope.message = ''

  call: ->
    # notify of call started
    @_callNotification.bind(@)()
    displayVideos(@phone.video, @session.video)

  # private methods
  _initPhone: ->
    phone = PHONE({
      number        : @$scope.currentUser.uid,
      publish_key   : 'pub-c-23d6cfa9-2ab2-4dd8-97a0-47984369d1a4',
      subscribe_key : 'sub-c-7203d542-7782-11e5-8f88-02ee2ddab7fe',
      media         : { audio : true, video : true },
      ssl           : true
    })

    receiver = @$stateParams.receiver
    beingCalled = @$stateParams.beingCalled
    self = @

    # As soon as the phone is ready we can make calls
    phone.ready ->
      # for some reason it didn't like if we call immediately so we delay
      # the call 100 ms.
      self.$timeout(self._dial.bind(self), 100) if self.$stateParams.beingCalled

    # When Call Comes In or is to be Connected
    phone.receive (session) ->
      # Display Your Friend's Live Video
      session.connected(connected.bind(self))
      session.ended(ended.bind(self))

    phone.unable (details) ->
      console.log("Phone is unable to initialize.");
      console.log("Try reloading, or give up.");
      console.log('Unable to connect: ' + details)

    phone.message (session, message) ->
      if message.text.charAt(0) == "\u0001"
        displayVideos(self.phone.video, session.video)
        return
      displayMessage(session.number, message.text)

    @phone = phone

    @$rootScope.$on('$stateChangeStart', (event, toState, toParams, fromState, fromParams) ->
      if fromState.name == 'main.communication'
        phone.hangup()
        phone.disconnect()
    )

  _dial: () ->
    # Dial a Number and get the Call Session
    session = @phone.dial(@$stateParams.receiver)

  _callNotification: ->
    @session.send({ text : "\u0001" + "calling" + "\u0001" })

  connected = (session) ->
    @session = session

  ended = (session) ->
    @phone.hangup()

  displayVideo = (div, video) ->
    ele = angular.element(document.querySelector("##{div}"))
    child.remove() for child in ele.children()
    ele.append(video)
    return

  displayVideos = (myVideo, otherVideo) ->
    # Display their video
    displayVideo('videoOut', otherVideo)
    # Display own video
    displayVideo('videoIn', myVideo)

  displayMessage = (who, message) ->
    display = angular.element(document.querySelector("#display"))
    display.append('<p><b>' + who + ': </b> ' + message + '</p>')
    return

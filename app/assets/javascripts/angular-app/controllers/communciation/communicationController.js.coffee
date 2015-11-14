class CommunicationController extends BaseController
  @register()
  # inject the dependencies
  @inject '$scope', '$stateParams', '$state', '$rootScope'

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
    @phone.send({ text : @$scope.message })
    displayMessage('ME', @$scope.message)
    @$scope.message = ''

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
      self.$scope.dial = self._dial.bind(self)

    phone.debug (details) ->
      console.log(details)

    # When Call Comes In or is to be Connected
    phone.receive (session) ->
      # Display Your Friend's Live Video
      session.connected(connected)
      session.ended (session) ->
        phone.hangup()
        console.log("Bye!")

    phone.unable (details) ->
      console.log("Phone is unable to initialize.");
      console.log("Try reloading, or give up.");
      console.log('Unable to connect: ' + details)

    phone.message (session, message) ->
      displayMessage(session.number, message.text)

    @phone = phone

    @$rootScope.$on('$stateChangeStart', (event, toState, toParams, fromState, fromParams) ->
      if fromState.name == 'main.communication'
        phone.hangup()
        phone.disconnect()
    )

  _dial: ->
    # Dial a Number and get the Call Session
    session = @phone.dial(@$stateParams.receiver)

  connected = (session) ->
    # Display their video
    displayVideo('videoOut', session.video)
    # Display own video
    displayVideo('videoIn', @phone.video)

  displayVideo = (div, video) ->
    ele = angular.element(document.querySelector("##{div}"))
    child.remove() for child in ele.children()
    ele.append(video)
    return

  displayMessage = (who, message) ->
    display = angular.element(document.querySelector("#display"))
    display.append('<p><b>' + who + ': </b> ' + message + '</p>')
    return



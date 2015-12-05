class CommunicationController extends BaseController
  @register()
  # inject the dependencies
  @inject '$scope', '$stateParams', '$state', '$rootScope', '$timeout'

  # initialize the controller
  initialize: ->
    self = @
#    @$scope.userPromise.then( ->
#      if not self.$stateParams.beingCalled and not self.$scope.isEmployer
#        self.$state.go('main.candidate_profile', {uid: 'me'}, { reload: true })
#      else
#        self._initPhone()
#    )

  sendMessage: ->
    return if @$scope.message == ''
    @phone.send({ text : @$scope.message }, @$stateParams.receiver)
    displayMessage('ME', @$scope.message)
    @$scope.message = ''

  # starts the call
  call: ->
    # Dial a Number and get the Call Session.
    @session = @phone.dial(@$stateParams.receiver)

  # ends the call
  hangup: ->
    # finishes the session but foesn't hungup the phone.
    @session.hangup()

  # toggle the audio.
  toggleMute: ->
    @mediaConfig.audio = !@mediaConfig.audio
    @phone.updateMedia(@mediaConfig)

  # toggle de video
  toggleVideo: ->
    @mediaConfig.video = !@mediaConfig.video
    @phone.updateMedia(@mediaConfig)

  # private methods
  _initPhone: ->
    @mediaConfig = { audio : true, video : true }
    phone = PHONE({
      number        : @$scope.currentUser.uid,
      publish_key   : 'pub-c-23d6cfa9-2ab2-4dd8-97a0-47984369d1a4',
      subscribe_key : 'sub-c-7203d542-7782-11e5-8f88-02ee2ddab7fe',
      media         : @mediaConfig,
      ssl           : true
    })

    receiver = @$stateParams.receiver
    beingCalled = @$stateParams.beingCalled
    self = @

    # As soon as the phone is ready we can make calls
    phone.ready ->
      # Display own video
      displayVideo('videoIn', self.phone.video)

    # When Call Comes In or is to be Connected
    phone.receive (session) ->
      # Display Your Friend's Live Video
      session.connected(connected.bind(self))
      session.ended(self.hangup.bind(self))

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

  # some private methods

  connected = (session) ->
    displayVideo('videoOut', session.video)

  displayVideo = (div, video) ->
    ele = angular.element(document.querySelector("##{div}"))
    child.remove() for child in ele.children()
    ele.append(video)
    return

  displayMessage = (who, message) ->
    display = angular.element(document.querySelector("#display"))
    display.append('<p><b>' + who + ': </b> ' + message + '</p>')
    return

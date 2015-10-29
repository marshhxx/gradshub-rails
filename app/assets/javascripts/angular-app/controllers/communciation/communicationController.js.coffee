class CommunicationController extends BaseController
  @register()
  # inject the dependencies
  @inject '$scope', '$stateParams', '$document'

  # initialize the controller
  initialize: ->
    phone = PHONE({
      number        : @$stateParams.caller,
      publish_key   : 'pub-c-23d6cfa9-2ab2-4dd8-97a0-47984369d1a4',
      subscribe_key : 'sub-c-7203d542-7782-11e5-8f88-02ee2ddab7fe',
      media         : { audio : true, video : true },
      ssl           : true
    })

    receiver = @$stateParams.receiver

    # As soon as the phone is ready we can make calls
    phone.ready ->
      # Dial a Number and get the Call Session
      session = phone.dial(receiver)
      displayVideo('videoIn', phone.video)

    # When Call Comes In or is to be Connected
    phone.receive (session) ->
      # Display Your Friend's Live Video
      session.connected (session) ->
        displayVideo('videoOut', session.video)

    phone.unable (details) ->
      console.log("Phone is unable to initialize.");
      console.log("Try reloading, or give up.");
      console.log(details)

    phone.message (session, message) ->
      displayMessage(session.number, message.text)

    @phone = phone


  sendMessage: ->
    @phone.send({ text : @$scope.message })
    displayMessage('ME', @$scope.message)
    @$scope.message = ''

  # private methods
  displayVideo = (div, video) ->
    ele = angular.element(document.querySelector("##{div}"))
    child.remove() for child in ele.children()
    ele.append(video)

  displayMessage = (who, message) ->
    display = angular.element(document.querySelector("#display"))
    display.append('<p><b>' + who + ': </b> ' + message + '</p>')


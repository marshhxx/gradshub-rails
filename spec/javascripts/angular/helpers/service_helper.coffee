beforeEach(module('gradshub-ng.services'))
# mock Pubnub
beforeEach ->
  module ($provide) ->
    PubNubMock = {
      ngSubscribe: ->,
      ngUnsubscribe: ->,
      initialized: ->,
      ngWhereNow: ->,
      init: ->
    }
    $provide.value 'PubNub', PubNubMock
    null

#=require service_helper
#=require spec_helper

describe 'Unit test for the session service', ->

  beforeEach ->
    @oauthService = @model('oauthService')
    @candidate = @model('Candidate')
    @employer = @model('Employer')
    @localStorage = @model('$localStorage')
    @localStorage.$reset()
    @service = @model('sessionService')

    @mockSessionCall = (method, url, status, sessionMock) ->
      @http.when(method, url).respond(status, sessionMock)

    @failIfNotUndefined = (response) ->
      expect(response).toBeUndefined

    @assertLocalStorage = (token, uid, type) ->
      # assert local storage for session
      expect(@localStorage.token).toEqual(token)
      expect(@localStorage.userInfo).toEqual(JSON.stringify({
        user_uid: uid,
        type: type
      }))

    @createSessionMock = (uid, email, token, type) ->
      return {
        session: {
          uid: uid,
          email: email,
          auth_token: token,
          type: type
        }
      }

  describe 'test login', ->

    it 'with right user', ->
      session = @createSessionMock('uid', 'email@google.com', 'token', 'someType')
      @mockSessionCall('POST', '/api/sessions', 200, session)

      @service.login('email@google.com','password').then (response) ->
        expect(response).toEqual(session)
      .catch(@failIfNotUndefined)

      @http.expectPOST('/api/sessions')
      @http.flush()
      # assert local storage for session
      @assertLocalStorage('token', 'uid', 'someType')

    it 'with wrong user', ->
      @mockSessionCall('POST', '/api/sessions', 400)

      @service.login('email@google.com','password').then(@failIfNotUndefined).catch (response) ->
        expect(response.status).toEqual(400)

      @http.expectPOST('/api/sessions')
      @http.flush()

  describe 'test logout', ->

    it 'destroys local storage info', ->
      expect(@localStorage.token).toBeUndefined
      expect(@localStorage.userInfo).toBeUndefined

      @localStorage.token = "token"
      @localStorage.userInfo = JSON.stringify({
        user_uid: "uid",
        type: "Type"
      })

      @service.logout()

      expect(@localStorage.token).toBeUndefined
      expect(@localStorage.userInfo).toBeUndefined

    it 'normal login/logout flow', ->
      session = @createSessionMock('uid', 'email@google.com', 'token', 'someType')
      @mockSessionCall('POST', '/api/sessions', 200, session)
      @service.login('email@google.com','password')
      @http.flush()
      @service.logout()

      expect(@localStorage.token).toBeUndefined
      expect(@localStorage.userInfo).toBeUndefined

  describe 'test sessionType', ->

    it 'when no session', ->
      expect(@service.sessionType()).toEqual ('undefined')

    it 'when session exists', ->
      @localStorage.userInfo = JSON.stringify({
        user_uid: "uid",
        type: "type"
      })

      expect(@service.sessionType()).toEqual('type')

    it 'after calling log in', ->
      session = @createSessionMock('uid', 'email@google.com', 'token', 'someType')
      @mockSessionCall('POST', '/api/sessions', 200, session)
      @service.login('email@google.com','password')
      @http.flush()

      expect(@service.sessionType()).toEqual('someType')

  describe 'test login linkedin', ->
    it 'with right user', ->
      session = @createSessionMock('uid', 'email@google.com', 'token', 'someType')
      defer = @q.defer()
      defer.resolve({data: session})
      spyOn(@oauthService, 'linkedin').and.returnValue(defer.promise)

      @service.loginLinkedin('memberId','token', 'type').then (response) ->
        expect(response).toEqual(session)
      .catch(@failIfNotUndefined)

      @scope.$digest()
      # assert local storage for session
      @assertLocalStorage('token', 'uid', 'someType')

  describe 'test refresh session', ->
    it 'with right credentials', ->
      session = @createSessionMock('uid', 'email@google.com', 'token', 'someType')
      @mockSessionCall('GET', '/api/sessions/refresh', 200, session)

      @service.refreshSession().then (response)->
        expect(response).toEqual(session)
      .catch(@failIfNotUndefined)

      @http.expectGET('/api/sessions/refresh')
      @http.flush()
      # assert local storage for session
      @assertLocalStorage('token', 'uid', 'someType')

    it 'with bad credentials', ->
      @mockSessionCall('GET', '/api/sessions/refresh', 401)

      @service.refreshSession().then(@failIfNotUndefined).catch (response) ->
        expect(response.status).toEqual(401)

      @http.expectGET('/api/sessions/refresh')
      @http.flush()

    it 'when session expired', ->
      session = @createSessionMock('uid', 'email@google.com', 'token', 'someType')
      @mockSessionCall('GET', '/api/sessions/refresh', 200, session)

      # assert local storage for session
      @service.refreshSession()
      @http.flush()
      @assertLocalStorage('token', 'uid', 'someType')

      @mockSessionCall('GET', '/api/sessions/refresh', 401)
      @service.refreshSession()
      @http.flush()

      # session should be deleted
      expect(@localStorage.token).toBeUndefined
      expect(@localStorage.userInfo).toBeUndefined

  describe 'test request current user', ->

    beforeEach ->
      @mockUser = (type) ->
        {"#{type}": {name: "some #{type}"}}

    it 'when candidate logged', ->
      mockUser = @mockUser('candidate')
      @localStorage.userInfo = JSON.stringify({
        user_uid: "uid",
        type: "Candidate"
      })
      # mock the candidate response promise
      defer = @q.defer()
      defer.resolve({data: mockUser})
      spyOn(@candidate, 'get').and.returnValue(defer.promise)
      # call method
      @service.requestCurrentUser().then (response) ->
        expect(response).toEqual(mockUser)
      .catch(@failIfNotUndefined)

      @scope.$digest()
      expect(@candidate.get).toHaveBeenCalled()

    it 'when employer logged', ->
      mockUser = @mockUser('employer')
      @localStorage.userInfo = JSON.stringify({
        user_uid: "uid",
        type: "Employer"
      })
      # mock the candidate response promise
      defer = @q.defer()
      defer.resolve({data: mockUser})
      spyOn(@employer, 'get').and.returnValue(defer.promise)
      # call method
      @service.requestCurrentUser().then (response) ->
        expect(response).toEqual(mockUser)
      .catch(@failIfNotUndefined)

      @scope.$digest()
      expect(@employer.get).toHaveBeenCalled()

    it 'when not user logged', ->
      @service.requestCurrentUser().then(@failIfNotUndefined).catch (error) ->
        expect(error).toEqual({error: {reasons: ['There is no active session']}})



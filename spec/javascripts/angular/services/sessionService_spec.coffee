#=require service_helper
#=require spec_helper

describe 'Unit test for the session service', ->

  beforeEach ->
    @oauthService = @model('oauthService')
    @presenceService = @model('presenceService')
    @candidate = @model('Candidate')
    @employer = @model('Employer')
    @localStorage = @model('$localStorage')
    @localStorage.$reset()
    @service = @model('sessionService')

    @mockSessionCall = (method, url, status, sessionMock = null) ->
      @http.when(method, url).respond(status, sessionMock)

    @failIfNotUndefined = (response) ->
      expect(response).toBeUndefined()

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

    @createLocalSession = (token, uid, type) ->
      @localStorage.token = token
      @localStorage.userInfo = JSON.stringify({
        user_uid: uid,
        type: type
      })

    spyOn(@presenceService, 'initialize')
    spyOn(@presenceService, 'join')
    spyOn(@presenceService, 'leave')


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
      expect(@presenceService.initialize).toHaveBeenCalled()

    it 'with wrong user', ->
      @mockSessionCall('POST', '/api/sessions', 400)

      @service.login('email@google.com','password').then(@failIfNotUndefined).catch (response) ->
        expect(response.status).toEqual(400)

      @http.expectPOST('/api/sessions')
      @http.flush()
      expect(@presenceService.initialize).not.toHaveBeenCalled()
      expect(@presenceService.join).not.toHaveBeenCalled()

  describe 'test logout', ->

    it 'destroys local storage info', ->
      expect(@localStorage.token).toBeUndefined()
      expect(@localStorage.userInfo).toBeUndefined()

      @createLocalSession("token", "uid", "Candidate")
      @service.logout()

      expect(@presenceService.leave).toHaveBeenCalled()
      expect(@localStorage.token).toBeUndefined()
      expect(@localStorage.userInfo).toBeUndefined()

    it 'normal login/logout flow', ->
      session = @createSessionMock('uid', 'email@google.com', 'token', 'someType')
      @mockSessionCall('POST', '/api/sessions', 200, session)
      @service.login('email@google.com','password')
      @http.flush()
      @service.logout()

      expect(@presenceService.initialize).toHaveBeenCalled()
      expect(@presenceService.leave).toHaveBeenCalled()
      expect(@localStorage.token).toBeUndefined()
      expect(@localStorage.userInfo).toBeUndefined()

  describe 'test sessionType', ->

    it 'when no session', ->
      expect(@service.sessionType()).toEqual ('undefined')

    it 'when session exists', ->
      @createLocalSession("token", "uid", "type")
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
      expect(@presenceService.initialize).toHaveBeenCalled()
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
      expect(@presenceService.initialize).toHaveBeenCalled()

    it 'with bad credentials', ->
      @mockSessionCall('GET', '/api/sessions/refresh', 401)

      @service.refreshSession().then(@failIfNotUndefined).catch (response) ->
        expect(response.status).toEqual(401)

      @http.expectGET('/api/sessions/refresh')
      @http.flush()
      expect(@presenceService.initialize).not.toHaveBeenCalled()

  describe 'test request current user', ->

    beforeEach ->
      @mockUser = (type) ->
        {"#{type}": {name: "some #{type}"}}

    it 'when candidate logged', ->
      mockUser = @mockUser('candidate')
      @createLocalSession("token", "uid", "Candidate")

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
      @createLocalSession("token", "uid", "Employer")

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

  describe 'test presence ', ->

    it 'when user subscribes', ->
      session = @createSessionMock('uid', 'email@google.com', 'token', 'Candidate')
      @mockSessionCall('POST', '/api/sessions', 200, session)

      @service.login('email@google.com','password').then (response) ->
        expect(response).toEqual(session)
      .catch(@failIfNotUndefined)
      @http.flush()

      expect(@presenceService.initialize).toHaveBeenCalled()
      expect(@presenceService.join).toHaveBeenCalled()

    it 'user unsubscribes', ->
      @createLocalSession("token", "uid", "Candidate")
      @service.logout()

      expect(@presenceService.leave).toHaveBeenCalled()

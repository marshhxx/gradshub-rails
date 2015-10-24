
beforeEach inject (_$httpBackend_, _$compile_, $rootScope, $controller, $injector, $location, $timeout, $q) ->
    @scope = $rootScope.$new()
    @http = _$httpBackend_
    @compile = _$compile_
    @location = $location
    @controller = $controller
    @injector = $injector
    @timeout = $timeout
    @model = (name) =>
        @injector.get(name)
    @eventLoop =
        flush: =>
    @scope.$digest()
    @q = $q

afterEach ->
    @http.resetExpectations()
    @http.verifyNoOutstandingExpectation()
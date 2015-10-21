#=require service_helper
#=require spec_helper

describe 'Navbar Service Test', ->
  beforeEach ->
    @service = @model('navbarService')

  it 'test get/set', ->
    options = {login: true}
    expect(@service.getOptions()).toEqual({})

    @service.setOptions(options)
    expect(@service.getOptions()).toBe(options)

  it 'test clear', ->
    options = {login: true}
    @service.setOptions(options)

    expect(@service.getOptions()).toBe(options)
    @service.clearOptions()
    expect(@service.getOptions()).toEqual({})


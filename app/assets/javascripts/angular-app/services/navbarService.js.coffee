NavbarService = () ->
  options = {}

  getOptions = ->
    options

  setOptions = (navOptions) ->
    options = navOptions

  clearOptions = ->
    options = {}

  return {
    getOptions: getOptions,
    setOptions: setOptions,
    clearOptions: clearOptions
  }

angular
  .module('gradshub-ng.services')
  .factory("navbarService", NavbarService)


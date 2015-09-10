SearchService = ($http) ->
  service = {}


  #Infinite scroll option, add 8 "temp" users when scroll reachs bottom
  service.search = (keyword) ->
    return $http.get('/api/search', {params: {q: keyword, max: 16}})

  return service

angular
.module('mepedia.services')
.factory("searchService", SearchService)
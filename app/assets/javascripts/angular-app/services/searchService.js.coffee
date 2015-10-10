SearchService = ($http) ->
  service = {}

  # service that calls the search users endpoint
  service.search = (keyword, page=1, perPage=16) ->
    return $http.get('/api/search', {params: {q: keyword, page: page, per_page: perPage}})

  return service

angular
  .module('gradshub-ng.services')
  .factory("searchService", SearchService)
/*
 To use this service:
 1) If you want to get all the states from one country:

 $scope.getStateByCountryId = (countryId) ->
     states = State.get {country_id: countryId}, -> //get + country_id
     $scope.states = states.states
 */
var State = function($resource) {
  return $resource('/api/countries/:country_id/states/:id', {country_id: '@country_id', id: '@id'},
      {
          query: {
              method: 'GET',
              isArray: false
          }
      });
};
angular
    .module('mepedia.services')
    .factory('State', State);
/*
 To use this service:
 1) If you want to get all the states from one country:

 $scope.getStateByCountryId = (countryId) ->
     states = State.get {country_id: countryId}, -> //get + country_id
     $scope.states = states.states
 */

angular.module('mepedia.services').factory('State', function($resource) {
    return $resource('/api/countries/:country_id/states/:id');
});
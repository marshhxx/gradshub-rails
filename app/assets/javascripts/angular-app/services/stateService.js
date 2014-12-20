angular.module('mepedia.services').factory('State', function($resource) {
    return $resource('/api/countries/:country_id/states/:id');
});
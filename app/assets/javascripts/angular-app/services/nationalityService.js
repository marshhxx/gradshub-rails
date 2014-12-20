angular.module('mepedia.services').factory('Nationality', function($resource) {
    return $resource('/api/nationalities');
});
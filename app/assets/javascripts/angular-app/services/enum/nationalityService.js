/*
 To use this service:
 1) If you want to get all nationalities

 nationalities = Nationality.query -> //get() all nationalities
     $scope.nationalities = nationalities.nationalities
 */
var Nationality = function($resource) {
    return $resource('/api/nationalities',
        {id: '@id'},
        {
            query: {
                method: 'GET',
                isArray: false,
                cache: true
            }
        })
};
angular
    .module('gradshub-ng.services')
    .factory('Nationality', Nationality);
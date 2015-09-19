/*
 To use this service:
 1) get All majors

 var majors = Major.query(function() {
 console.log(majors);
 }); //query() returns all the entries

 */
var Major = function($resource) {
    return $resource('/api/majors/:id',
        {id: '@id'},
        {
            query: {
                method: 'GET',
                isArray: false,
                cache: true
            }
        });
};
angular
    .module('gradshub-ng.services')
    .factory('Major', Major);
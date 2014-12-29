/*
 To use this service:
 1) get All majors

 var majors = Major.query(function() {
 console.log(majors);
 }); //query() returns all the entries

 */
angular.module('mepedia.services').factory('Major', function($resource) {
    return $resource('/api/majors');
});
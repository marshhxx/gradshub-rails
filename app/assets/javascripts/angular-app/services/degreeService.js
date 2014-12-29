/*
 To use this service:
 1) get All degrees

 var degrees = Degree.query(function() {
 console.log(degrees);
 }); //query() returns all the entries

 */
angular.module('mepedia.services').factory('Degree', function($resource) {
    return $resource('/api/degrees');
});
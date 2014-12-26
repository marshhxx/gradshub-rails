/*
 To use this service:
 1) get All schools

 var countries = Contry.query(function() {
 console.log(countries);
 }); //query() returns all the entries

 */
angular.module('mepedia.services').factory('School', function($resource) {
    return $resource('/api/schools');
});
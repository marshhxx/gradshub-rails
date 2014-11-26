/*
To use this service:
 1) If you want to get all countries:

 var countries = Contry.query(function() {
 console.log(countries);
 }); //query() returns all the entries

 */
angular.module('mepedia.services').factory('Country', function($resource) {
    return $resource('/api/countries/:id');
});
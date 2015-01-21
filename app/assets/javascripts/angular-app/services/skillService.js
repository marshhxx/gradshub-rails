/*
 To use this service:
 1) get All Skills

 var countries = Contry.query(function() {
 console.log(countries);
 }); //query() returns all the entries

 */
angular.module('mepedia.services').factory('Skill', function($resource) {
    return $resource('/api/skills');
});
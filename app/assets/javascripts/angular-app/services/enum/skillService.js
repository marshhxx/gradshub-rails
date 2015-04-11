/*
 To use this service:
 1) get All Skills

 var countries = Contry.query(function() {
 console.log(countries);
 }); //query() returns all the entries

 */
var Skill = function($resource) {
    return $resource('/api/skills/:id',
        {id: '@id'},
        {
            query: {
                method: 'GET',
                isArray: false
            }
        });
};
angular
    .module('mepedia.services')
    .factory('Skill', Skill);
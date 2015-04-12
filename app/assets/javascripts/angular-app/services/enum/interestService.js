/*
 To use this service:
 1) get All Skills

 var countries = Contry.query(function() {
 console.log(countries);
 }); //query() returns all the entries

 */
var Interest = function($resource) {
    return $resource('/api/interests',
        {id: '@id'},
        {
            query: {
                method: 'GET',
                isArray: false
            }
        })
};
angular
    .module('mepedia.services')
    .factory('Interest', Interest);
/*
 To use this service:
 1) get All schools

 var countries = Contry.query(function() {
 console.log(countries);
 }); //query() returns all the entries

 */
var School = function($resource) {
    return $resource('/api/schools/:id',
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
    .module('mepedia.services')
    .factory('School', School);
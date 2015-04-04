/*
 To use this service:
 1) get All degrees

 var degrees = Degree.query(function() {
 console.log(degrees);
 }); //query() returns all the entries

 */
var Degree = function($resource) {
    return $resource('/api/degrees/:id',
        {id: '@id'},
        {
            query: {
                method: 'GET',
                isArray: false
            }
        })
}

angular
    .module('mepedia.services')
    .factory('Degree', Degree);
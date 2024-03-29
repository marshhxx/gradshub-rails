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
                isArray: false,
                cache: true
            }
        })
}

angular
    .module('gradshub-ng.services')
    .factory('Degree', Degree);
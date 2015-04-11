/*
To use this service:
 1) If you want to get all countries:

 var countries = Country.get(function() {
 console.log(countries);
 }); //get() returns all the entries

 */
var Country = function ($resource) {
  return $resource('/api/countries/:id', { id: '@id'},
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
    .factory('Country', Country);
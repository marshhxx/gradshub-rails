/*
 To use this service:
 1) If you want to get all nationalities

 nationalities = Nationality.get -> //get() all nationalities
     $scope.nationalities = nationalities.nationalities
 */
angular.module('mepedia.services').factory('Nationality', function($resource) {
    return $resource('/api/nationalities');
});
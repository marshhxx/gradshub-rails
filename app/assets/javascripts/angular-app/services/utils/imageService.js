var Upload  = function($http, $q, $upload) {
  var service = {}

  service.uploadImage = function(file) {
    var deferred = $q.defer();
      $upload.upload({
      url: "/api/image/upload", file: file
      }).progress(function (e) {

      }).success(function (data, status, headers, config) {
          deferred.resolve(data);
      }).error(function (error) {
          deferred.reject(error);
      });
    return deferred.promise;
  }
  return service;
};  

//Upload.$inject
angular.module('mepedia.services')
.factory('imageService', ['$http','$q','$upload', Upload]);

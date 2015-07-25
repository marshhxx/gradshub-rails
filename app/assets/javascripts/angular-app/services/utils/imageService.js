var Upload  = function($http, $q, $upload, alertService) {
  var service = {}

  service.uploadImage = function(file) {
    var error = false;
    var deferred = $q.defer();
    if (file.size > 10485760) {
      var reason = 'The file is too big, please select a file with no more than 10 mb';
      alertService.addErrorMessage(reason, 10000);
      deferred.reject('Image is too large');
      error = true;
    }

    if (!error){
      $upload.upload({
        url: "/api/image/upload", file: file
        }).success(function (data, status, headers, config) {
            deferred.resolve(data);
        }).error(function (error) {
            deferred.reject(error);
      });
    }
    return deferred.promise;
  }

  service.deleteImage = function(publicId) {
    var deferred = $q.defer();
    var delete_url = "/api/image/delete";

    $http.delete('/api/image/delete', {params: {public_id: publicId}}).
      success(function (response) {
        deferred.resolve(response);
      }).
      error(function (response) {
        deferred.reject(response);
      });
    return deferred.promise;
  }

  return service;
};  

//Upload.$inject
angular.module('mepedia.services')
.factory('imageService', ['$http','$q','$upload', 'alertService', Upload]);

var Upload  = function($http, $q, $upload, cloudinaryService) {
  var service = {}
  var cloudName = 'mepediacobas';

  service.config = function () {
    $.cloudinary.config({
      'cloud_name': cloudName
    });
  }
  service.checkFileSize = function(size) {
    var flag = true;
    // Check if the file is bigger thank 10 mb
    if (size > 10485760) {
      flag = false;
    }
    return flag;
  }

  service.uploadImage = function(file) {
    var error = false;
    var deferred = $q.defer();
    if (!service.checkFileSize(file.size)) {
      deferred.reject({error: {reasons: ['The file is too big, please select a file with no more than 10 mb']}});
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

  service.getThumbnail = function(imageData, cloudinaryData) {
    return cloudinaryService.getThumbnail(imageData, cloudinaryData);
  }

  service.deleteImage = function(publicId) {
    var deferred = $q.defer();

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
.factory('imageService', ['$http','$q','$upload', 'cloudinaryService', Upload]);

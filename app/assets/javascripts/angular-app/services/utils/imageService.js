var Upload  = function($http, $q, $upload) {
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
      deferred.reject('cloudinary_image_size_error');
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
    return $.cloudinary.image(cloudinaryData.public_id, {
      secure: true,
      width: imageData.w,
      height: imageData.h,
      x: imageData.x,
      y: imageData.y,
      crop: 'crop'
    });
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
.factory('imageService', ['$http','$q','$upload', Upload]);

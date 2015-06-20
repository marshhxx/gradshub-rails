var Cloudinary = function ($upload, $q, crypt, $httpProvider) {

    var cloudinary = {}
    var title;
    var apiKey = '723254833421314';
    var apiSecret = '05hwa4MfqVrK_tKFwz1Nx1Umg38';
    var cloudName = 'mepediacobas';

    cloudinary.config = function () {
        $.cloudinary.config({
            'cloud_name': cloudName
        });
    }

    cloudinary.uploadImage = function (file) {
        var deferred = $q.defer();
        var timestamp = (new Date).getTime() / 1000, // in seconds
            max_width = '1920', //in pixels
            max_height = '1080', //in pixels
            transformation_parameter = 'w_'+max_width+',h_'+max_height+',c_limit',
            tags = 'temp_cover',
            signature = crypt.hash('tags='+tags+'&timestamp='+timestamp+'&transformation='+transformation_parameter+apiSecret);

        $upload.upload({
            url: "https://api.cloudinary.com/v1_1/" + $.cloudinary.config().cloud_name + "/image/upload?transformation=" + transformation_parameter,
            data: {
                api_key: apiKey,
                timestamp: timestamp,
                signature: signature,
                tags: tags
            },
            file: file
        }).progress(function (e) {

        }).success(function (data, status, headers, config) {
            deferred.resolve(data);
        }).error(function (error) {
            deferred.reject(error);
        });
        return deferred.promise;
    }

    cloudinary.getThumbnail = function (imageData, cloudinaryData) {
        return $.cloudinary.image(cloudinaryData.public_id, {
            secure: true,
            width: imageData.w,
            height: imageData.h,
            x: imageData.x,
            y: imageData.y,
            crop: 'crop'
        });
    }

    cloudinary.deleteImage = function (publicId) {
        var deferred = $q.defer();
        var delete_url = "https://api.cloudinary.com/v1_1/" + $.cloudinary.config().cloud_name + "/image/destroy";
        var timestamp = (new Date).getTime() / 1000; // in seconds
        var signature = crypt.hash('public_id=' + publicId + '&timestamp=' + timestamp + apiSecret);

        var data = {
            public_id: publicId,
            api_key: apiKey,
            timestamp: timestamp,
            signature: signature
        };

        //Delete previous cover image
        $httpProvider.post(delete_url, data).
            success(function (data, status, headers, config) {
                // this callback will be called asynchronously when the response is available
                deferred.resolve(data);
            }).
            error(function (data, status, headers, config) {
                // called asynchronously if an error occurs or server returns response with an error status.
                deferred.reject(data);
            });

        return deferred.promise;
    }

    return cloudinary;

}
angular
    .module('mepedia.services')
    .factory('Cloudinary', ['$upload', '$q', 'crypt', '$http', Cloudinary]);
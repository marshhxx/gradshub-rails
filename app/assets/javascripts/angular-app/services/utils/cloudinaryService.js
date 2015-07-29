var Cloudinary = function ($upload, $q, crypt, $httpProvider, alertService) {

    var cloudinary = {}
    var cloudName = 'mepediacobas';

    cloudinary.config = function () {
        $.cloudinary.config({
            'cloud_name': cloudName
        });
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

    return cloudinary;

}
angular
    .module('mepedia.services')
    .factory('cloudinaryService', ['$upload', '$q', 'crypt', '$http', 'alertService',Cloudinary]);

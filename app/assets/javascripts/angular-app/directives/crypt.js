var getHash = function () {
    return {
        hash: function (value) {
            return CryptoJS.SHA1(value).toString();
        }
    };
};

angular
    .module('mepedia.directives')
    .factory('crypt', getHash);


var getHash = function () {
    return {
        hash: function (value) {
            var str = JSON.stringify(value);
        //    return CryptoJS.SHA1(str).toString();
        }
    };
}

angular
    .module('mepedia.directives')
    .factory('crypt', getHash)


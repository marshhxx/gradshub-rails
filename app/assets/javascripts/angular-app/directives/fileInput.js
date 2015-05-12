angular.module('mepedia.directives').directive('fileInput', function ($parse) {
    return {
        restrict: "EA",
        template: "<div><input type='file' id='files' class='hidden'/> <label class='coverImageEdit img' for='files'></label></div>",
        replace: true,
        link: function (scope, element, attrs) {

            var modelGet = $parse(attrs.fileInput);
            var modelSet = modelGet.assign;
            var onChange = $parse(attrs.onChange);

            var updateModel = function () {
                scope.$apply(function () {

                    modelSet(scope, element[0].querySelector('#files').files[0]);
                    onChange(scope);
                });
            };

            element.bind('change', updateModel);
        }
    };
});
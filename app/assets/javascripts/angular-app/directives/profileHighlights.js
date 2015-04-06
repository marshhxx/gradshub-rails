angular.module('mepedia.directives').directive('profileHighlights', function () {
    return {
        scope: {
            user: '=data',
            userAge: '='
        },
        templateUrl: 'angular-app/templates/directives/profileHighlights.html',
        link: function (scope, element, attrs) {


        }
    };
});

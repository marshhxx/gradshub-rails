angular.module('mepedia.directives').directive('education', function () {
    return {
        scope: {
            education: '=data'
        },
        templateUrl: 'angular-app/templates/directives/education.html'
    };
});

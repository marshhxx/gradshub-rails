angular.module('mepedia.directives').directive('addExperience', function () {
    return {
        scope: {
            experience: '=data', //Experience array
            saveExperience: '=', //SaveExperience function
            addExperienceEnable: '=', //Experience ng-show ng-hide variable
            enablePlaceholder: '=',
            defaultExperience: '='
        },
        templateUrl: 'angular-app/templates/directives/add-experience.html',
        link: function (scope, element, attrs) {

            scope.addExperience = function () {
                scope.addExperienceEnable = true;
                clearAddExperienceValues();
                scope.enablePlaceholder();
            };

            var clearAddExperienceValues = function () {
                scope.newExperienceForm.$submitted = false;
                scope.newExperienceForm.$setPristine();
                scope.experience.company_name = "";
                scope.experience.job_title = "";
                scope.experience.description = "";
                scope.experience.start_date = null;
                scope.experience.end_date = null;
            };

            /* Methods */

            scope.onCancel = function () {
                scope.addExperienceEnable = false;
                scope.experience = [];
                scope.defaultExperience();
            };
        }
    };
});

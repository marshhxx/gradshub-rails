angular.module('gradshub-ng.directives').directive('addExperience', function (Utils) {
    return {
        scope: {
            experience: '=data', //Experience array
            saveExperienceCallback: '=saveExperience', //SaveExperience function
            onAdd: '=',
            onCancelClick: '=onCancel'
        },
        templateUrl: 'angular-app/templates/directives/add-experience.html',
        link: function (scope, element, attrs) {

            scope.notMe = Utils.notMe();

            scope.addExperience = function () {
                scope.addExperienceEnable = true;
                clearAddExperienceValues();
                scope.onAdd();
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

            scope.saveExperience = function(valid) {
                if (valid) {
                    scope.addExperienceEnable = false;
                    scope.onCancelClick();
                    scope.saveExperienceCallback(valid);
                }
            };

            /* Methods */
            scope.onCancel = function () {
                scope.addExperienceEnable = false;
                scope.experience = [];
                scope.onCancelClick();
            };

            scope.$watchGroup(['experience.start_date', 'experience.end_date'], function () {
                var valid = Date.parse(scope.experience.end_date) >= Date.parse(scope.experience.start_date);
                valid = scope.experience.end_date == null || valid;
                scope.newExperienceForm.$setValidity('validDates', valid)
            });
        }
    };
});

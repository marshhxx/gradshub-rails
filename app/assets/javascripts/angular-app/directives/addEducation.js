angular.module('mepedia.directives').directive('addEducation', function () {
    return {
        scope: {
            education: '=data', //Education array
            saveEducationCallback: '=saveEducation', //Save education controller function
            onAdd: '=',
            onCancelClick: '=onCancel'
        },
        templateUrl: 'angular-app/templates/directives/add-education.html',
        link: function (scope, element, attrs) {

            scope.addEducation = function () {
                scope.addEducationEnable = true;
                clearAddEducationValues();
                scope.onAdd();
            };

            var clearAddEducationValues = function () {
                scope.newEducationForm.$setUntouched();
                scope.newEducationForm.$submitted = false;
            };

            scope.saveEducation = function (valid) {
                if (valid) {
                    scope.addEducationEnable = false;
                    scope.onCancelClick();
                    scope.saveEducationCallback(valid);
                }
            };

            /* Methods */

            scope.onSchool = function (school) {
                if (school != undefined)
                    scope.education.school_id = school.id;
            };

            scope.onState = function (state) {
                if (state != undefined)
                    scope.education.state_id = state.id;
            };

            scope.onCountry = function (country) {
                if (country != undefined)
                    scope.education.country_id = country.id;
            };

            scope.onMajor = function (major) {
                if (major != undefined)
                    scope.education.major_id = major.id
            };

            scope.onDegree = function (degree) {
                if (degree != undefined)
                    scope.education.degree_id = degree.id
            };

            scope.onCancel = function () {
                scope.addEducationEnable = false;
                scope.education = [];
                scope.onCancelClick();
            };

            scope.$watchGroup(['education.start_date', 'education.end_date'], function () {
                var valid = Date.parse(scope.education.end_date) >= Date.parse(scope.education.start_date);
                valid = scope.education.end_date == null || valid;
                scope.newEducationForm.$setValidity('validDates', valid)
            });
        }
    };
});

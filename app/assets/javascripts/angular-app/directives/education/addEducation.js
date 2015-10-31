angular.module('gradshub-ng.directives').directive('addEducation', function (Utils) {
    return {
        scope: {
            education: '=data', //Education array
            saveEducationCallback: '=saveEducation', //Save education controller function
            onAdd: '=',
            onCancelClick: '=onCancel'
        },
        templateUrl: 'angular-app/templates/directives/add-education.html',
        link: function (scope, element, attrs) {

            scope.notMe = Utils.notMe();

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
                if (!school) return;
                if (Utils.isObject(school)) {
                    scope.education.school_id = school.id;
                } else {
                    scope.education.other_school = school
                }
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
                if (!major) return;
                if (Utils.isObject(major)) {
                    scope.education.major_id = major.id;
                } else {
                    scope.education.other_major = major
                }
            };

            scope.onDegree = function (degree) {
                if (!degree) return;
                if (Utils.isObject(degree)) {
                    scope.education.degree_id = degree.id;
                } else {
                    scope.education.other_degree = degree
                }
            };

            scope.onCancel = function () {
                scope.addEducationEnable = false;
                scope.education = [];
                scope.onCancelClick();
            };
        }
    };
});

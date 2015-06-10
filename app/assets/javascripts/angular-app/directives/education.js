angular.module('mepedia.directives').directive('education', function (Utils) {
    return {
        scope: {
            education: '=data',
            updateEducation: '=',
            onDeleteCallback: '=onDelete'
        },
        templateUrl: 'angular-app/templates/directives/education.html',
        link: function (scope, element, attrs) {

            scope.onEducationEditor = function () {
                scope.educationTemp =  angular.copy(scope.education);
                scope.educationTemp.country_id = scope.education.country ? scope.education.country.id : null;
                scope.educationTemp.state_id = scope.education.state ? scope.education.state.id : null;
                scope.educationEditor = true;
            };

            /* Methods */

            scope.onSave = function (valid, index) {
                if (valid) {
                    scope.education.school_id = scope.educationTemp.school.id;
                    scope.education.major_id = scope.educationTemp.major.id;
                    scope.education.degree_id = scope.educationTemp.degree.id;
                    scope.education.country_id = scope.educationTemp.country_id;
                    scope.education.state_id = scope.educationTemp.state_id;
                    scope.education.description = scope.educationTemp.description;
                    scope.education.start_date = scope.educationTemp.start_date;
                    if (scope.isCurrentEducation)
                        scope.educationTemp.end_date = undefined;
                    scope.education.end_date = scope.educationTemp.end_date;
                    scope.educationEditor = false;
                    scope.updateEducation(valid, index);
                }
            };

            scope.onDelete = function (index) {
                scope.educationEditor = false;
                scope.onDeleteCallback(index);
            };

            scope.onCancel = function () {
                scope.educationEditor = false;
            };

            scope.onSchool = function (school) {
                if (school != undefined) {
                    scope.educationTemp.school_id = school.id;
                    scope.educationTemp.school = school;
                }
            };

            scope.onState = function (state) {
                scope.educationTemp.state_id = state ? state.id : null;
                scope.educationTemp.state = state;
            };

            scope.onCountry = function (country) {
                scope.educationTemp.country_id = country ? country.id : null;
                //scope.educationTemp.country.id = country ? country.id : null;
                scope.educationTemp.country = country;
                scope.educationTemp.state = null;
                scope.educationTemp.state_id = null;
            };

            scope.onMajor = function (major) {
                if (major != undefined)
                    scope.educationTemp.major_id = major.id;
            };

            scope.onDegree = function (degree) {
                if (degree != undefined)
                    scope.educationTemp.degree_id = degree.id;
            };

            scope.getMonth = Utils.getMonthByNumber;

            scope.education.end_date ? scope.isCurrentEducation = false : scope.isCurrentEducation = true;

            scope.$watchGroup(['educationTemp.start_date', 'educationTemp.end_date'], function () {
                if(scope.educationTemp) {
                    var valid = Date.parse(scope.educationTemp.end_date) >= Date.parse(scope.educationTemp.start_date);
                    valid = scope.educationTemp.end_date == null || valid;
                    scope.educationForm.$setValidity('validDates', valid)
                }
            });
        }
    };
});

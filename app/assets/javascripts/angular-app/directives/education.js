angular.module('mepedia.directives').directive('education', ['State', 'Country', 'School', 'Major', 'Degree', function (State, Country, School, Major, Degree) {
    return {
        scope: {
            education: '=data',
            updateEducation: '=',
            educationEditor: '=',
            onDelete: '='
        },
        templateUrl: 'angular-app/templates/directives/education.html',
        link: function (scope, element, attrs) {

            scope.onEducationEditor = function () {
                scope.educationTemp =  angular.copy(scope.education);
                scope.educationEditor = true;
            };

            /* Methods */

            scope.onSave = function (valid, index) {
                scope.education.school_id = scope.educationTemp.school_id;
                scope.education.major_id = scope.educationTemp.major_id;
                scope.education.degree_id = scope.educationTemp.degree_id;
                scope.education.country_id = scope.educationTemp.country_id;
                scope.education.description = scope.educationTemp.description;
                scope.education.start_date = scope.educationTemp.start_date;
                if (scope.isCurrentEducation)
                    scope.educationTemp.end_date = undefined;
                scope.education.end_date = scope.educationTemp.end_date;
                scope.updateEducation(valid, index);
            };

            scope.onCancel = function () {
                scope.educationEditor = false;
            };

            scope.onSchool = function (school) {
                if (school != undefined)
                    scope.educationTemp.school_id = school.id;
            };

            scope.onState = function (state) {
                if (state != undefined)
                    scope.educationTemp.state_id = state.id;
            };

            scope.onCountry = function (country) {
                if (scope.educationTemp.country != undefined)
                    scope.educationTemp.country_id = country.id;
            };

            scope.onMajor = function (major) {
                if (major != undefined)
                    scope.educationTemp.major_id = major.id;
            };

            scope.onDegree = function (degree) {
                if (degree != undefined)
                    scope.educationTemp.degree_id = degree.id;
            };

            scope.education.end_date ? scope.isCurrentEducation = false : scope.isCurrentEducation = true;

            angular.element('#switchEditingEducation').bootstrapSwitch({
                state: scope.isCurrentEducation
            });
            
            angular.element('#switchEditingEducation').on('switchChange.bootstrapSwitch', function(event, state) {
                state ? scope.isCurrentEducation = true : scope.isCurrentEducation = false;
                scope.$apply();
            });

            scope.$watchGroup(['educationTemp.start_date', 'educationTemp.end_date'], function () {
                if(scope.educationTemp) {
                    var valid = Date.parse(scope.educationTemp.end_date) >= Date.parse(scope.educationTemp.start_date);
                    valid = scope.educationTemp.end_date || valid;
                    scope.educationForm.$setValidity('validDates', valid)
                }
            });
        }
    };
}]);

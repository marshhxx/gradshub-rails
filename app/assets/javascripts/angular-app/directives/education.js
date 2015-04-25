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
        }
    };
}]);

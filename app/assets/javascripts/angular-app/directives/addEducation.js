angular.module('mepedia.directives').directive('addEducation', function () {
    return {
        scope: {
            education: '=data', //Education array
            saveEducation: '=', //Save education controller function
            addEducationEnable: '=' //Education ng-show ng-hide variable binded with controller
        },
        templateUrl: 'angular-app/templates/directives/add-education.html',
        link: function (scope, element, attrs) {
            scope.addEducation = function() {
                scope.addEducationEnable = true;
                clearAddEducationValues();
            };

            var clearAddEducationValues = function(){
                scope.newEducationForm.$setUntouched();
            };

            /* Methods */

            scope.onSchool = function (school) {
                if (school != undefined)
                    scope.education.school_id = school.id;
            };

            scope.onState = function(state) {
                if (state != undefined)
                    scope.education.state_id = state.id;
            };

            scope.onCountry = function(country) {
                if (country != undefined)
                    scope.education.country_id = country.id;
            };

            scope.onMajor = function(major) {
                if (major != undefined)
                    scope.education.major_id = major.id
            };

            scope.onDegree= function(degree) {
                if (degree != undefined)
                    scope.education.degree_id = degree.id
            };

            scope.onCancel = function() {
                scope.addEducationEnable = false;
                scope.education = [];
            };
            
            // switch education
            angular.element('#switchEducation').bootstrapSwitch();

            scope.isCurrentEducation = true;
            
            angular.element('#switchEducation').on('switchChange.bootstrapSwitch', function(event, state) {
                state ? scope.isCurrentEducation = true : scope.isCurrentEducation = false;
                scope.$apply();
            });
        }

    };
});

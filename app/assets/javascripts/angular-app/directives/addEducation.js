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

            angular.element('#switchEducation').bootstrapSwitch();
            scope.isCurrentJob = true;
            angular.element('#switchEducation').on('switchChange.bootstrapSwitch', function(event, state) {
                state ? scope.isCurrentJob = true : scope.isCurrentJob = false;
                scope.$apply();
                //console.log(scope.$$childTail);
            });
            scope.startMonth = null;
            scope.startYear = null;
            scope.endMonth = null; 
            scope.endYear = null;
            scope.dateValid = true;
            scope.$on('dateSelected', function(event, args) {
                if (args['dateMonth'] && args['dateYear']) {
                    if (args['isStart']) {
                        scope.startMonth = parseInt(args['dateMonth']);
                        scope.startYear = args['dateYear'];
                    } else if (args['isEnd']) {
                        scope.endMonth = parseInt(args['dateMonth']);
                        scope.endYear = args['dateYear']
                    }
                }
                console.log(scope.startMonth)
                if (scope.startMonth && scope.startYear && scope.endMonth && scope.endYear) {
                    if (scope.startYear > scope.endYear) {
                        scope.dateValid = false;
                    } else if(scope.startMonth > scope.endMonth) {
                        scope.dateValid = false;
                    } else {
                        scope.dateValid = true;
                    }
                }
            })
        }

    };
});

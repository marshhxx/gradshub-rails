angular.module('mepedia.directives').directive('editCompany', ['EmployerCompany', function (EmployerCompany) {
    return {
        // NEEEED TO DO EVERYTHING
        scope: {
            employerCompany: '=data', //Education array
            saveCompany: '=', //Save education controller function
            addCompanyEnabled: '=' //Education ng-show ng-hide variable binded with controller
        },
        templateUrl: 'angular-app/templates/directives/editCompany.html',
        link: function (scope, element, attrs) {
            scope.editCompanyEnable = false;


            var init = function() {
                getData();
            }
            var getData = function(){
                //var user = scope.$parent;
                scope.$on('userLoaded', function() {
                    scope.employerUser = scope.$parent.user;
                    console.log(scope.employerUser);
                });
            }

            scope.enableCompanyEditor = function() {
                scope.editCompanyEnable = true;
            }





            scope.addEducation = function() {
                scope.addEducationEnable = true;
                clearAddEducationValues();
                getData();
            };

            var clearAddEducationValues = function(){
                scope.education.school = "";
                scope.education.degree = "";
                scope.education.major = "";
                scope.education.state = "";
                scope.education.country = "";
                scope.education.description = "";
                scope.education.start_date = "Start Year";
                scope.education.end_date = "End Year";
            }


            /* Methods */

            init();
        }

    };
}]);

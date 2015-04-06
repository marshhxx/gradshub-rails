angular.module('mepedia.directives').directive('editCompany', ['EmployerCompany', 'Utils', function (EmployerCompany, Utils) {
    return {
        // NEEEED TO DO EVERYTHING
        scope: {
            employerCompany: '=data',
            saveCompany: '=',
            addCompanyEnabled: '='
        },
        templateUrl: 'angular-app/templates/directives/editCompany.html',
        link: function (scope, element, attrs) {
            scope.editCompanyEnable = false;


            var init = function() {
                getData();
            }

            var getData = function(){
                scope.$on('userLoaded', function() {
                    scope.employerUser = scope.$parent.user;
                });
            }

            scope.enableCompanyEditor = function() {
                scope.editCompanyEnable = true;
            }

            scope.saveCompany = function() {
                if (scope.companyForm.$valid) {
                    scope.editCompanyEnable = false;
                    scope.$parent.saveEmployerCompany(scope.employerUser);
                    
                } else {

                }
            }

            scope.onCancel = function() {
                scope.editCompanyEnable = false;
            }

            /* Methods */

            init();
        }

    };
}]);

angular.module('mepedia.directives').directive('editCompany', ['EmployerCompany', function (EmployerCompany) {
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
                console.log(scope);
                scope.$on('userLoaded', function() {
                    scope.employerUser = scope.$parent.user;
                    //console.log(scope.employerCompany);
                });


            }

            scope.enableCompanyEditor = function() {
                scope.editCompanyEnable = true;
            }

            scope.saveCompany = function() {
                console.log(scope.employerCompany);
                if (form.companyName.$error.require) {
                    console.log('hola');
                    scope.editCompanyEnable = false;
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

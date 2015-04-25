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
            var temporaryEmployerCompany = '';

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
                temporaryEmployerCompany = scope.employerCompany.site_url;
            }

            scope.saveCompany = function() {
                if (scope.companyForm.$valid) {
                    scope.editCompanyEnable = false;
                    scope.$parent.saveEmployerCompany();
                    temporaryEmployerCompany = scope.employerCompany.site_url;
                }
            }

            scope.onCancel = function() {
                scope.editCompanyEnable = false;
                scope.employerCompany.site_url = temporaryEmployerCompany;
            }

            scope.onCountry = function(country) {
                console.log(country);

                if (country) {
                    scope.country = country.name;
                    scope.country_id = country.id;
                }
                console.log(scope.country_id);
            }

            scope.onCompanyState = function(state) {
                if (state) {
                    scope.companyState = state.name;
                    scope.state_id = state.id;
                }
                console.log(scope.state_id);
            }
            /* Methods */

            init();
        }

    };
}]);

angular.module('mepedia.directives').directive('editCompany', ['EmployerCompany', 'Utils', 'eventTracker',
    function (EmployerCompany, Utils, eventTracker) {
    return {
        // NEEEED TO DO EVERYTHING
        scope: {
            employerCompany: '=data',
            saveCompany: '=',
            addCompanyEnabled: '='
        },
        templateUrl: 'angular-app/templates/directives/edit-company.html',
        link: function (scope, element, attrs) {

            scope.notMe = Utils.notMe();
            scope.editCompanyEnable = false;

            var temporaryEmployerCompany = {};
            var temporaryEmployerCompanyName = '';

            var init = function() {
                getData();
            }

            var getData = function(){
                scope.$on('userLoaded', function() {
                    scope.employerUser = scope.$parent.user;
                });
            }

            scope.enableCompanyEditor = function() {
                console.log(scope.employerCompany);
                scope.editCompanyEnable = true;
                temporaryEmployerCompany.site_url = scope.employerCompany.site_url;
                temporaryEmployerCompanyName = scope.employerCompany.country.name;
                temporaryEmployerCompany.state = scope.employerCompany.state;
            }

            scope.saveCompany = function() {
                if (scope.companyForm.$valid) {
                    scope.editCompanyEnable = false;
                    scope.$parent.saveEmployerCompany();
                    temporaryEmployerCompany.site_url = scope.employerCompany.site_url;

                    eventTracker.saveCompanyInfo('Employer');
                }
            }

            scope.onCancel = function() {
                scope.editCompanyEnable = false;
                scope.employerCompany.site_url = temporaryEmployerCompany.site_url;
                scope.employerCompany.country.name = temporaryEmployerCompanyName;
                scope.employerCompany.state = temporaryEmployerCompany.state;
            }



            scope.onCountry = function(country) {
                if (country) {
                    scope.country_id = country.id;

                    scope.employerCompany.state = null;
                    scope.employerCompany.state_id = null;
                }
            }

            scope.onCompanyState = function(state) {
                if (state) {
                    scope.employerCompany.state = state
                    scope.state_id = state.id;
                }
            }
            /* Methods */

            init();
        }

    };
}]);

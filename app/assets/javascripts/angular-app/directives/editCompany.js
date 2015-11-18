EditCompany = function (EmployerCompany, Utils, eventTracker) {
    return {
        scope: {
            user: '=data',
            updateCompanyUser: '=',
            addCompanyEnabled: '='
        },
        templateUrl: 'angular-app/templates/directives/edit-company.html',
        link: function (scope, element, attrs) {

            scope.notMe = Utils.notMe();
            scope.editCompanyEnable = false;

            var init = function() {
                getData();
            }

            var getData = function(){
                scope.$on('userLoaded', function() {
                    scope.employerUser = scope.$parent.user;
                    scope.temporaryEmployerCompany = angular.copy(scope.employerUser.company);
                });
            }

            scope.enableCompanyEditor = function() {
                scope.editCompanyEnable = true;
            }

            scope.saveCompany = function() {
                if (scope.companyForm.$valid) {
                    scope.editCompanyEnable = false;
                    scope.user.company_name = scope.temporaryEmployerCompany.name;
                    scope.user.company_url = scope.temporaryEmployerCompany.site_url;
                    scope.user.company_industry = scope.temporaryEmployerCompany.industry;

                    scope.updateCompanyUser();

                    eventTracker.saveCompanyInfo('Employer');
                }
            }

            scope.onCancel = function() {
                scope.editCompanyEnable = false;

                scope.temporaryEmployerCompany = angular.copy(scope.employerUser.company);
            }

            /* Methods */

            init();
        }

    };
};
angular.module('gradshub-ng.directives')
       .directive('editCompany', ['EmployerCompany', 'Utils', 'eventTracker', EditCompany]);


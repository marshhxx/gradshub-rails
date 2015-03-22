angular.module('mepedia.directives').directive('education', [ 'State', function () {
    return {
        scope: {
            education: '=data',
            schools: '=',
            majors: '=',
            degrees: '=',
            countries: '='
        },
        templateUrl: 'angular-app/templates/directives/education.html',
        link      : function (scope, element, attrs) {

            scope.enableEducationEditor = function(){
                scope.educationEditor = true;
                scope.schools;

                scope.getStateByCountryId(scope.education.country.id);
                scope.states;
            }

           scope.getStateByCountryId = function(countryId) {
                State.query({country_id: countryId}, function(states) {
                    scope.states = states.states;
                });
            };


        }

    };
}]);

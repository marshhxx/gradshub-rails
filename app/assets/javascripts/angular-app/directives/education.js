angular.module('mepedia.directives').directive('education', ['State', function (State) {
    return {
        scope: {
            education: '=data',
            schools: '=',
            majors: '=',
            degrees: '=',
            countries: '=',
            years: '=',
            saveEducation: '=',
            updateEducation: '&',
            onState: '=',
            onCountry: '=',
            onMajor: '=',
            onDegree: '=',
            onSchool: '='

        },
        templateUrl: 'angular-app/templates/directives/education.html',
        link: function (scope, element, attrs) {

           scope.education.start_date = scope.education.start_date.split('-')[0];
           scope.education.end_date = scope.education.end_date.split('-')[0];

           scope.enableEducationEditor = function(){
                scope.educationEditor = true;
                scope.getStateByCountryId(scope.education.country.id);
           };

           scope.getStateByCountryId = function(countryId) {
                State.query({country_id: countryId}, function(states) {
                    scope.states = states.states;
                });
           };

            scope.setStartYear = function(year) {
                scope.education.start_date = year;
            };

            scope.setEndYear = function(year) {
                scope.education.end_date = year;
            };
        }

    };
}]);

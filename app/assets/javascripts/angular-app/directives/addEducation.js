angular.module('mepedia.directives').directive('addEducation', ['State', 'Country', 'School', 'Major', 'Degree', function (State, Country, School, Major, Degree) {
    return {
        scope: {
            education: '=data', //Education array
            saveEducation: '=', //Save education controller function
            addEducationEnable: '=' //Education ng-show ng-hide variable binded with controller
        },
        templateUrl: 'angular-app/templates/directives/addEducation.html',
        link: function (scope, element, attrs) {

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
                scope.education.start_date = null;
                scope.education.end_date = null;
            };

            var getData = function(){

                Country.query(function(countries) {
                    scope.countries = countries.countries;
                });

                School.get(function(schools) {
                    scope.schools = schools.schools;
                });

                Major.get(function(majors){
                    scope.majors = majors.majors;
                });

                Degree.get(function(degrees){
                    scope.degrees = degrees.degrees;
                });
            }

            /* Methods */

            scope.onSchool = function (school) {
                if (school != undefined)
                    scope.education.school = school
            };

            scope.onState = function(state) {
                if (state != undefined)
                    scope.education.state = state;
            };

            scope.onCountry = function(country) {
                scope.education.country = country
                if (scope.education.country != undefined)
                    scope.getStateByCountryId(scope.education.country.id);
            }

            scope.onMajor = function(major) {
                if (major != undefined)
                    scope.education.major = major
            };

            scope.onDegree= function(degree) {
                if (degree != undefined)
                    scope.education.degree = degree
            };

            scope.onCancel = function() {
                scope.addEducationEnable = false;
                scope.education = [];
            };

            scope.getStateByCountryId = function(countryId) {
                State.query({country_id: countryId}, function(states) {
                    scope.states = states.states;
                });
            };
        }

    };
}]);

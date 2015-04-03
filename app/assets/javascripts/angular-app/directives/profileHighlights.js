angular.module('mepedia.directives').directive('profileHighlights', function () {
    return {
        scope: {
            user: '=data'
        },
        templateUrl: 'angular-app/templates/directives/profileHighlights.html',
        link: function (scope, element, attrs) {


            var getData = function(){
                //scope.user;
              //  scope.hola = scope.user.educations[0];
              //  scope.chau = scope.user.experiences[0];

                var partsOfBirthday = scope.user.birth.split('-');
                var year = partsOfBirthday[0];
                var month = partsOfBirthday[1];
                var day = partsOfBirthday[2];

                calculateAge(year, month, day);
            }

            getData();


            var calculateAge = function (year, month, day) { // birthday is a date
                var d = new Date();
                d.setFullYear(year, month-1, day);
                var ageDifMs = Date.now() - d.getTime();
                var ageDate = new Date(ageDifMs); // miliseconds from epoch
                scope.age = Math.abs(ageDate.getUTCFullYear() - 1970);
            }
        }
    };
});

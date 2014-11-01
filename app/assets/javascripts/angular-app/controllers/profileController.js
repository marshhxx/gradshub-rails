angular.module('mepedia.controllers').controller('profileController',
    ['$scope', 'sessionService',
        function($scope, sessionService) {
            console.log("PROFILE");
            $scope.user = sessionService.requestCurrentUser()

            $scope.logout = function() {
                sessionService.logout()
            }
        }
    ]);
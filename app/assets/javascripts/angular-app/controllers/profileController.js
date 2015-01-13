angular.module('mepedia.controllers').controller('profileController',
    ['$scope', 'sessionService',
        function($scope, sessionService) {
            $scope.user = sessionService.requestCurrentUser()

            $scope.logout = function() {
                sessionService.logout()
            }
        }
    ]);
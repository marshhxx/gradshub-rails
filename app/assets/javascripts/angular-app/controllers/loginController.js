angular.module('mepedia.controllers').controller('loginController',
    ['$scope', '$state', 'sessionService', 'communicationPlatform',
    function($scope,$state, sessionService, communicationPlatform) {
        $scope.login = function() {
            if ($scope.email && $scope.password) {
                var promise = sessionService.login($scope.email, $scope.password, false);
                promise.then(
                    function (payload) {
                        var loginCommunication = communicationPlatform.loginUser(sessionService.requestCurrentUser(), $scope.password);
                        loginCommunication.then(
                            function(payload) {
                                console.log(payload)
                            },
                            function (errors) {
                                console.log(errors)
                            }
                        );
                        $state.go('main.profile');
                    },
                    function (errors) {
                        console.log(errors)
                    }
                );
            }
        }
    }
]);
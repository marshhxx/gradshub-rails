angular.module('mepedia.controllers').controller('loginController',
    ['$scope', '$state', 'sessionService',
        function ($scope, $state, sessionService) {
            $scope.login = function (isValid) {
                if (isValid) {
                    if ($scope.email && $scope.password) {
                        var promise = sessionService.login($scope.email, $scope.password, false);
                        promise.then(
                            function (payload) {
                                $state.go('main.profile');
                            },
                            function (errors) {
                                console.log(errors)
                            }
                        );
                    }
                } else {
                    $scope.loginSubmit = true;
                }
            }
        }
    ]);
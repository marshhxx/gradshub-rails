angular.module('mepedia.controllers').controller('loginController',
    ['$scope', '$state', 'sessionService',
        function ($scope, $state, sessionService) {
            $scope.randomLogin = function () {
                var images = ['one', 'other'];
                return images[Math.floor((Math.random() * 2) + 1) - 1];
            };

            $scope.login = function (isValid) {
                if (isValid) {
                    if ($scope.email && $scope.password) {
                        var promise = sessionService.login($scope.email, $scope.password, false);
                        promise.then(
                            function (resp) {
                                if (resp.type == 'Candidate')
                                    $state.go('main.candidate_profile');
                                else if (resp.type == 'Employer')
                                    $state.go('main.employer_profile');
                            }
                            ,
                            function (resp) {
                                $scope.serverErrors = resp.error;
                            }
                        );
                    }
                } else {
                    $scope.loginSubmit = true;
                }
            }
        }
    ]);
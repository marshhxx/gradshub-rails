angular.module('mepedia.controllers').controller('loginController',
    ['$scope', '$state', 'sessionService', 'alertService',
        function ($scope, $state, sessionService, alertService) {
            var randomLogin = function () {
                var images = ['one', 'other'];
                return images[Math.floor((Math.random() * 2) + 1) - 1];
            };

            $scope.randomPhoto = randomLogin();

            $scope.login = function (isValid) {
                if (isValid) {
                    if ($scope.email && $scope.password) {
                        var promise = sessionService.login($scope.email, $scope.password, false);
                        promise.then(
                            function (resp) {
                                if (resp.type == 'Candidate')
                                    $state.go('main.candidate_profile', {uid: 'me'});
                                else if (resp.type == 'Employer')
                                    $state.go('main.employer_profile', {uid: 'me'});
                            }
                        ).catch(
                            function (resp) {
                                alertService.addErrors(resp.error, 10000)
                            }
                        );
                    }
                } else {
                    $scope.loginSubmit = true;
                }
            }
        }
    ]);
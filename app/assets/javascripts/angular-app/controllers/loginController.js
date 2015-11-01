angular.module('gradshub-ng.controllers').controller('loginController',
  ['$scope', '$state', 'sessionService', 'alertService', '$sce', 'eventTracker', 'navbarService',
    function ($scope, $state, sessionService, alertService, $sce, eventTracker, navbarService) {
      var randomLogin = function () {
        var images = ['one', 'other'];
        return images[Math.floor((Math.random() * 2) + 1) - 1];
      };

      $scope.randomPhoto = randomLogin();
      navbarService.setOptions($state.current.data.navOptions) // Enable Navbar Options

            $scope.login = function (isValid) {
                if (isValid) {
                    if ($scope.email && $scope.password) {
                        var promise = sessionService.login($scope.email, $scope.password);
                        promise.then(
                            function (response) {
                                if (response.session.type == 'Candidate') {
                                    eventTracker.login(response.session.type);
                                    $state.go('main.candidate_profile', {uid: 'me'}, {reload: true});
                                } else if (response.session.type == 'Employer') {
                                    eventTracker.login(response.session.type);
                                    $state.go('main.employer_profile', {uid: 'me'}, {reload: true});
                                }
                            }
                        ).catch(
                            function (resp) {
                                alertService.addError(resp.data.error, 10000);
                            }
                        );
                    }
                } else {
                    $scope.loginSubmit = true;
                }
            }
    }
  ]);
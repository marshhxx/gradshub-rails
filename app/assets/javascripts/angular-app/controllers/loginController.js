app.controller('loginController',
    ['$scope', 'sessionService',
    function($scope, sessionService) {
        console.log("THERE");
        $scope.login = function() {
            if ($scope.email && $scope.password) {
                sessionService.login($scope.email, $scope.password);
            }
        }
    }
]);
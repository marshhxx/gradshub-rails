angular.module('mepedia.controllers').controller('loginController',
    ['$scope', 'sessionService',
    function($scope, sessionService) {

        $scope.login = function(isValid) {
            console.log(isValid);
            if(isValid) {
                if ($scope.email && $scope.password) {
                    sessionService.login($scope.email, $scope.password);
                }
            }else{
                console.log ("entro");
                $scope.loginSubmit = true;
            }
        }
    }
]);
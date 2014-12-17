angular.module('mepedia.controllers').controller('loginController',
    ['$scope', 'sessionService',
    function($scope, sessionService) {
        console.log("THERE");
        $scope.login = function() {
            if ($scope.email && $scope.password) {
                sessionService.login($scope.email, $scope.password);
            }
        }
        $scope.sendEmailForgotPassword = function() {

        	if ($scope.emailFgtPssw) {
        		sessionService.sendEmail($scope.email);
        	}
        }
        $scope.resetPassword = function() {
        	var pass1 = $scope.password1, 
        		pass2 = $scope.password2;
        	if (pass1 && pass2) {
        		console.log(pass1 + ' ' + pass2);
        	}
        }
    }
]);
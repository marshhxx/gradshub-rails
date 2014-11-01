angular.module('mepedia.services').factory('sessionService',
    ['$location', '$http',
        function($location, $http) {
        // Redirect to the given url (defaults to '/')
        function redirect(url) {
            url = url || '/';
            $location.path(url);
        }
        var service = {
            login: function(email, password) {
                return $http.post('/api/sessions', {session: {email: email, password: password} })
                    .success(function(response) {
                        service.currentUser = response.user;
                        if (service.isAuthenticated()) {
                            redirect('/profile')
                        }
                    })
                    .error(function(response) {
                        return response.errors;
                    });
            },

            logout: function() {
                $http.delete('/api/sessions/' + service.currentUser.auth_token)
                    .success(function(response) {
                        service.currentUser = null;
                        redirect();
                    })
                    .error(function(response) {
                        return response.errors;
                    });
            },

            register: function(email, password, confirm_password) {
                return $http.post('/users.json', {user: {email: email, password: password, password_confirmation: confirm_password} })
                    .then(function(response) {
                        service.currentUser = response.data;
                        if (service.isAuthenticated()) {
                            $location.path('/record');
                        }
                    });
            },
            requestCurrentUser: function() {
                if (service.isAuthenticated()) {
                    return service.currentUser;
                } else {
                    redirect()
                }
            },

            currentUser: null,

            isAuthenticated: function(){
                return !!service.currentUser;
            }
        };
        return service;
    }]);
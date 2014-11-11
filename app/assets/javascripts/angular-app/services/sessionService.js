angular.module('mepedia.services').factory('sessionService',
    ['$location', '$http','$q',
        function($location, $http, $q) {
        // Redirect to the given url (defaults to '/')
        function redirect(url) {
            url = url || '/';
            $location.path(url);
        }
        var service = {
            login: function(email, password) {
                var deferred = $q.defer();

                $http.post('/api/sessions', {session: {email: email, password: password} })
                    .success(function(response) {
                        service.currentUser = response.user;
                        deferred.resolve(service.currentUser);
                        if (service.isAuthenticated()) {
                            redirect('/profile')
                        }
                    })
                    .error(function(response) {
                        deferred.reject(response.errors)
                    });

                return deferred.promise;
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
angular.module('mepedia.services').factory('sessionService',
    ['$location', '$http','$q', 'User',
        function($location, $http, $q, User) {
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
                        service.currentUser = createUser(response.user);
                        deferred.resolve(service.currentUser);
                        if (service.isAuthenticated()) {
                            redirect('/main/signup/personal')
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

            isAuthenticated: function(){
                return !!service.currentUser;
            },

            authenticationToken: function() {
                if (service.isAuthenticated())
                    return service.auth_token;
            }

        };

        function createUser(rawUser) {
            var user = new User()
            user.name = rawUser.name
            user.lastname = rawUser.lastname
            user.email = rawUser.email
            user.uid = rawUser.uid
            service.auth_token = rawUser.auth_token
            return user
        }
        return service;
    }]);


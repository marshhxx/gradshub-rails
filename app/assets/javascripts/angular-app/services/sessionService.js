angular.module('mepedia.services').factory('sessionService',
    ['$location', '$http','$q','Session',
        function($location, $http, $q, Session) {
        // Redirect to the given url (defaults to '/')
        function redirect(url) {
            url = url || '/';
            $location.path(url);
        }
        var service = {
            login: function(email, password, rememberMe) {
                var deferred = $q.defer();

                $http.post('/api/sessions', {session: {email: email, password: password} })
                    .success(function(response) {
                        Session.create(response.user, rememberMe);
                        if (service.isAuthenticated()) {
                            deferred.resolve({authenticated: true})
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
                        Session.destroy();
                        redirect();
                    })
                    .error(function(response) {
                        return response.errors;
                    });
            },

            requestCurrentUser: function() {
                if (Session.available()) {
                    return Session.getUser();
                }
            },

            isAuthenticated: function(){
                return Session.available();
            },

            authenticationToken: function() {
                if (Session.available()) {
                    return Session.getToken();
                }
            },

            sendFgtPsswEmail: function(email) {
                var deferred = $q.defer();
                $http.get('/api/sessions/password_reset?email=' + email)
                    .success(function(status) {
                        deferred.resolve({status: status})
                    })
                    .error(function(msg, code) {
                        deferred.reject(msg);
                        console.log(msg, code);
                    });
                return deferred.promise;
            },

            resetPassword: function(user) {
                var deferred = $q.defer();
                $http.post('/api/sessions/password_reset', {user: user})
                    .success(function(status) {
                        deferred.resolve({status: status})
                    })
                    .error(function(msg, code) {
                        deferred.reject(msg);
                        console.log(msg, code);
                    });
                return deferred.promise;
            }

        };
        return service;
    }])
    .service('Session',['User', 'cookieJar', function (User, cookieJar) {
        this.available = function () {
            return !!this.token || cookieJar.isDefined("token");
        };
        this.create = function (user, remember) {
            this.token = user.auth_token;
            this.user = new User();
            this.user.name = user.name;
            this.user.lastname = user.lastname;
            this.user.email = user.email;
            this.user.uid = user.uid;
            if (remember) {
                cookieJar.put("current_user", this.user);
                cookieJar.put("token", this.token);
            }
        };
        this.destroy = function () {
            this.token = null;
            this.user = null;
            if (cookieJar.isDefined("current_user")) {
                cookieJar.delete("current_user");
                cookieJar.delete("token");
            }
        };
        this.getToken = function() {
            if (!!this.token) {
                return this.token;
            } else if (cookieJar.isDefined("token")) {
                return cookieJar.get("token");
            }
        };
        this.getUser = function() {
            if (!!this.user) {
                return this.user;
            } else if (cookieJar.isDefined("current_user")) {
                return cookieJar.get("current_user");
            }
        };
        return this;
    }]);


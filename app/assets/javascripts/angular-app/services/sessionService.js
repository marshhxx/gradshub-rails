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

                $http.post('/api/sessions', {session: {email: email, password: password} }
                ).success(function(response) {
                        Session.create(response.session, rememberMe);
                        if (service.isAuthenticated()) {
                            deferred.resolve({authenticated: true})
                        }
                    }
                ).error(function(response) {
                        deferred.reject(response.errors)
                    }
                );
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
                return Session.getUser();
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
    .factory('Session',
    ['Candidate', 'Employer', 'cookieJar', '$q', '$window', function (Candidate, Employer, cookieJar, $q, $window) {
        this.available = function () {
            return !!token || cookieJar.isDefined("token");
        };

        this.create = function (session, remember) {
            user_uid = session.uid;
            token = session.auth_token;
            remember = remember;
            type = session.type;
            $window.sessionStorage["userInfo"] = JSON.stringify(
                {
                    user_uid: user_uid,
                    token: token,
                    type: type
                })
        };

        this.destroy = function () {
            token = null;
            user = null;
            $window.sessionStorage["user"] = null;
            $window.sessionStorage["userInfo"] = null;
            if (cookieJar.isDefined("current_user")) {
                cookieJar.delete("current_user");
                cookieJar.delete("token");
            }
        };

        this.getToken = function() {
            if (!!token) {
                return token;
            } else if (cookieJar.isDefined("token")) {
                return cookieJar.get("token");
            }
        };

        this.getUser = function() {
            init();
            var deferred = $q.defer();
            if (typeof user !== 'undefined') {
                deferred.resolve({candidate: user});
            } else if (cookieJar.isDefined("current_user")) {
                deferred.resolve(cookieJar.get("current_user"));
            } else if (typeof user_uid !== 'undefined') {
                var setUser = function (oneUser) {
                    user = oneUser;
                    if (typeof remember !== 'undefined' && remember) {
                        cookieJar.put("current_user", user);
                        cookieJar.put("token", token);
                    }
                };
                if (type == 'Candidate') {
                    Candidate.get({id: user_uid}, function (candidate) {
                        setUser(candidate.candidate);
                        deferred.resolve(candidate);
                    });
                } else if (type == 'Employer') {
                    Employer.get({id: user_uid}, function(employer) {
                        setUser(employer.employer);
                        deferred.resolve(employer)
                    });
                }
            } else {
                deferred.reject({error: {reasons: ['There is no active session']}})
            }
            return deferred.promise;
        };

        var init = function() {
            if ($window.sessionStorage["userInfo"]) {
                userInfo = JSON.parse($window.sessionStorage["userInfo"]);
                token = userInfo.token;
                user_uid = userInfo.user_uid;
                type = userInfo.type;
            } else {
                token = undefined;
                user_uid = undefined;
                type = undefined;
            }

        };

        init();

        return this;
    }]);


angular.module('mepedia.services').factory('sessionService',
    ['$location', '$http','$q','Session',
        function($location, $http, $q, Session) {
        // Redirect to the given url (defaults to '/')
        var service = {
            login: function(email, password, rememberMe) {
                var deferred = $q.defer();

                $http.post('/api/sessions', {session: {email: email, password: password} }
                ).success(function(response) {
                        var type = Session.create(response.session, rememberMe);
                        if (service.isAuthenticated()) {
                            deferred.resolve({type: type})
                        }
                    }
                ).error(function(response) {
                        deferred.reject(response)
                    }
                );
                return deferred.promise;
            },

            logout: function() {
                var deferred = $q.defer();
                $http.delete('/api/sessions/' + Session.getToken())
                    .success(function(response) {
                        Session.destroy();
                        deferred.resolve({logout: true})
                    })
                    .error(function(response) {
                        deferred.reject(response.error);
                    });
                return deferred.promise;
            },

            sessionType: function() {
                return Session.type();
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

        this.type = function() {
          return type;
        };

        this.create = function (session, rememb) {
            user_uid = session.uid;
            token = session.auth_token;
            remember = rememb;
            type = session.type;
            $window.sessionStorage["userInfo"] = JSON.stringify(
                {
                    user_uid: user_uid,
                    token: token,
                    type: type
                });
            return type;
        };

        this.destroy = function () {
            token = undefined;
            user = undefined;
            delete $window.sessionStorage["userInfo"];
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
            if (cookieJar.isDefined("current_user")) {
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
            if ($window.sessionStorage["userInfo"] != null) {
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


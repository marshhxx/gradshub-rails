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
    .service('Session',
    ['Candidate', 'Employer', 'cookieJar', '$q', '$window', function (Candidate, Employer, cookieJar, $q, $window) {
        this.available = function () {
            return !!this.token || cookieJar.isDefined("token");
        };

        this.create = function (session, remember) {
            this.user_uid = session.uid;
            this.token = session.auth_token;
            this.remember = remember;
            this.type = session.type
            $window.sessionStorage["userInfo"] = JSON.stringify(
                {
                    user_uid: this.user_uid,
                    token: this.token,
                    type: this.type
                })
        };

        this.destroy = function () {
            this.token = null;
            this.user = null;
            $window.sessionStorage["user"] = null
            $window.sessionStorage["userInfo"] = null;
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
            var deferred = $q.defer();
            if (!!this.user) {
                deferred.resolve(this.user);
            } else if (cookieJar.isDefined("current_user")) {
                deferred.resolve(cookieJar.get("current_user"));
            } else if (!!this.user_uid) {
                var setUser = function (user) {
                    this.user = user;
                    $window.sessionStorage["user"] = JSON.stringify(user);
                    if (this.remember) {
                        cookieJar.put("current_user", user);
                        cookieJar.put("token", this.token);
                    }
                };
                if (this.type == 'Candidate') {
                    Candidate.get({id: this.user_uid}, function (candidate) {
                        setUser(candidate.candidate);
                        deferred.resolve(candidate);
                    });
                } else if (this.type == 'Emplpyer') {
                    Employer.get({id: this.user_uid}, function(employer) {
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
                this.token = userInfo.token;
                this.user_uid = userInfo.user_uid;
                this.type = userInfo.type;
            }
            if ($window.sessionStorage["user"]) {
                this.user = JSON.parse($window.sessionStorage["user"]);
            }
        };

        init();

        return this;
    }]);


angular.module('mepedia.controllers').controller('profileController',
    ['$scope', '$rootScope', '$upload', 'sessionService', '$state','Country', 'State', 'User',

        function($scope, $rootScope, $upload, sessionService, $state, Country, State, User) {

          /*  $scope.user = sessionService.requestCurrentUser()

            $scope.logout = function() {
                sessionService.logout()
            } */

          /* ---- Upload photo ---- */

            $scope.onFileSelect = function($files) {
                $.cloudinary.config({
                    'cloud_name' : 'mepediacobas',
                    'upload_preset': 'mepediacobas_unsigned_name'
                });

                var file = $files[0]; // we're not interested in multiple file uploads here
                $scope.upload = $upload.upload({
                    url: "https://api.cloudinary.com/v1_1/" + $.cloudinary.config().cloud_name + "/upload",
                    data: {upload_preset: $.cloudinary.config().upload_preset, tags: 'myphotoalbum', context:'photo=' + $scope.title},
                    file: file
                }).progress(function (e) {
                    $scope.progress = Math.round((e.loaded * 100.0) / e.total);
                    $scope.status = "Uploading... " + $scope.progress + "%";
                    $scope.$apply();
                }).success(function (data, status, headers, config) {
                    $rootScope.photos = $rootScope.photos || [];
                    data.context = {custom: {photo: $scope.title}};
                    $scope.result = data;
                    $rootScope.photos.push(data);
                    $scope.$apply();
                });
            };

            // Modify the look and fill of the dropzone when files are being dragged over it /
            $scope.dragOverClass = function($event) {
                var items = $event.dataTransfer.items;
                var hasFile = false;
                if (items != null) {
                    for (var i = 0 ; i < items.length; i++) {
                        if (items[i].kind == 'file') {
                            hasFile = true;
                            break;
                        }
                    }
                } else {
                    hasFile = true;
                }
                return hasFile ? "dragover" : "dragover-err";
            };

            /* ---- PERSONAL INFORMATION ---- */

            /* Data */

            var countries;
            countries = Country.get(function() {
                console.log(countries.countries);
                return $scope.countries = countries.countries;
            });

            $scope.getStateByCountryId = function(countryId) {
                var states;
                return states = State.get({
                    country_id: countryId
                }, function() {
                    return $scope.states = states.states;
                });
            };


            /* Request current user */
            var currentUser = sessionService.requestCurrentUser();
            if(currentUser != null) {
                User.get({id: currentUser.uid}).$promise.then(function (user) {
                    //success
                    $scope.user = user.user;
                    getPersonalInfo();

                }, function (errResponse) {
                    console.log(errResponse);
                });
            } else {
                $state.go('home.page');
            }



            //var user = User.query(userId);
//            var sessionUser = sessionService.requestCurrentUser();
//            User.get({id: sessionUser.uid})
//                .$promise.then(function(user) {
//                    $scope.user = user;
//            });

          /*  if ($scope.user == null) {

            }*/

//            if(user != null) {
//                console.log("user country " + user.user.country.country_id);
//                console.log("user country " + user.country);
//            }

           // $scope.user = {};
            $scope.tempPersonalInfo = {}
            $scope.personalInfo = {};
            var getPersonalInfo = function () {
                if($scope.user != null) {

                    // var country = $filter('getObjectById')(countries, user.country.id);

                    $scope.personalInfo.currentLocation = ($scope.user.country != null) ? (($scope.user.state.name != null) ? $scope.user.state.name + ", " + $scope.user.country.name : $scope.user.country.name) : "Add your current location";
                    $scope.tempPersonalInfo.currentLocation = $scope.personalInfo.currentLocation;
//                jobtitle: "Add",
//                major: "",
//                interest: "",
//                country: ""

                }
            }

            function getCurrentPosition(){

            }

            $scope.editorEnabled = false;

            $scope.enableEditor = function() {
                $scope.editorEnabled = true;
                $scope.user.jobtitle = $scope.tempUser.jobtitle;
                $scope.user.major = $scope.tempUser.major;
                $scope.user.interest = $scope.tempUser.interest;
                $scope.personalInfo.currentLocation = $scope.tempPersonalInfo.currentLocation;
            };

            $scope.disableEditor = function() {
                $scope.editorEnabled = false;
            };

            $scope.save = function() {
                $scope.tempUser.jobtitle = $scope.user.jobtitle;
                $scope.tempUser.major = $scope.user.major;
                $scope.tempUser.interest = $scope.user.interest;
                //$scope.tempUser.country = $scope.user.country;
                $scope.tempPersonalInfo.currentLocation = $scope.personalInfo.currentLocation;
                $scope.disableEditor();
            };

        }]);



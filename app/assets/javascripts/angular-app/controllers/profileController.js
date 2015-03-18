angular.module('mepedia.controllers').controller('profileController',
    ['$scope', '$rootScope', '$upload', 'sessionService', '$state','Country', 'State', 'User', 'Skill', '$http',

        function($scope, $rootScope, $upload, sessionService, $state, Country, State, User, Skill, $http) {

          /*  $scope.user = sessionService.requestCurrentUser()

            $scope.logout = function() {
                sessionService.logout()
            } */


            /* ---- Upload photo ---- */
            var cloudinary_data;
            $.cloudinary.config({
                'cloud_name' : 'mepediacobas',
                'upload_preset': 'mepediacobas_unsigned_name'
            });

            //<<<<<<<<<<<<<<< START COVER PHOTO >>>>>>>>>>>>>>>

            $scope.coverPhotoButtons = false;
            $scope.temporaryCoverPhoto = true;
            $scope.coverPhoto = false;
            $scope.coverImageSelectorVisible = true;
            $scope.coverLoaded = false;
            $scope.spinnerVisible = false;

            $scope.onFileSelectCover = function($files) {
                var file = $files[0]; // we're not interested in multiple file uploads here

                $scope.upload = $upload.upload({
                    url: "https://api.cloudinary.com/v1_1/" + $.cloudinary.config().cloud_name + "/upload",
                    data: {
                        upload_preset: $.cloudinary.config().upload_preset, 
                        tags: 'temp_cover', 
                        context:'photo=' + $scope.title
                    },
                    file: file
                }).progress(function (e) {
                    $scope.spinnerVisible = true;
                    $scope.progress = Math.round((e.loaded * 100.0) / e.total);
                    $scope.status = "Uploading... " + $scope.progress + "%";

                    if (!$scope.temporaryCoverPhoto) {
                        $scope.temporaryCoverPhoto = true;
                        angular.element('.spinner-container').css({
                        'z-index' : '10'
                    });
                    }

                    if (!$scope.$$phase) {
                        $scope.$apply();
                    }
                }).success(function (data, status, headers, config) {
                    cloudinary_data = data;
                    $rootScope.photos = $rootScope.photos || [];
                    data.context = {custom: {photo: $scope.title}};
                    $scope.resultCoverPhoto = data;
                    $rootScope.photos.push(data);
                    if (!$scope.$$phase) {
                        $scope.$apply();
                    } else {
                        $scope.coverPhotoData = data;
                    }
                });

            };

            var pictureCoverPhoto = angular.element('#temp_cover_photo');
            var contentCoverPhoto = angular.element('.contentGillotineCover');

            pictureCoverPhoto.on('load', function() {

                if ($scope.coverPhoto) {
                    $scope.coverPhoto = false;
                    angular.element('.spinner-container').css({
                        'z-index' : '0'
                    });
                }

                pictureCoverPhoto.guillotine({eventOnChange: 'guillotinechange', width: contentCoverPhoto[0].offsetWidth - 2, height: 315});
                var data = pictureCoverPhoto.guillotine('getData');

                for(var key in data) { $('#'+key).html(data[key]); }

                pictureCoverPhoto.on('guillotinechange', function(ev, data, action) {
                  data.scale = parseFloat(data.scale.toFixed(4));
                  for(var k in data) { $('#'+k).html(data[k]); }
                });

                $scope.coverImageSelectorVisible = false;
                $scope.coverPhotoButtons = true;
                $scope.coverLoaded = true;
                $scope.$apply();
            });

            $scope.saveCoverPhoto = function() {
                var data = pictureCoverPhoto.guillotine('getData');
                var cloudianary_result = $.cloudinary.image(cloudinary_data.public_id, {
                    secure: true,
                    width: data.w,
                    height: data.h,
                    x: data.x,
                    y: data.y,
                    crop: 'crop'
                });
                $scope.coverPhotoURI = cloudianary_result[0].src;
            };

            angular.element('.coverPhoto').on('load', function(){
                // we need to reset the guillotine plugin in order to call again later
                pictureCoverPhoto.guillotine('remove');

                $scope.spinnerVisible = false;
                $scope.temporaryCoverPhoto = false;
                $scope.coverPhoto = true;
                $scope.coverImageSelectorVisible = true;

                // it's necessary to call $apply in order to bind variables with the DOM
                $scope.$apply();
            });

            //<<<<<<<<<<<<<<< END COVER PHOTO >>>>>>>>>>>>>>>

            //<<<<<<<<<<<<<<< START PROFILE PHOTO >>>>>>>>>>>>>>>
            
            $scope.profilePhotoButtons = false;
            $scope.temporaryProfilePhoto = true;
            $scope.profilePhoto = false;
            $scope.profileImgSelectVisible = true;
            $scope.profilePhotoLoaded = false;
            $scope.spinnerVisibleProfile = false;

            $scope.onFileSelectProfile = function($files) {
                var file = $files[0]; // we're not interested in multiple file uploads here

                $scope.upload = $upload.upload({
                    url: "https://api.cloudinary.com/v1_1/" + $.cloudinary.config().cloud_name + "/upload",
                    data: {
                        upload_preset: $.cloudinary.config().upload_preset, 
                        tags: 'temp_profile', 
                        context:'photo=' + $scope.title
                    },
                    file: file
                }).progress(function (e) {
                    $scope.progressProfile = Math.round((e.loaded * 100.0) / e.total);
                    $scope.status = "Uploading... " + $scope.progressProfile + "%";
                    $scope.spinnerVisibleProfile = true;
                    $scope.profileImgSelectVisible = false;

                    if ($scope.profilePhoto) {
                        angular.element('.spinner-container-profile').css({
                            'z-index' : '10'
                        });
                    }

                    if (!$scope.$$phase) {
                        $scope.$apply();
                    }
                }).success(function (data, status, headers, config) {
                    cloudinary_data = data
                    $rootScope.photos = $rootScope.photos || [];
                    data.context = {custom: {photo: $scope.title}};
                    $scope.resultProfile = data;
                    $rootScope.photos.push(data);
                    if (!$scope.$$phase) {
                        $scope.$apply();
                    } else {
                        $scope.profileData = data;
                    }
                });
            };

            var pictureProfilePhoto = angular.element('#temp_profile_photo');

            pictureProfilePhoto.on('load', function() {

                if ($scope.profilePhoto) {
                    $scope.profilePhoto = false;
                    $scope.temporaryProfilePhoto = true;
                    angular.element('.spinner-container-profile').css({
                        'z-index' : '0'
                    });
                }

                pictureProfilePhoto.guillotine({eventOnChange: 'guillotinechange', width: 260, height: 260});

                var data = pictureProfilePhoto.guillotine('getData');

                for(var key in data) { $('#'+key).html(data[key]); }

                pictureProfilePhoto.on('guillotinechange', function(ev, data, action) {
                  data.scale = parseFloat(data.scale.toFixed(4));
                  for(var k in data) { $('#'+k).html(data[k]); }
                });

                angular.element('.edit-buttons-profile-photo').css({
                    'top': '205px',
                    'left': '57px'
                });

                $scope.profilePhotoLoaded = true;
                $scope.profilePhotoButtons = true;
                $scope.$apply();
            });

            $scope.saveProfilePhoto = function() {

                var data = pictureProfilePhoto.guillotine('getData');

                var cloudianary_result = $.cloudinary.image(cloudinary_data.public_id, {
                    secure: true,
                    width: data.w,
                    height: data.h,
                    x: data.x,
                    y: data.y,
                    crop: 'crop'
                });

                $scope.profilePhotoURI = cloudianary_result[0].src;
            };

            angular.element('.profilePhoto').on('load', function() {
                // we need to reset the guillotine plugin in order to call again later
                pictureProfilePhoto.guillotine('remove');

                $scope.spinnerVisibleProfile = false;
                $scope.temporaryProfilePhoto = false;
                $scope.profilePhoto = true;
                $scope.profileImgSelectVisible = true;
                $scope.$apply();

            });

            //<<<<<<<<<<<<<<< END PROFILE PHOTO >>>>>>>>>>>>>>>

            / Modify the look and fill of the dropzone when files are being dragged over it /
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
                $state.go('main.profile');
            }

            $scope.tempPersonalInfo = {}
            $scope.personalInfo = {};
            var getPersonalInfo = function () {
                if($scope.user != null) {
                    $scope.personalInfo.currentPosition = "Add your current position";
                    $scope.tempPersonalInfo.currentPosition = $scope.personalInfo.currentPosition;

                    $scope.personalInfo.education = "Add your education";
                    $scope.tempPersonalInfo.education = $scope.personalInfo.education;

                    $scope.personalInfo.topSkills = "Add your skills";
                    $scope.tempPersonalInfo.topSkills = $scope.personalInfo.topSkills;

                    $scope.personalInfo.currentLocation = ($scope.user.country != null) ? (($scope.user.state.name != null) ? $scope.user.state.name + ", " + $scope.user.country.name : $scope.user.country.name) : "Add your current location";
                    $scope.tempPersonalInfo.currentLocation = $scope.personalInfo.currentLocation;
                }
            }

            $scope.editorEnabled = false;

            $scope.enableEditor = function() {
                $scope.editorEnabled = true;

                $scope.personalInfo.currentPosition = $scope.tempPersonalInfo.currentPosition;
                $scope.personalInfo.education = $scope.tempPersonalInfo.education;
                $scope.personalInfo.topSkills = $scope.tempPersonalInfo.topSkills;
                $scope.personalInfo.currentLocation = $scope.tempPersonalInfo.currentLocation;
            };

            $scope.disableEditor = function() {
                $scope.editorEnabled = false;
            };

            $scope.save = function() {
                $scope.tempPersonalInfo.currentPosition = $scope.personalInfo.currentPosition;
                $scope.tempPersonalInfo.education = $scope.personalInfo.education;
                $scope.tempPersonalInfo.topSkills = $scope.personalInfo.topSkills;
                $scope.tempPersonalInfo.currentLocation = $scope.personalInfo.currentLocation;
                $scope.disableEditor();
            };

            /* SUMMARY */
            $scope.userSummary;
            $scope.profileSummary = "Write something about you";

            $scope.editorSummaryEnabled = false;

            $scope.enableSummaryEditor = function() {
                $scope.editorSummaryEnabled = true;
                if($scope.profileSummary != "Write something about you")
                    $scope.userSummary = $scope.profileSummary;
            };

            $scope.disableSummaryEditor = function() {
                $scope.editorSummaryEnabled = false;
            };

            $scope.saveSummary = function(){
                $scope.disableSummaryEditor();
                if($scope.userSummary != undefined  && $scope.userSummary != "" && $scope.userSummary.length > 0){
                    $scope.profileSummary = $scope.userSummary;
                } else {
                    $scope.profileSummary = "Write something about you";
                }
            }

            /* SKILLS */
            $scope.userSelectedSkills = [];
            $scope.selectedSkills = ["Add a skill"];
            var skills;
            skills = Skill.get(function() {
                return $scope.skillsTags = skills.skills;
            });

            $scope.editorSkillsEnabled = false;

            $scope.enableSkillsEditor = function() {
                $scope.editorSkillsEnabled = true;
                if($scope.selectedSkills.length > 0)
                    $scope.userSelectedSkills = $scope.selectedSkills.slice();
            };

            $scope.disableSkillsEditor = function() {
                $scope.editorSkillsEnabled = false;
            };

            $scope.saveSkills = function(){
                $scope.disableSkillsEditor();
                if($scope.userSelectedSkills.length > 0){
                    if($scope.userSelectedSkills[0] == "Add a skill")
                        $scope.userSelectedSkills.shift()
                    $scope.selectedSkills = $scope.userSelectedSkills.slice();
                } else {
                    $scope.selectedSkills.push("Add a skill");
                }
            }

            /* EARLY LIFE */
            $scope.userEarlyLife;
            $scope.profileEarlyLife = "Write something about your early life";

            $scope.editorEarlyLifeEnabled = false;

            $scope.enableEarlyLifeEditor = function() {
                $scope.editorEarlyLifeEnabled = true;
                if($scope.profileEarlyLife != "Write something about your early life")
                    $scope.userEarlyLife = $scope.profileEarlyLife;
            };

            $scope.disableEarlyLifeEditor = function() {
                $scope.editorEarlyLifeEnabled = false;
            };

            $scope.saveEarlyLife = function(){
                $scope.disableEarlyLifeEditor();
                if($scope.userEarlyLife != undefined  && $scope.userEarlyLife != "" && $scope.userEarlyLife.length > 0){
                    $scope.profileEarlyLife = $scope.userEarlyLife;
                } else {
                    $scope.profileEarlyLife = "Write something about your early life";
                }
            }

            /* PERSONAL LIFE */

            $scope.userPersonalLife;
            $scope.profilePersonalLife = "Write something about your personal life";
            $scope.editorPersonalLifeEnabled = false;

            $scope.enablePersonalLifeEditor = function() {
                $scope.editorPersonalLifeEnabled = true;
                if($scope.profilePersonalLife != "Write something about your personal life")
                    $scope.userPersonalLife = $scope.profilePersonalLife;
            };

            $scope.disablePersonalLifeEditor = function() {
                $scope.editorPersonalLifeEnabled = false;
            };

            $scope.savePersonalLife = function(){
                $scope.disablePersonalLifeEditor();
                if($scope.userPersonalLife != undefined  && $scope.userPersonalLife != "" && $scope.userPersonalLife.length > 0){
                    $scope.profilePersonalLife = $scope.userPersonalLife;
                } else {
                    $scope.profilePersonalLife = "Write something about your personal life";
                }
            }

            /* CAREER */

          /*  $scope.userCareer;
            $scope.profileCareer= "Write something about your personal life";
            $scope.editorCareerEnabled = false;

            $scope.enableCareerEditor = function() {
                $scope.editorCareerEnabled = true;
                if($scope.profileCareer != "Write something about your personal life")
                    $scope.userCareer = $scope.profileCareer;
            };

            $scope.disableCareerEditor = function() {
                $scope.editorPersonalLifeEnabled = false;
            };

            $scope.saveCareer= function(){
                $scope.disablePersonalLifeEditor();
                if($scope.userCareer != undefined  && $scope.userCareer != "" && $scope.userCareer.length > 0){
                    $scope.profileCareer = $scope.userCareer;
                } else {
                    $scope.profileCareer = "Write something about your personal life";
                }
            }*/




        }]);



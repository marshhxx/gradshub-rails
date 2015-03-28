angular.module('mepedia.controllers').controller('profileController',
    ['$scope', '$rootScope', '$http', '$upload', 'sessionService', '$state', 'Country', 'State', 'Candidate', 'Employer', 'Skill', 'School', 'Major', 'Degree', 'Education', 'CandidateSkills',

        function ($scope, $rootScope, $httpProvider, $upload, sessionService, $state, Country, State, Candidate, Employer, Skill, School, Major, Degree, Education, CandidateSkills) {

            /*  $scope.user = sessionService.requestCurrentUser()

             $scope.logout = function() {
             sessionService.logout()
             } */


            /* ---- Cloudinary Configuration ---- */
            var cloudinary_data;
            $.cloudinary.config({
                'cloud_name': 'mepediacobas',
                'upload_preset': 'mepediacobas_unsigned_name'
            });

            //<<<<<<<<<<<<<<< START COVER PHOTO >>>>>>>>>>>>>>>

            $scope.coverPhotoButtons = false;
            $scope.temporaryCoverPhoto = true;
            $scope.coverPhoto = false;
            $scope.coverImageSelectorVisible = true;
            $scope.coverLoaded = false;
            $scope.spinnerVisible = false;
            $scope.defaultCoverImageVisible = true;

            $scope.onFileSelectCover = function ($files) {
                var file = $files[0];

                /* when user select a photo HIDE the following elements: 
                 * - image selector button
                 * - save and cancel buttons
                 */
                $scope.coverImageSelectorVisible = false;
                $scope.coverPhotoButtons = false;

                // SHOW spinner
                $scope.spinnerVisible = true;

                /* when the user did not save any photo
                 * - SHOW the default cover photo
                 * - HIDE the cover photo loaded
                 */
                if (!$scope.coverPhotoURI) {
                    $scope.defaultCoverImageVisible = true;
                    $scope.coverLoaded = false;
                }

                /* when the temporary photo DIV is hidden
                 * - SHOW temporary photo DIV                
                 */
                if (!$scope.temporaryCoverPhoto) {
                    $scope.temporaryCoverPhoto = true;
                    angular.element('.spinner-container').css({
                        'z-index': '10'
                    });
                }

                $scope.upload = $upload.upload({
                    url: "https://api.cloudinary.com/v1_1/" + $.cloudinary.config().cloud_name + "/upload",
                    data: {
                        upload_preset: $.cloudinary.config().upload_preset,
                        tags: 'temp_cover',
                        context: 'photo=' + $scope.title
                    },
                    file: file
                }).progress(function (e) {

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
            var contentCoverPhoto = angular.element('.profile.wrapper');

            pictureCoverPhoto.on('load', function () {
                // show: 
                $scope.coverPhotoInProgress = true;
                $scope.temporaryCoverPhoto = true;

                if ($scope.coverPhoto) {
                    $scope.coverPhoto = false;
                    angular.element('.spinner-container').css({
                        'z-index': '0'
                    });
                }

                pictureCoverPhoto.guillotine({eventOnChange: 'guillotinechange', width: contentCoverPhoto[0].offsetWidth - 2, height: 315});
                var data = pictureCoverPhoto.guillotine('getData');

                for (var key in data) {
                    $('#' + key).html(data[key]);
                }

                pictureCoverPhoto.on('guillotinechange', function (ev, data, action) {
                    data.scale = parseFloat(data.scale.toFixed(4));
                    for (var k in data) {
                        $('#' + k).html(data[k]);
                    }
                });

                // show:
                $scope.coverPhotoButtons = true;
                $scope.coverLoaded = true;

                // hide:
                $scope.coverImageSelectorVisible = false;
                $scope.spinnerVisible = false;
                $scope.defaultCoverImageVisible = false;
                $scope.$apply();
            });

            $scope.saveCoverPhoto = function () {

                var data = pictureCoverPhoto.guillotine('getData');
                var cloudianary_result = $.cloudinary.image(cloudinary_data.public_id, {
                    secure: true,
                    width: data.w,
                    height: data.h,
                    x: data.x,
                    y: data.y,
                    crop: 'crop'
                });

                // get Secure URI.
                $scope.coverPhotoURI = cloudianary_result[0].src;

                // hide:
                $scope.coverPhotoInProgress = false;
            };

            angular.element('.coverPhoto').on('load', function () {
                // we need to reset the guillotine plugin in order to call again later
                pictureCoverPhoto.guillotine('remove');

                // show: 
                $scope.coverPhoto = true;
                $scope.coverImageSelectorVisible = true;
                $scope.defaultCoverImageVisible = true;

                // hide:
                $scope.spinnerVisible = false;
                $scope.temporaryCoverPhoto = false;

                // it's necessary to call $apply in order to bind variables with the DOM
                $scope.$apply();
            });

            $scope.cancelCoverPhoto = function () {
                // we need to reset the guillotine plugin in order to call again later
                pictureCoverPhoto.guillotine('remove');

                // show:
                $scope.coverImageSelectorVisible = true;

                // hide: 
                $scope.temporaryCoverPhoto = false;
                $scope.spinnerVisible = false;
                $scope.coverPhotoInProgress = false;

                if (!$scope.coverPhoto) {
                    $scope.defaultCoverImageVisible = true;
                    $scope.coverPhoto = true;
                }
            }

            //<<<<<<<<<<<<<<< END COVER PHOTO >>>>>>>>>>>>>>>

            //<<<<<<<<<<<<<<< START PROFILE PHOTO >>>>>>>>>>>>>>>

            // show:
            $scope.temporaryProfilePhoto = true;
            $scope.profileImgSelectVisible = true;
            $scope.defaultProfileImageVisible = true;

            // hide: 
            $scope.profilePhotoButtons = false;
            $scope.profilePhoto = false;
            $scope.profilePhotoLoaded = false;
            $scope.spinnerVisibleProfile = false;

            $scope.onFileSelectProfile = function ($files) {
                var file = $files[0]; // we're not interested in multiple file uploads here

                // show:
                $scope.temporaryProfilePhoto = true;
                $scope.spinnerVisibleProfile = true;

                // hide: 
                $scope.profileImgSelectVisible = false;

                if ($scope.profilePhotoURI) {
                    $scope.profilePhoto = true;
                    $scope.defaultProfileImageVisible = false;
                    $scope.temporaryProfilePhoto = false;
                }

                if ($scope.profilePhoto) {
                    toggleProfileImageSelect('front');
                }

                $scope.upload = $upload.upload({
                    url: "https://api.cloudinary.com/v1_1/" + $.cloudinary.config().cloud_name + "/upload",
                    data: {
                        upload_preset: $.cloudinary.config().upload_preset,
                        tags: 'temp_profile',
                        context: 'photo=' + $scope.title
                    },
                    file: file
                }).progress(function (e) {
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

            pictureProfilePhoto.on('load', function () {
                // show:
                $scope.profilePhotoInProgress = true;

                // if profile photo is already changed
                if ($scope.profilePhoto) {
                    $scope.profilePhoto = false;
                    $scope.temporaryProfilePhoto = true;
                    toggleProfileImageSelect('back');
                }

                /* START guillotine configuration */
                pictureProfilePhoto.guillotine({eventOnChange: 'guillotinechange', width: 260, height: 260});

                var data = pictureProfilePhoto.guillotine('getData');

                for (var key in data) {
                    $('#' + key).html(data[key]);
                }

                pictureProfilePhoto.on('guillotinechange', function (ev, data, action) {
                    data.scale = parseFloat(data.scale.toFixed(4));
                    for (var k in data) {
                        $('#' + k).html(data[k]);
                    }
                });
                /* END guillotine configuration */

                angular.element('.edit-buttons-profile-photo').css({
                    'top': '205px',
                    'left': '57px'
                });

                // show:
                $scope.profilePhotoLoaded = true;
                $scope.profilePhotoButtons = true;
                $scope.$apply();
            });

            $scope.saveProfilePhoto = function () {

                var data = pictureProfilePhoto.guillotine('getData');

                // Crop the photo
                var cloudianary_result = $.cloudinary.image(cloudinary_data.public_id, {
                    secure: true,
                    width: data.w,
                    height: data.h,
                    x: data.x,
                    y: data.y,
                    crop: 'crop'
                });

                // get Secure URI.
                $scope.profilePhotoURI = cloudianary_result[0].src;

                // hide:
                $scope.profilePhotoInProgress = false;
            };

            angular.element('.profilePhoto').on('load', function () {
                // we need to reset the guillotine plugin in order to call again later
                pictureProfilePhoto.guillotine('remove');

                // show:
                $scope.profilePhoto = true;
                $scope.profileImgSelectVisible = true;

                // hide:
                $scope.spinnerVisibleProfile = false;
                $scope.temporaryProfilePhoto = false;
                $scope.profilePhotoButtons = false;

                // apply changes
                $scope.$apply();
            });

            $scope.cancelProfilePhoto = function () {
                // we need to reset the guillotine plugin in order to call again later
                pictureProfilePhoto.guillotine('remove');

                // show:
                $scope.profileImgSelectVisible = true;

                // hide:
                $scope.spinnerVisible = false;
                $scope.temporaryProfilePhoto = false;
                $scope.spinnerVisibleProfile = false;
                $scope.profilePhotoButtons = false;
                $scope.profilePhotoInProgress = false;

                if (!$scope.profilePhoto) {
                    $scope.profilePhoto = true;
                } else {
                    toggleProfileImageSelect('front');
                }

            };

            function toggleProfileImageSelect(position) {
                if (position == 'front') {
                    angular.element('.spinner-container-profile').css({
                        'z-index': '10'
                    });
                } else if (position == 'back') {
                    angular.element('.spinner-container-profile').css({
                        'z-index': '0'
                    });
                } else {
                    throw 'Use a valid param in this function';
                }
            }

            //<<<<<<<<<<<<<<< END PROFILE PHOTO >>>>>>>>>>>>>>>


            //<<<<<<<<<<<<<<< utilities functions >>>>>>>>>>>>>>>

            // function called when the user leave the page
            window.onbeforeunload = function () {
                if ($scope.coverPhotoInProgress || $scope.profilePhotoInProgress) {
                    return 'You have unsaved changes.\nTo save press the save button over your cover photo.';
                }
            }

            function checkProfileActionActive() {
                var isAvailable = false;
                if ($scope.coverPhotoInProgress || $scope.profilePhotoInProgress) {
                    if (confirm('You have unsaved changes.\nTo save press the save button over your cover photo.'))
                        return true;
                }
                return isAvailable;
            }

            // Drag and drop for photos -- NOT IMPLEMENTED!!
            // Modify the look and fill of the dropzone when files are being dragged over it
            $scope.dragOverClass = function ($event) {
                var items = $event.dataTransfer.items;
                var hasFile = false;
                if (items != null) {
                    for (var i = 0; i < items.length; i++) {
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
            var init = function () {

                $scope.addEducationEnable = false;

                getData();

                /* SUMMARY */
                initSummary();

                /* SKILLS */
                initSkills();

                /* EARLY LIFE */
                initEarlyLife();

                /* PERSONAL LIFE */
                initPersonalLife();

                /* EDUCATION */
                initEducation();

                sessionService.requestCurrentUser().then(
                    function (user) {
                        $scope.user = user.candidate;
                        initCandidateProfile();

                    },
                    function (error) {
                        console.log(error);
                        $state.go('home.page');
                    }
                );
            };

            var initCandidateProfile = function () {
                $scope.educations = $scope.user.educations;
                $scope.selectedSkills = $scope.user.skills.map(function (skill) {
                    return skill.name;
                });
            };


            var getData = function () {
                Skill.get(function (skills) {
                    $scope.skillsTags = skills.skills;
                });
            };

            var saveSummary = function () {
                $scope.disableSummaryEditor();
                if ($scope.userSummary != undefined && $scope.userSummary != "" && $scope.userSummary.length > 0) {
                    $scope.profileSummary = $scope.userSummary;
                } else {
                    $scope.profileSummary = "Write something about you";
                }
            };

            var saveSkills = function () {
                $scope.disableSkillsEditor();
                $scope.selectedSkills = $scope.candidateSelectedSkills.slice();
                var candidateSkills = new CandidateSkills();
                candidateSkills.candidate_id = $scope.user.uid;
                candidateSkills.skills = $scope.selectedSkills.map(function (skillName) {
                    return {name: skillName}
                });
                $httpProvider.defaults.headers.common['Authorization'] = sessionService.authenticationToken();
                candidateSkills.$update(
                    function (response) {
                        refreshSkills();
                    },
                    function (error) {
                        console.log(error)
                    });
            };

            var saveEarlyLife = function () {
                $scope.disableEarlyLifeEditor();
                if ($scope.userEarlyLife != undefined && $scope.userEarlyLife != "" && $scope.userEarlyLife.length > 0) {
                    $scope.profileEarlyLife = $scope.userEarlyLife;
                } else {
                    $scope.profileEarlyLife = "Write something about your early life";
                }
            };

            var savePersonalLife = function () {
                $scope.disablePersonalLifeEditor();
                if ($scope.userPersonalLife != undefined && $scope.userPersonalLife != "" && $scope.userPersonalLife.length > 0) {
                    $scope.profilePersonalLife = $scope.userPersonalLife;
                } else {
                    $scope.profilePersonalLife = "Write something about your personal life";
                }
            };

            var getEducation = function (educationObj) {
                var education = new Education();
                education.candidate_id = $scope.user.uid;
                education.school_id = educationObj.school.id;
                education.degree_id = educationObj.degree.id;
                education.major_id = educationObj.major.id;
                education.state_id = (educationObj.state != undefined) ? educationObj.state.id : null;
                education.country_id = (educationObj.country.id != undefined) ? educationObj.country.id : null;
                education.description = (educationObj.description != undefined) ? educationObj.description : null;
                education.start_date = educationObj.start_date + '-01-01';
                education.end_date = (educationObj.end_date != undefined) ? educationObj.end_date + '-01-01' : null;
                return education;
            };

            var getEducations = function () {
                Education.query({candidate_id: $scope.user.uid}, function (educations) {
                    $scope.educations = educations.educations;
                });
            };

            var saveEducation = function () {
                $scope.addEducationEnable = false;

                var education = getEducation($scope.education); //Create Education Resource

                $httpProvider.defaults.headers.common['Authorization'] = sessionService.authenticationToken();
                education.$save(
                    function (response) {
                        getEducations();
                        clearAddEducationValues();
                    },
                    function (error) {
                        console.log(error);
                    });
            };

            var updateEducation = function ($index) {
                $scope.disableEducationEditor();
                var education = getEducation($scope.educations[$index]);
                education.id = $scope.educations[$index].id;
                $httpProvider.defaults.headers.common['Authorization'] = sessionService.authenticationToken();
                education.$update(
                    function (response) {
                        clearAddEducationValues();
                        getEducations(); //Todo change the way this is done. Modify array.
                    },
                    function (error) {
                        console.log(error);
                    });
            };

            $scope.disableEducationEditor = function () {
                $scope.editorEducationEnabled = false;
            };

            var clearAddEducationValues = function () {
                $scope.education.school = "";
                $scope.education.degree = "";
                $scope.education.major = "";
                $scope.education.state = "";
                $scope.education.country = "";
                $scope.education.description = "";
                $scope.education.start_date = "Start Year";
                $scope.education.end_date = "End Year";
            }

            var initSummary = function () {
                $scope.userSummary;
                $scope.profileSummary = "Write something about you";
                $scope.editorSummaryEnabled = false;

                $scope.enableSummaryEditor = function () {
                    $scope.editorSummaryEnabled = true;
                    if ($scope.profileSummary != "Write something about you")
                        $scope.userSummary = $scope.profileSummary;
                };

                $scope.disableSummaryEditor = function () {
                    $scope.editorSummaryEnabled = false;
                };

                $scope.saveSummary = saveSummary;
            };

            var initSkills = function () {
                $scope.candidateSelectedSkills = [];
                $scope.selectedSkills = [];
                $scope.editorSkillsEnabled = false;

                $scope.enableSkillsEditor = function () {
                    $scope.editorSkillsEnabled = true;
                    if ($scope.selectedSkills.length > 0)
                        $scope.candidateSelectedSkills = $scope.selectedSkills.slice();
                };

                $scope.disableSkillsEditor = function () {
                    $scope.editorSkillsEnabled = false;
                };

                $scope.saveSkills = saveSkills;
            };

            var initEarlyLife = function () {
                $scope.userEarlyLife;
                $scope.profileEarlyLife = "Write something about your early life";

                $scope.editorEarlyLifeEnabled = false;

                $scope.enableEarlyLifeEditor = function () {
                    $scope.editorEarlyLifeEnabled = true;
                    if ($scope.profileEarlyLife != "Write something about your early life")
                        $scope.userEarlyLife = $scope.profileEarlyLife;
                };

                $scope.disableEarlyLifeEditor = function () {
                    $scope.editorEarlyLifeEnabled = false;
                };

                $scope.saveEarlyLife = saveEarlyLife;
            };

            var initPersonalLife = function () {
                $scope.userPersonalLife;
                $scope.profilePersonalLife = "Write something about your personal life";
                $scope.editorPersonalLifeEnabled = false;

                $scope.enablePersonalLifeEditor = function () {
                    $scope.editorPersonalLifeEnabled = true;
                    if ($scope.profilePersonalLife != "Write something about your personal life")
                        $scope.userPersonalLife = $scope.profilePersonalLife;
                };

                $scope.disablePersonalLifeEditor = function () {
                    $scope.editorPersonalLifeEnabled = false;
                };

                $scope.savePersonalLife = savePersonalLife;
            };

            var initEducation = function () {
                $scope.educations = [];
                $scope.education = {};
                $scope.saveEducation = saveEducation;
                $scope.updateEducation = updateEducation;
            };

            var refreshSkills = function () {
                CandidateSkills.query({candidate_id: $scope.user.uid}, function (skills) {
                    $scope.candidateSelectedSkills = skills.skills;
                })
            };

            init();


        }]);



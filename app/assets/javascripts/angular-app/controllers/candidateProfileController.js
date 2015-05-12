angular.module('mepedia.controllers').controller('candidateProfileController',
    ['$scope', '$rootScope', '$http', '$upload', '$location', '$anchorScroll','sessionService', '$state', 'Country', 'State', 'Candidate', 'Employer', 'Skill', 'Interest', 'School', 'Major', 'Degree', 'Education', 'CandidateSkills', 'CandidateInterests', 'CandidateLanguages', 'Utils', 'Experience', 'alertService', 'modalService', 'crypt',

        function ($scope, $rootScope, $http, $upload, $location, $anchorScroll, sessionService, $state, Country, State, Candidate, Employer, Skill, Interest, School, Major, Degree, Education, CandidateSkills, CandidateInterests, CandidateLanguages, Utils, Experience, alertService, modalService, crypt) {

            $scope.defaultSummary = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras dignissim orci in eros auctor, at fringilla orci hendrerit. Quisque consequat eros enim. Nullam luctus lectus sed justo ullamcorper, tempor commodo leo sagittis. Quisque egestas tempus nulla. Aenean sit amet mauris leo.";
            $scope.defaultSkills = "Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Sed cursus quam erat, non fringilla dui efficitur vitae. Pellentesque nec sodales lacus. Fusce rutrum diam a dolor vestibulum, at sodales turpis congue. Curabitur condimentum velit elit, id ornare velit eleifend id. In vel lorem ut mi suscipit placerat ut eu nunc. ";
            $scope.defaultExperience = "Cras diam sapien, pharetra laoreet sapien nec, pellentesque interdum mauris. Suspendisse blandit leo in luctus dapibus. Praesent accumsan eu leo quis eleifend. Vivamus vitae auctor neque. Donec facilisis bibendum dui ac lobortis.";
            $scope.defaultInterests = "Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Sed cursus quam erat, non fringilla dui efficitur vitae. Pellentesque nec sodales lacus. Fusce rutrum diam a dolor vestibulum, at sodales turpis congue. Curabitur condimentum velit elit, id ornare velit eleifend id. In vel lorem ut mi suscipit placerat ut eu nunc. ";
            $scope.defaultLanguages = "Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Sed cursus quam erat, non fringilla dui efficitur vitae. Pellentesque nec sodales lacus. Fusce rutrum diam a dolor vestibulum, at sodales turpis congue. Curabitur condimentum velit elit, id ornare velit eleifend id. In vel lorem ut mi suscipit placerat ut eu nunc. ";

            var updateUser = function () {
                $httpProvider.defaults.headers.common['Authorization'] = sessionService.authenticationToken();
                Utils.candidateFromObject($scope.user).$update(function (response) { //Creates resource User from object $scope.user
                    $scope.user = response.candidate;
                    initCandidateProfile(); //Update profile variables;
                }, function (error) {
                    console.log(error);
                });
            };

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

                //Get image before upload
                var temp_img = angular.element('#temp_cover_photo');

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
                    /*$rootScope.photos = $rootScope.photos || [];
                    data.context = {custom: {photo: $scope.title}};

                    $scope.resultCoverPhoto = data;
                    $rootScope.photos.push(data);
                    if (!$scope.$$phase) {
                        $scope.$apply();
                    } else {*/
                        $scope.coverPhotoData = data;
                       $scope.coverLoaded = true;
                    $scope.defaultCoverImageVisible = false;
                    $scope.coverPhoto = false;
                   // }
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

                pictureCoverPhoto.guillotine({eventOnChange: 'guillotinechange'});
                pictureCoverPhoto.guillotine('fit');
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


                // hide:
                $scope.coverImageSelectorVisible = false;
                $scope.spinnerVisible = false;

                $scope.$apply();
            });

            $scope.saveCoverPhoto = function () {

                var data = pictureCoverPhoto.guillotine('getData');
                var cloudianary_result = $.cloudinary.image(cloudinary_data.public_id, {
                    secure: true,
                    width: pictureCoverPhoto.w,
                    height: pictureCoverPhoto.h,
                    x: pictureCoverPhoto.x,
                    y: pictureCoverPhoto.y,
                    crop: 'crop'
                });

                var timestamp = (new Date).getTime()/1000; //seconds
                var delete_url = "https://api.cloudinary.com/v1_1/" + $.cloudinary.config().cloud_name + "/image/destroy";

                var sha1 = crypt.hash('public_id=xzhealra8y5kwjx0mqig&timestamp=143129843905hwa4MfqVrK_tKFwz1Nx1Umg38');

                var funciono = '9b803b4082e093510d85f47ffbd53ac4d5b8a361';

                var data =  {
                    public_id: 'xzhealra8y5kwjx0mqig',
                    api_key: '723254833421314',
                    timestamp: '1431298439',
                    signature: '9b803b4082e093510d85f47ffbd53ac4d5b8a361'
                };
                //Delete previous image
                // Simple POST request example (passing data) :
                //$http.post(delete_url, data).
                //    success(function(data, status, headers, config) {
                //        // this callback will be called asynchronously
                //        // when the response is available
                //        var success_data = data;
                //    }).
                //    error(function(data, status, headers, config) {
                //        // called asynchronously if an error occurs
                //        // or server returns response with an error status.
                //        var error_data = data;
                //});

                // get Secure URI.
                $scope.coverPhotoURI = cloudianary_result[0].src;
                $scope.user.cover_image = $scope.coverPhotoURI; //update user reference
                updateUser();
                // hide:
                $scope.coverPhotoInProgress = false;
            };

            angular.element('.cover-photo-img').on('load', function () {
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
                    'top': '180px',
                    'left': '48px'
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
                $scope.user.profile_image = $scope.profilePhotoURI; //update user reference
                updateUser();

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
                getData();

                /* SUMMARY */
                initSummary();

                /* SKILLS */
                initSkills();

                /* INTERESTS */
                initInterests();

                /* EDUCATION */
                initEducation();

                /* EXPERIENCE */
                initExperience();

                /* LANGUAGE */
                initLanguages();

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

            /* INIT FUNCTIONS */

            var initCandidateProfile = function () {
                $scope.selectedSkills = $scope.user.skills.map(function (skill) {
                    return skill.name;
                });

                $scope.selectedInterests = $scope.user.interests.map(function(interest) {
                   return interest.name;
                });

                $scope.coverPhotoURI = $scope.user.cover_image;
                $scope.profilePhotoURI = $scope.user.profile_image;

                /* Calculate user age for highlights section */
                calculateAge();

                /* Init default sections texts */
                if ($scope.user.summary == undefined || $scope.user.summary == "")
                    $scope.defaultSummaryEnable = true;

                if ($scope.user.experiences.length == 0)
                    $scope.defaultExperienceEnable = true;

            };

            var initSummary = function () {
                $scope.summaryEditorEnable = false;

                $scope.onSummaryEditor = function () {
                    if ($scope.defaultSummaryEnable == true)
                        $scope.defaultSummaryEnable = false;
                    $scope.summaryEditorEnable = true;
                    $scope.summaryTemp = $scope.user.summary;
                };

                $scope.onCancelSummaryEditor = function () {
                    $scope.summaryEditorEnable = false;
                    if ($scope.user.summary == undefined || $scope.user.summary == "")
                        $scope.defaultSummaryEnable = true;

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

            var initInterests = function() {
                $scope.candidateSelectedInterests = [];
                $scope.selectedInterests = [];
                $scope.editorSkillsEnabled = false;

                $scope.enableInterestsEditor = function() {
                    $scope.editorInterestsEnabled = true;
                    if ($scope.selectedInterests.length > 0)
                        $scope.candidateSelectedInterests = $scope.selectedInterests.slice();
                };

                $scope.disableInterestsEditor = function() {
                    $scope.editorInterestsEnabled = false
                };

                $scope.saveInterests = saveInterests;
            };

            var initEducation = function () {
                $scope.educations = [];
                $scope.education = {};
                $scope.addEducationEnable = false;
                $scope.educationEditor = false;
                $scope.saveEducation = saveEducation;
                $scope.updateEducation = updateEducation;
            };

            var initExperience = function () {
                $scope.experiences = [];
                $scope.experience = {};
                $scope.addExperienceEnable = false;
                $scope.experienceEditor = false;

                $scope.saveExperience = saveExperience;
                $scope.updateExperience = updateExperience;

                $scope.enableDefaultExperience = function () {
                    if ($scope.defaultExperienceEnable == true)
                        $scope.defaultExperienceEnable = false;
                };

                $scope.disableDefaultExperience = function () {
                    if ($scope.user.experiences.length == 0)
                        $scope.defaultExperienceEnable = true;
                };

                $scope.deleteExperience = deleteExperience;
            };

            var initLanguages = function () {
                $scope.languages = [];
                $scope.language = null;
                $scope.addLanguageEnable = false;
                $scope.isAddingLanguage = false;
                $scope.languageEditor = false;

                $scope.onLanguageAdd = function () {
                    $scope.isAddingLanguage = true;
                };
                $scope.onLanguageCancel = function () {
                    $scope.isAddingLanguage = false;
                };

                $scope.saveLanguage = saveLanguage;
            };

            /* GETTERS */

            var getData = function () {
                Country.query(function (countries) {
                    $scope.countries = countries.countries;
                });

                Skill.query(function (skills) {
                    $scope.skillsTags = skills.skills;
                });

                School.query(function (schools) {
                    $scope.schools = schools.schools;
                });

                Major.query(function (majors) {
                    $scope.majors = majors.majors;
                });

                Degree.query(function (degrees) {
                    $scope.degrees = degrees.degrees;
                });

                Interest.query(function (interests) {
                    $scope.interestsTags = interests.interests;
                })
            };

            var getEducation = function (educationObj) {
                var education = new Education();
                education.candidate_id = $scope.user.uid;
                education.school_id = educationObj.school_id;
                education.degree_id = educationObj.degree_id;
                education.major_id = educationObj.major_id;
                education.state_id = (educationObj.state_id != undefined) ? educationObj.state_id : null;
                education.country_id = (educationObj.country_id != undefined) ? educationObj.country_id : null;
                education.description = (educationObj.description != undefined) ? educationObj.description : null;
                education.start_date = educationObj.start_date;
                education.end_date = (educationObj.end_date != undefined) ? educationObj.end_date : null;
                return education;
            };

            var getExperience = function (experienceObj) {
                var experience = new Experience();
                experience.candidate_id = $scope.user.uid;
                experience.company_name = experienceObj.company_name;
                experience.job_title = experienceObj.job_title;
                experience.description = (experienceObj.description != undefined) ? experienceObj.description : null;
                experience.start_date = experienceObj.start_date;
                experience.end_date = (experienceObj.end_date != undefined) ? experienceObj.end_date : null;
                return experience;
            };

            /* SAVE FUNCTIONS */

            var saveSummary = function () {
                $scope.summaryEditorEnable = false;
                $scope.user.summary = $scope.summaryTemp;
                $httpProvider.defaults.headers.common['Authorization'] = sessionService.authenticationToken();
                Utils.candidateFromObject($scope.user).$update(function (response) { //Creates resource User from object $scope.user
                    $scope.user = response.candidate;  // ToDO !! update only user.summary
                    initCandidateProfile(); //Update profile variables;
                    $scope.defaultSummaryEnable = false;
                }, function (error) {
                    console.log(error);
                });
            };

            var saveSkills = function () {
                $scope.disableSkillsEditor();
                var candidateSkills = new CandidateSkills();
                candidateSkills.candidate_id = $scope.user.uid;
                candidateSkills.skills = $scope.candidateSelectedSkills.slice().map(function (skillName) {
                    return {name: skillName}
                });

                $httpProvider.defaults.headers.common['Authorization'] = sessionService.authenticationToken();
                candidateSkills.$update().then(
                    function (response) {
                        $scope.selectedSkills = response.skills.map(function (skill) {
                            return skill.name;
                        });
                    }
                ).catch(
                    function (error) {
                        console.log(error)
                    }
                );
            };

            var saveInterests = function() {
                $scope.disableInterestsEditor();
                var candidateInterests = new CandidateInterests();
                candidateInterests.candidate_id = $scope.user.uid;
                candidateInterests.interests = $scope.candidateSelectedInterests.slice().map(function (interestName) {
                    return {name: interestName}
                });

                $httpProvider.defaults.headers.common['Authorization'] = sessionService.authenticationToken();
                candidateInterests.$update().then(
                    function(response) {
                        $scope.selectedInterests = response.interests.map(function (interest) {
                            return interest.name;
                        })
                    }
                ).catch(
                    function (error) {
                        console.log(error);
                    }
                )
            };

            var getEducations = function () {
                Education.query({candidate_id: $scope.user.uid}, function (educations) {
                    $scope.user.educations = educations.educations;
                });
            };

            var saveEducation = function (valid) {
                if (!valid) return;
                $scope.addEducationEnable = false;
                var education = getEducation($scope.education); // Create Education Resource
                $httpProvider.defaults.headers.common['Authorization'] = sessionService.authenticationToken();
                education.$save(
                    function (response) {
                        getEducations();
                    },
                    function (error) {
                        console.log(error);
                    });
            };

            var getExperiences = function () {
                Experience.query({candidate_id: $scope.user.uid}, function (experiences) {
                    $scope.user.experiences = experiences.experiences;
                })
            };

            var saveExperience = function (valid) {
                if (!valid) return;
                $scope.addExperienceEnable = false;
                var experience = getExperience($scope.experience); //Create Experience Resource
                $httpProvider.defaults.headers.common['Authorization'] = sessionService.authenticationToken();
                experience.$save(
                    function (response) {
                        getExperiences();

                    },
                    function (error) {
                        console.log(error);
                    });
            };

            var getLanguage = function (language) {
              return new CandidateLanguages({language_id: language.language_id, level: 2, candidate_id: $scope.user.uid})
            };

            var getLanguages = function () {
                CandidateLanguages.query({candidate_id: $scope.user.uid}, function(languages) {
                    $scope.user.languages = languages.languages;
                })
            };

            var saveLanguage = function (valid) {
                if (!valid) return;
                $scope.addLanguageEnable = false;
                var language = getLanguage($scope.language); //Create Language Resource
                $httpProvider.defaults.headers.common['Authorization'] = sessionService.authenticationToken();
                language.$save().then(
                    function(language) {
                        getLanguages();
                    }
                ).catch(
                    function (error) {
                        console.log(error);
                    }
                )
            };

            /* UPDATE FUNCTIONS */

            var updateEducation = function (valid, $index) {
                if (!valid) return;
                $scope.educationEditor = false;
                var education = getEducation($scope.user.educations[$index]);
                education.id = $scope.user.educations[$index].id;
                $httpProvider.defaults.headers.common['Authorization'] = sessionService.authenticationToken();
                education.$update(
                    function (response) {
                        getEducations();
                    },
                    function (error) {
                        console.log(error);
                    });
            };

            var updateExperience = function (valid, index) {
                if (!valid) return;
                $scope.experienceEditor = false;
                var experience = getExperience($scope.user.experiences[index]);
                experience.id = $scope.user.experiences[index].id;
                $httpProvider.defaults.headers.common['Authorization'] = sessionService.authenticationToken();
                experience.$update(
                    function (response) {
                        getExperiences();
                        $scope.defaultExperienceEnable = false;
                    },
                    function (error) {
                        console.log(error);
                    });
            };

            /* DELETES */

            var deleteExperience = function(index) {
                var deleteIt = function() {
                    var experience = new Experience({
                        candidate_id: $scope.user.uid,
                        id: $scope.user.experiences[index].id
                    });
                    $httpProvider.defaults.headers.common['Authorization'] = sessionService.authenticationToken();
                    experience.$delete().then(
                        function () {
                            $scope.user.experiences.splice(index);
                            alertService.addInfo('Experience successfully deleted!', 5000);
                        }
                    ).catch(
                        function (error) {
                            console.log(error);
                        }
                    )
                };
                modalService.confirm("Are you sure you want to delete this experience?").then(deleteIt)
            };

            /* OTHER FUNCTIONS */

            var calculateAge = function () { // birthday is a date
                var partsOfBirthday = $scope.user.birth.split('-');
                var year = partsOfBirthday[0];
                var month = partsOfBirthday[1];
                var day = partsOfBirthday[2];

                var d = new Date();
                d.setFullYear(year, month-1, day);
                var ageDifMs = Date.now() - d.getTime();
                var ageDate = new Date(ageDifMs); //miliseconds from epoch
                $scope.age = Math.abs(ageDate.getUTCFullYear() - 1970);
            };

            $scope.scrollTo = function (id) {
                var old = $location.hash();
                $location.hash(id);
                $anchorScroll();
                $location.hash(old);
            };

            getData();

            init();

        }]);



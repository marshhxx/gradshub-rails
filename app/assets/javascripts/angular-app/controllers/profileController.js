angular.module('mepedia.controllers').controller('profileController',
    ['$scope', '$rootScope', '$http', '$upload', 'sessionService', '$state','Country', 'State', 'Candidate', 'Employer', 'Skill', 'School', 'Major', 'Degree', 'Education', 'CandidateSkills',

        function($scope, $rootScope,$httpProvider, $upload, sessionService, $state, Country, State, Candidate, Employer, Skill, School, Major, Degree, Education, CandidateSkills) {

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
            var init = function () {
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

                $scope.years = getYears();

                function getYears(){
                    var first = 1950;
                    var now = new Date();
                    var second = now.getFullYear();
                    var array = Array();

                    for(var i = first; i <= second; i++){
                        array.push(i);
                    }
                    return array.reverse();
                }

                $scope.onState = function(state) {
                    if (state != undefined)
                        $scope.state = state;
                };

                $scope.onCountry = function(country) {
                    $scope.country = country
                    if ($scope.country != undefined)
                        $scope.getStateByCountryId($scope.country.id);
                }

                $scope.onMajor = function(major) {
                    if (major != undefined)
                        $scope.major = major
                };

                $scope.onDegree= function(degree) {
                    if (degree != undefined)
                        $scope.degree = degree
                };

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

            var initCandidateProfile = function(){
                $scope.educations = $scope.user.educations;
                $scope.selectedSkills = $scope.user.skills;

            }

            var getData = function() {
                Country.query(function(countries) {
                    $scope.countries = countries.countries;
                });

                $scope.getStateByCountryId = function(countryId) {
                    State.query({country_id: countryId}, function(states) {
                        $scope.states = states.states;
                        console.log($scope.states);
                    });
                };

                Skill.get(function(skills) {
                    $scope.skillsTags = skills.skills;
                });

                School.get(function(schools) {
                    $scope.schools = schools.schools;
                });

                Major.get(function(majors){
                    $scope.majors = majors.majors;
                });

                Degree.get(function(degrees){
                    $scope.degrees = degrees.degrees;
                });
            };

            var saveSummary = function(){
                $scope.disableSummaryEditor();
                if($scope.userSummary != undefined  && $scope.userSummary != "" && $scope.userSummary.length > 0){
                    $scope.profileSummary = $scope.userSummary;
                } else {
                    $scope.profileSummary = "Write something about you";
                }
            };

            var saveSkills = function(){
                $scope.disableSkillsEditor();
                $scope.selectedSkills = $scope.candidateSelectedSkills.slice();
                  /*  var candidateSkills = new CandidateSkills();
                    candidateSkills.skills = $scope.selectedSkills;
                    $httpProvider.defaults.headers.common['Authorization'] = sessionService.authenticationToken();
                    candidateSkills.$save(
                        function (response) {
                           $scope.selectedSkills = response.skills;
                        },
                        function (error) {
                            console.log(error);
                        });
                   */
            };

            var saveEarlyLife = function(){
                $scope.disableEarlyLifeEditor();
                if($scope.userEarlyLife != undefined  && $scope.userEarlyLife != "" && $scope.userEarlyLife.length > 0){
                    $scope.profileEarlyLife = $scope.userEarlyLife;
                } else {
                    $scope.profileEarlyLife = "Write something about your early life";
                }
            };

            var savePersonalLife = function(){
                $scope.disablePersonalLifeEditor();
                if($scope.userPersonalLife != undefined  && $scope.userPersonalLife != "" && $scope.userPersonalLife.length > 0){
                    $scope.profilePersonalLife = $scope.userPersonalLife;
                } else {
                    $scope.profilePersonalLife = "Write something about your personal life";
                }
            };

            var saveEducation = function(){
                $scope.disableEducationEditor();
                var education = new Education();
                education.candidate_id = $scope.user.uid;
                education.school_id = $scope.school.id;
                education.degree_id = $scope.degree.id;
                education.major_id = $scope.major.id;
                education.state_id = ($scope.state != undefined) ? $scope.state.id : null;
                education.country_id = ($scope.country.id != undefined) ? $scope.country.id : null;
                education.description = ($scope.educationDescription != undefined) ? $scope.educationDescription : null;
                education.start_date = $scope.startDate + '-01-01';
                education.end_date = ($scope.endDate != undefined) ? $scope.endDate + '-01-01' : null;
                $httpProvider.defaults.headers.common['Authorization'] = sessionService.authenticationToken();
                education.$save(
                    function (response) {
                        $scope.educations.push(response.education);
                        clearAddEducationValues();
                    },
                    function (error) {
                        console.log(error);
                });
            };

            var clearAddEducationValues = function(){
                $scope.school.id = "";
                $scope.degree.id = "";
                $scope.major.id = "";
                $scope.state.id = "";
                $scope.country.id = "";
                $scope.description = "";
                $scope.startDate = "";
                $scope.endDate = "";
            }

            var initSummary = function() {
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

                $scope.saveSummary = saveSummary;
            };

            var initSkills = function() {
                $scope.candidateSelectedSkills = [];
                $scope.selectedSkills = [];

                $scope.editorSkillsEnabled = false;

                $scope.enableSkillsEditor = function() {
                    $scope.editorSkillsEnabled = true;
                    if($scope.selectedSkills.length > 0)
                        $scope.candidateSelectedSkills = $scope.selectedSkills.slice();
                };

                $scope.disableSkillsEditor = function() {
                    $scope.editorSkillsEnabled = false;
                };

                $scope.saveSkills = saveSkills;
            };

            var initEarlyLife = function() {
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

                $scope.saveEarlyLife = saveEarlyLife;
            };

            var initPersonalLife = function() {
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

                $scope.savePersonalLife = savePersonalLife;
            };

            var initEducation = function() {
                $scope.onSchool = function (school) {
                    if (school != undefined)
                        $scope.school = school
                };

                $scope.startDate = "Start Year";
                $scope.endDate = "End Year";
                $scope.educations = [];

                $scope.setStartYear = function(year) {
                    $scope.startDate = year;
                };

                $scope.setEndYear = function(year) {
                    $scope.endDate = year;
                };

                $scope.enableEducationEditor = function() {
                    $scope.editorEducationEnabled = true;
                };

                $scope.disableEducationEditor = function() {
                    $scope.editorEducationEnabled = false;
                };

                $scope.educations = [];

                $scope.saveEducation = saveEducation;

            };

            init();


        }]);



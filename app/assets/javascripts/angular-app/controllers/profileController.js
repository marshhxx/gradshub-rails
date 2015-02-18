angular.module('mepedia.controllers').controller('profileController',
    ['$scope', '$rootScope', '$upload', 'sessionService', '$state','Country', 'State', 'User', 'Skill',

        function($scope, $rootScope, $upload, sessionService, $state, Country, State, User, Skill) {

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



angular.module('mepedia.controllers').controller('profileController',
    ['$scope', '$rootScope', '$upload', 'sessionService', '$state','Country', 'State', 'Candidate', 'Employer', 'Skill', 'School', 'Major', 'Degree',

        function($scope, $rootScope, $upload, sessionService, $state, Country, State, Candidate, Employer, Skill, School, Major, Degree) {

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
                    data: {
                        upload_preset: $.cloudinary.config().upload_preset, 
                        tags: 'temp_cover', 
                        context:'photo=' + $scope.title
                    },
                    file: file
                }).progress(function (e) {
                    $scope.progress = Math.round((e.loaded * 100.0) / e.total);
                    $scope.status = "Uploading... " + $scope.progress + "%";
                    if (!$scope.$$phase) {
                        $scope.$apply();
                    }
                }).success(function (data, status, headers, config) {
                    $rootScope.photos = $rootScope.photos || [];
                    data.context = {custom: {photo: $scope.title}};
                    $scope.result = data;
                    $rootScope.photos.push(data);
                    if (!$scope.$$phase) {
                        $scope.$apply();
                    } else {
                        $scope.data = data;
                    }
                });
                
            };

            var picture = angular.element('#sample_picture');
            var content = angular.element('.content');
            picture.on('load', function() { 
                picture.guillotine({eventOnChange: 'guillotinechange', width: content[0].offsetWidth, height: 315});

                var data = picture.guillotine('getData');
                console.log(data);
                for(var key in data) { $('#'+key).html(data[key]); }

                $('#rotate_left').click(function(){ picture.guillotine('rotateLeft'); });
                $('#rotate_right').click(function(){ picture.guillotine('rotateRight'); });
                $('#fit').click(function(){ picture.guillotine('fit'); });
                $('#zoom_in').click(function(){ picture.guillotine('zoomIn'); });
                $('#zoom_out').click(function(){ picture.guillotine('zoomOut'); });

                picture.on('guillotinechange', function(ev, data, action) {
                  data.scale = parseFloat(data.scale.toFixed(4));
                  for(var k in data) { $('#'+k).html(data[k]); }
                });
            });

            // Modify the look and fill of the dropzone when files are being dragged over it //
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

                $scope.tempPersonalInfo = {};
                $scope.personalInfo = {};
                $scope.editorEnabled = false;

                $scope.enableEditor = enableEditor;

                $scope.disableEditor = function() {
                    $scope.editorEnabled = false;
                };

                $scope.save = save;

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
                    return array;
                }

                $scope.onState = function(state) {
                    if (state != undefined)
                        $scope.state = state;
                };

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
                        getPersonalInfo();

                    },
                    function (error) {
                        console.log(error);
                        $state.go('home.page');
                    }
                );
            };

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
            };

            var getData = function() {
                Country.query(function(countries) {
                    $scope.countries = countries.countries;
                });

                $scope.getStateByCountryId = function(countryId) {
                    State.query({country_id: countryId}, function(states) {
                        $scope.states = states.states;
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

            var enableEditor = function () {
                $scope.editorEnabled = true;
                $scope.personalInfo.currentPosition = $scope.tempPersonalInfo.currentPosition;
                $scope.personalInfo.education = $scope.tempPersonalInfo.education;
                $scope.personalInfo.topSkills = $scope.tempPersonalInfo.topSkills;
                $scope.personalInfo.currentLocation = $scope.tempPersonalInfo.currentLocation;
            };

            var save = function () {
                $scope.tempPersonalInfo.currentPosition = $scope.personalInfo.currentPosition;
                $scope.tempPersonalInfo.education = $scope.personalInfo.education;
                $scope.tempPersonalInfo.topSkills = $scope.personalInfo.topSkills;
                $scope.tempPersonalInfo.currentLocation = $scope.personalInfo.currentLocation;
                $scope.disableEditor();
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
                if($scope.userSelectedSkills.length > 0){
                    if($scope.userSelectedSkills[0] == "Add a skill")
                        $scope.userSelectedSkills.shift()
                    $scope.selectedSkills = $scope.userSelectedSkills.slice();
                } else {
                    $scope.selectedSkills.push("Add a skill");
                }
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
                $scope.education = {};
                if($scope.school != undefined  && $scope.school.name != "" && $scope.school.name.length > 0){
                    $scope.education.school = $scope.school.name;
                    $scope.education.degree = $scope.degree.name;
                    $scope.education.major = $scope.major.name;
                    $scope.educationPlaceHolder = "";
                }
            };

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
                $scope.userSelectedSkills = [];
                $scope.selectedSkills = ["Add a skill"];


                $scope.editorSkillsEnabled = false;

                $scope.enableSkillsEditor = function() {
                    $scope.editorSkillsEnabled = true;
                    if($scope.selectedSkills.length > 0)
                        $scope.userSelectedSkills = $scope.selectedSkills.slice();
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

                $scope.setStartYear = function(year) {
                    $scope.startDate = year;
                };

                $scope.setEndYear = function(year) {
                    $scope.endDate = year;
                };

                $scope.enableEducationEditor = function() {
                    $scope.editorEducationEnabled = true;
                    if($scope.educationPlaceHolder != "Where did you study?")
                        $scope.school = $scope.education.school;
                };

                $scope.disableEducationEditor = function() {
                    $scope.editorEducationEnabled = false;
                };

                //$scope.educationPlaceHolder = "Where did you study?";

                $scope.saveEducation = saveEducation;

                $scope.education = {
                    school: "Universidad de Montevideo",
                    degree: "Telematic Engineering",
                    major: "Computer Engineering",
                    startDate: "2009",
                    endDate: "2014",
                    country: "Uruguay",
                    state: "Montevideo",
                    description: "Description description alo hola bueno ta"
                }
            };

            init();





        }]);



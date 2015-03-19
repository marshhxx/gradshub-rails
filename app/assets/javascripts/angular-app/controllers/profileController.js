angular.module('mepedia.controllers').controller('profileController',
    ['$scope', '$rootScope', '$http', '$upload', 'sessionService', '$state','Country', 'State', 'Candidate', 'Employer', 'Skill', 'School', 'Major', 'Degree', 'Education', 'CandidateSkills',

        function($scope, $rootScope,$httpProvider, $upload, sessionService, $state, Country, State, Candidate, Employer, Skill, School, Major, Degree, Education, CandidateSkills) {

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
                Education.query({candidate_id: $scope.user.uid}, function(educations){
                    $scope.educations = educations.educations;
                })

                CandidateSkills.query({candidate_id: $scope.user.uid}, function(skills){
                    $scope.selectedSkills = skills.skills;
                })
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
                var education = new Education();
                education.candidate_id = $scope.user.uid;
                education.school_id = $scope.school.id;
                education.degree_id = $scope.degree.id;
                education.major_id = $scope.major.id;
                education.state_id = $scope.state.id;
                education.country_id = $scope.country.id;
                education.description = $scope.educationDescription;
                education.start_date = $scope.startDate + '-01-01';
                education.end_date = $scope.endDate + '-01-01';
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


            //                    school: "Universidad de Montevideo",
//                    degree: "Telematic Engineering",
//                    major: "Computer Engineering",
//                    startDate: "2009",
//                    endDate: "",
//                    country: "",
//                    state: "",
//                    description: "Description description alo hola bueno ta"




        }]);



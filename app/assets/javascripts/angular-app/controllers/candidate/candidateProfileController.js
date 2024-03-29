angular.module('gradshub-ng.controllers').controller('candidateProfileController',
        ['$scope', '$rootScope', '$http', '$upload', '$location', '$anchorScroll','sessionService', '$state', '$stateParams', 
        'Country', 'State', 'Candidate', 'Employer', 'Skill', 'Interest', 'School', 'Major', 'Degree', 'Education', 
        'CandidateSkills', 'CandidateInterests', 'CandidateLanguages', 'Utils', 'Experience', 'alertService', 'modalService', 
        'ALERT_CONSTANTS', 'errors', 'eventTracker',


        function ($scope, $rootScope, $httpProvider, $upload, $location, $anchorScroll, sessionService, $state, $stateParams, Country,
                  State, Candidate, Employer, Skill, Interest, School, Major, Degree, Education, CandidateSkills,
                  CandidateInterests, CandidateLanguages, Utils, Experience, alertService, modalService, ALERT_CONSTANTS, errors, 
                  eventTracker) {

            $scope.defaultSummary = "Please add your career interests, skills, accomplishments in a concise 2-3 sentences.  The summary needs to grab the interest of the hiring manager. It will help to find the right job for you! ";
            $scope.defaultSkills = "Please list 3-5 skills that align with your desired role.";
            $scope.defaultExperience = "Please list 2-3 relevant work experiences based on summer jobs, internships, part time or full time jobs that align well with your career goals.";
            $scope.defaultInterests = "Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Sed cursus quam erat, non fringilla dui efficitur vitae. Pellentesque nec sodales lacus. Fusce rutrum diam a dolor vestibulum, at sodales turpis congue. Curabitur condimentum velit elit, id ornare velit eleifend id. In vel lorem ut mi suscipit placerat ut eu nunc. ";
            $scope.defaultLanguages = "Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Sed cursus quam erat, non fringilla dui efficitur vitae. Pellentesque nec sodales lacus. Fusce rutrum diam a dolor vestibulum, at sodales turpis congue. Curabitur condimentum velit elit, id ornare velit eleifend id. In vel lorem ut mi suscipit placerat ut eu nunc. ";
            $scope.defaultEducation = "Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Sed cursus quam erat, non fringilla dui efficitur vitae. Pellentesque nec sodales lacus. Fusce rutrum diam a dolor vestibulum, at sodales turpis congue. Curabitur condimentum velit elit, id ornare velit eleifend id. In vel lorem ut mi suscipit placerat ut eu nunc. ";

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

                $scope.updateUser = updateUser;
                // returns true if the profile is from the logged user
                $scope.notMe = Utils.notMe();

                if ($scope.notMe) {
                    Candidate.get({id: $stateParams.uid}, setUser, errors.userNotFound);
                } else {
                    $scope.userPromise.then(checkAndSetUser, errors.notLoggedIn);
                }
            };

            /* INIT FUNCTIONS */

            var setUser = function(user) {
                $scope.user = user.candidate;
                initCandidateProfile();
            };

            var checkAndSetUser = function (user) {
                if (sessionService.sessionType() == 'Employer') {
                    $state.go('main.employer_profile', {uid: 'me'}, { reload: true })
                } else {
                    setUser(user);
                }
            };

            var initCandidateProfile = function () {
                $scope.selectedSkills = $scope.user.skills.map(function (skill) {
                    return skill.name;
                });

                $scope.selectedInterests = $scope.user.interests.map(function(interest) {
                   return interest.name;
                });

                $scope.coverPhotoURI = $scope.user.cover_image;
                $scope.profilePhotoURI = $scope.user.profile_image;

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
                $scope.isAddingEducation = false;

                $scope.saveEducation = saveEducation;
                $scope.updateEducation = updateEducation;
                $scope.deleteEducation = deleteEducation;

                $scope.onEducationAdd = function () {
                    $scope.isAddingEducation = true;
                };
                $scope.onEducationCancel = function () {
                    $scope.isAddingEducation = false;
                };
            };

            var initExperience = function () {
                $scope.experiences = [];
                $scope.experience = {};
                $scope.addExperienceEnable = false;
                $scope.experienceEditor = false;
                $scope.isAddingExperience = false;

                $scope.saveExperience = saveExperience;
                $scope.updateExperience = updateExperience;
                $scope.deleteExperience = deleteExperience;

                $scope.onExperienceAdd = function() {
                    $scope.isAddingExperience = true;
                };

                $scope.onExperienceCancel = function() {
                    $scope.isAddingExperience = false;
                };
            };

            var initLanguages = function () {
                $scope.language = null;
                $scope.isAddingLanguage = false;
                $scope.languageEditor = false;

                $scope.onLanguageAdd = function () {
                    $scope.isAddingLanguage = true;
                };
                $scope.onLanguageCancel = function () {
                    $scope.isAddingLanguage = false;
                };

                $scope.saveLanguage = saveLanguage;
                $scope.deleteLanguage = deleteLanguage;
                $scope.updateLanguage = updateLanguage;
            };

            /* GETTERS */

            var getData = function () {
                Skill.query(function (skills) {
                    $scope.skillsTags = skills.skills;
                });

                Interest.query(function (interests) {
                    $scope.interestsTags = interests.interests;
                })
            };

            var getEducation = function (educationObj) {
                var education = new Education();
                education.candidate_id = $scope.user.uid;
                education.school_id = educationObj.school_id ? educationObj.school_id : null;
                education.other_school = educationObj.other_school ? educationObj.other_school : null;
                education.degree_id = educationObj.degree_id ? educationObj.degree_id : null;
                education.other_degree = educationObj.other_degree ? educationObj.other_degree : null;
                education.major_id = educationObj.major_id ? educationObj.major_id : null;
                education.other_major = educationObj.other_major ? educationObj.other_major : null;
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
                Utils.candidateFromObject($scope.user).$update().then(
                    function (response) {
                        $scope.user = response.candidate;  // ToDO !! update only user.summary
                        initCandidateProfile(); //Update profile variables;
                        $scope.defaultSummaryEnable = false;
                        alertService.addInfo('Summary successfully updated!', ALERT_CONSTANTS.SUCCESS_TIMEOUT);

                        eventTracker.saveAboutMe('Candidate');
                    }
                ).catch(alertService.defaultErrorCallback);
            };

            var saveSkills = function () {
                $scope.disableSkillsEditor();
                var candidateSkills = new CandidateSkills();
                candidateSkills.candidate_id = $scope.user.uid;
                candidateSkills.skills = $scope.candidateSelectedSkills.slice().map(function (skillName) {
                    return {name: skillName}
                });

                candidateSkills.$update().then(
                    function (response) {
                        $scope.selectedSkills = response.skills.map(function (skill) {
                            return skill.name;
                        });
                        alertService.addInfo('Skills successfully added!', ALERT_CONSTANTS.SUCCESS_TIMEOUT);

                        eventTracker.saveSkills('Candidate');
                    }
                ).catch(alertService.defaultErrorCallback);
            };

            var saveInterests = function() {
                $scope.disableInterestsEditor();
                var candidateInterests = new CandidateInterests();
                candidateInterests.candidate_id = $scope.user.uid;
                candidateInterests.interests = $scope.candidateSelectedInterests.slice().map(function (interestName) {
                    return {name: interestName}
                });

                candidateInterests.$update().then(
                    function(response) {
                        $scope.selectedInterests = response.interests.map(function (interest) {
                            return interest.name;
                        });
                        alertService.addInfo('Interests successfully added!', ALERT_CONSTANTS.SUCCESS_TIMEOUT);

                        eventTracker.saveInterests('Candidate');
                    }
                ).catch(alertService.defaultErrorCallback())
            };

            var saveEducation = function (valid) {
                if (!valid) return;
                $scope.addEducationEnable = false;
                var education = getEducation($scope.education); // Create Education Resource
                $httpProvider.defaults.headers.common['Authorization'] = sessionService.authenticationToken();
                education.$save(
                    function (response) {
                        addAndSort($scope.user.educations, response.education, Utils.sortByStartDate);
                        alertService.addInfo('Education successfully added!', ALERT_CONSTANTS.SUCCESS_TIMEOUT);

                        eventTracker.saveEducation('Candidate');
                    }
                ).catch(alertService.defaultErrorCallback);
            };

            var saveExperience = function (valid) {
                if (!valid) return;
                $scope.addExperienceEnable = false;
                var experience = getExperience($scope.experience); //Create Experience Resource
                experience.$save(
                    function (response) {
                        addAndSort($scope.user.experiences, response.experience, Utils.sortByStartDate);
                        alertService.addInfo('Experience successfully added!', ALERT_CONSTANTS.SUCCESS_TIMEOUT);

                        eventTracker.saveExperience('Candidate');
                    }
                ).catch(alertService.defaultErrorCallback);
            };

            var getLanguage = function (language) {
              return new CandidateLanguages({
                  language_id: language.language_id,
                  level: language.level.toLowerCase(),
                  candidate_id: $scope.user.uid
              })
            };

            var saveLanguage = function (valid) {
                if (!valid) return;
                var language = getLanguage($scope.language); //Create Language Resource
                language.$save().then(
                    function(response) {
                        addAndSort($scope.user.languages, response.language);
                        alertService.addInfo('Language successfully added!', ALERT_CONSTANTS.SUCCESS_TIMEOUT);

                        eventTracker.saveLanguage('Candidate');
                    }
                ).catch(alertService.defaultErrorCallback)
            };

            /* UPDATE FUNCTIONS */

            var updateEducation = function (valid, $index) {
                if (!valid) return;
                $scope.educationEditor = false;
                var education = getEducation($scope.user.educations[$index]);
                education.id = $scope.user.educations[$index].id;
                education.$update().then(
                    function (response) {
                        updateAndSort($scope.user.educations, response.education, Utils.sortByStartDate);
                        alertService.addInfo('Education successfully updated!', ALERT_CONSTANTS.SUCCESS_TIMEOUT);
                    }
                ).catch(alertService.defaultErrorCallback);
            };

            var updateExperience = function (valid, index) {
                if (!valid) return;
                $scope.experienceEditor = false;
                var experience = getExperience($scope.user.experiences[index]);
                experience.id = $scope.user.experiences[index].id;
                experience.$update().then(
                    function (response) {
                        updateAndSort($scope.user.experiences, response.experience, Utils.sortByStartDate);
                        alertService.addInfo('Experience successfully updated!', ALERT_CONSTANTS.SUCCESS_TIMEOUT);
                    }
                ).catch(alertService.defaultErrorCallback);
            };

            var updateLanguage = function (valid, updated) {
                if (!valid) return;
                var language = getLanguage(updated);
                language.id = updated.id;
                language.$update().then(
                    function(response) {
                        updateAndSort($scope.user.languages, response.language);
                        alertService.addInfo('Language successfully updated!', ALERT_CONSTANTS.SUCCESS_TIMEOUT);
                    }
                ).catch(alertService.defaultErrorCallback);
            };

            /* DELETES */

            var deleteExperience = function(index) {
                var deleteIt = function() {
                    var experience = new Experience({
                        candidate_id: $scope.user.uid,
                        id: $scope.user.experiences[index].id
                    });
                    experience.$delete().then(
                        function () {
                            removeElementAndSort($scope.user.experiences, index, Utils.sortByStartDate);
                            alertService.addInfo('Experience successfully deleted!', ALERT_CONSTANTS.SUCCESS_TIMEOUT);
                        }
                    ).catch(alertService.defaultErrorCallback);
                };
                modalService.confirm("Are you sure you want to delete this experience?").then(deleteIt)
            };

            var deleteEducation = function(index) {
                var deleteIt = function() {
                    var education = new Education({
                        candidate_id: $scope.user.uid,
                        id: $scope.user.educations[index].id
                    });
                    education.$delete().then(
                        function() {
                            removeElementAndSort($scope.user.educations, index, Utils.sortByStartDate);
                            alertService.addInfo('Education successfully deleted!', ALERT_CONSTANTS.SUCCESS_TIMEOUT);
                        }
                    ).catch(alertService.defaultErrorCallback);
                };
                modalService.confirm("Are you sure you want to delete this education?").then(deleteIt)
            };

            var deleteLanguage = function(language) {
                var deleteIt = function(language) {
                    var language = new CandidateLanguages({
                        candidate_id: $scope.user.uid,
                        id: language.id
                    });
                    language.$delete().then(
                        function() {
                            var index = $scope.user.languages.map(function(elem) {return elem.id}).indexOf(language.id);
                            removeElementAndSort($scope.user.languages, index);
                            alertService.addInfo('Language successfully deleted!', ALERT_CONSTANTS.SUCCESS_TIMEOUT);
                        }
                    ).catch(alertService.defaultErrorCallback);
                };
                modalService.confirm("Are you sure you want to delete this language?").then(
                    function() {
                        deleteIt(language)
                    }
                )
            };

            var removeElementAndSort = function (array, index, sortFunction) {
                array.splice(index, 1);
                sort(array, sortFunction);
            };

            var addAndSort = function (array, element, sortFunction) {
                array.push(element);
                sort(array, sortFunction);
            };

            var updateAndSort = function (array, element, sortFunction) {
                var index = array.map(function(elem) {return elem.id}).indexOf(element.id);
                array[index] = element;
                sort(array, sortFunction);
            };

            var sort = function(array, sortFunction) {
                if (sortFunction)
                    sortFunction(array);
                else
                    array.sort();
            };

            var updateUser = function () {
                Utils.candidateFromObject($scope.user).$update(function (response) { //Creates resource User from object $scope.user
                        $scope.user = response.candidate;
                        initCandidateProfile(); //Update profile variables;
                    }
                ).catch(alertService.defaultErrorCallback);
            };


            $scope.updateCoverImage = function (coverImage){
                $scope.user.cover_image = coverImage;
                updateUser();

                eventTracker.saveCoverPhoto('Candidate');
            };

            $scope.updateProfileImage = function (profileImage){
                $scope.user.profile_image = profileImage;
                updateUser();

                eventTracker.saveProfilePhoto('Candidate');
            };

            //<<<<<<<<<<<<<<< utilities functions >>>>>>>>>>>>>>>

            // function called when the user leave the page
            window.onbeforeunload = function () {
                if ($scope.coverPhotoInProgress || $scope.profilePhotoInProgress) {
                    return 'You have unsaved changes.\nTo save press the save button over your cover photo.';
                }
            };

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


            /* OTHER FUNCTIONS */

            init();

        }]);

angular.module('gradshub-ng.controllers').controller('employerProfileController',
    ['$scope', '$rootScope', '$http', '$upload', 'sessionService', '$state', '$stateParams','Skill', 'Country', 'State',
        'Employer', 'EmployerSkills', 'EmployerCompany', 'Utils', 'EmployerInterests', 'alertService', 'errors', 'eventTracker',

        function($scope, $rootScope,$httpProvider, $upload, sessionService, $state, $stateParams,Skill, Country, State,
                 Employer, EmployerSkills, EmployerCompany, Utils, EmployerInterests, alertService, errors, eventTracker) {
            var init = function () {
                getData();

                /* SKILLS */
                initSkills();

                /* INTERESTS */
                initInterests();

                // returns true if the profile is from the logged user
                $scope.notMe = Utils.notMe();

                if ($scope.notMe) {
                    Employer.get({id: $stateParams.uid}, setUser, errors.userNotFound);
                } else {
                    $scope.userPromise.then(checkAndSetUser, errors.notLoggedIn);
                }

            };

            var setUser = function (user) {
                $scope.user = user.employer;
                initEmployerProfile();
                // Fire event to catch it in editCompany directive
                $scope.$broadcast('userLoaded');
            };

            var checkAndSetUser = function (user) {
                if (sessionService.sessionType() == 'Candidate') {
                    $state.go('main.candidate_profile', {uid: 'me'}, { reload: true })
                } else {
                    setUser(user);
                }
            };

            // get data from db
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
            };

            var initEmployerProfile = function(){

                $scope.employerCompany = $scope.user.company;

                $scope.selectedSkills = $scope.user.skills.map(function (skill) {
                    return skill.name;
                });
                $scope.selectedInterests = $scope.user.interests.map(function (interest) {
                    return interest.name;
                });

                // hide
                $scope.descriptionEnable = false;
            }


            $scope.updateEmployerCoverImage = function (coverImage){
                $scope.user.cover_image = coverImage;
                $scope.updateUser();

                eventTracker.saveCoverPhoto('Employer');
            }

            $scope.updateEmployerCompanyImage = function (companyImage){
                $scope.user.company_logo = companyImage;
                $scope.updateUser();

                eventTracker.saveCompanyLogo('Employer');
            }

            $scope.updateEmployerProfileImage = function (profileImage) {
                $scope.user.profile_image = profileImage;
                $scope.updateUser();

                eventTracker.saveProfilePhoto('Employer');
            }
            
            $scope.updateUser = function () {
                Utils.employerFromObject($scope.user).$update(function (response) { //Creates resource User from object $scope.user
                        $scope.user = response.employer;
                        initEmployerProfile(); //Update profile variables;
                    }
                ).catch(alertService.defaultErrorCallback);
            };

            // Description
            $scope.enableDescriptionEditor = function() {
                $scope.summary = $scope.employerDescription;
                $scope.descriptionEnable = true;
                $scope.editorDescriptionEnabled = true;
            }

            $scope.saveDescription = function() {
                // Description of employer is stored in employerCompany, a child obeject of employer user.

                $scope.user.company.description = $scope.user.company_description;
                $scope.updateUser();
                
                $scope.disableDescriptionEditor();

                eventTracker.saveAboutMe('Employer');
            }

            $scope.disableDescriptionEditor = function() {
                $scope.descriptionEnable = false;
                $scope.editorDescriptionEnabled = false;
            }

            // Skills
            var initSkills = function() {
                $scope.employerSelectedSkills = [];
                $scope.selectedSkills = [];
                $scope.editorSkillsEnabled = false;

                $scope.enableSkillsEditor = function() {
                    $scope.editorSkillsEnabled = true;
                    if($scope.selectedSkills.length > 0) {
                        $scope.employerSelectedSkills = $scope.selectedSkills.slice();
                    }
                };

                $scope.disableSkillsEditor = function() {
                    $scope.editorSkillsEnabled = false;
                };

                $scope.saveSkills = saveSkills;
            };

            var saveSkills = function(){
                $scope.disableSkillsEditor();
                $scope.selectedSkills = $scope.employerSelectedSkills.slice();

                var employerSkills = new EmployerSkills();
                employerSkills.employer_id = $scope.user.uid;
                employerSkills.skills = $scope.selectedSkills.map(function(skillName) {
                    return {name: skillName}
                });

                // need to be updated in backend.
                employerSkills.$update(
                    function (response) {
                        $scope.selectedSkills = response.skills.map(function (skill) {
                            return skill.name;
                        });
                    },
                    function(error) {
                        console.log(error)
                });
            };

            // interests
            var initInterests = function() {
                $scope.employerSelectedInterests = [];
                $scope.selectedInterests = [];
                $scope.editorInterestsEnabled = false;

                $scope.enableInterestsEditor = function() {
                    $scope.editorInterestsEnabled = true;
                    if($scope.selectedInterests.length > 0) {
                        $scope.employerSelectedInterests = $scope.selectedInterests.slice();
                    }
                };

                $scope.disableInterestsEditor = function() {
                    $scope.editorInterestsEnabled = false;
                };

                $scope.saveInterests = saveInterests;
            };


            var saveInterests = function() {
                $scope.disableInterestsEditor();
                $scope.selectedInterests = $scope.employerSelectedInterests.slice();
                
                var employerInterests = new EmployerInterests();
                employerInterests.employer_id = $scope.user.uid;
                employerInterests.interests = $scope.selectedInterests.map(function(skillName) {
                    return {name: skillName}
                });
                // need to be updated in backend.
                employerInterests.$update(
                    function (response) {
                    },
                    function(error) {
                        console.log(error)
                });
            };
            
            // company info
            $scope.saveEmployerCompany = function() {
                var empCom = $scope.employerCompany;

                // save
                var employerCompany = new EmployerCompany();
                employerCompany.employer_id = $scope.user.uid;
                employerCompany.company_id = empCom.company_id;
                employerCompany.country_id = empCom.country.id;
                employerCompany.state_id = empCom.state.id;
                employerCompany.description = empCom.description;
                employerCompany.image = empCom.image;
                employerCompany.site_url = empCom.site_url;
                
                employerCompany.$update(
                    function(employerCompanyUpdated) {
                        $scope.user.company = employerCompanyUpdated.company;
                    }, function(error) {
                        console.log(error);
                    }
                );
            }

            init();
        }]);



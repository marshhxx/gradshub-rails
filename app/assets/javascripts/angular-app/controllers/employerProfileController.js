angular.module('mepedia.controllers').controller('employerProfileController',
    ['$scope', '$rootScope', '$http', '$upload', 'sessionService', '$state', 'Skill', 'Country', 'State', 'EmployerSkills', 'EmployerCompany', 'Utils', 'EmployerInterests',

        function($scope, $rootScope,$httpProvider, $upload, sessionService, $state, Skill, Country, State, EmployerSkills, EmployerCompany, Utils, EmployerInterests) {
            var init = function () {
                getData();

                /* SKILLS */
                initSkills();

                /* INTERESTS */
                initInterests();

                $scope.userPromise.then(
                    function (user) {
                        $scope.user = user.employer;
                        initEmployerProfile();
                        // Fire event to catch it in editCompany directive
                        $scope.$broadcast('userLoaded');
                    }
                );

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
                //updateUser();
            }

            $scope.updateEmployerCompanyImage = function (companyImage){
                $scope.user.company_image = companyImage;
                //updateUser();
            }

            $scope.updateEmployerProfileImage = function (profileImage) {
                $scope.user.profile_image = profileImage;
                //updateUser();
            }


            // Description
            $scope.enableDescriptionEditor = function() {
                $scope.summary = $scope.employerDescription;
                $scope.descriptionEnable = true;
                $scope.editorDescriptionEnabled = true;
            }

            $scope.saveDescription = function() {
                // Description of employer is stored in employerCompany, a child obeject of employer user.
                $scope.saveEmployerCompany();
                
                $scope.disableDescriptionEditor();
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
                $httpProvider.defaults.headers.common['Authorization'] = sessionService.authenticationToken();
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
                $httpProvider.defaults.headers.common['Authorization'] = sessionService.authenticationToken();
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
                employerCompany.site_url = empCom.site_url;
                
                $httpProvider.defaults.headers.common['Authorization'] = sessionService.authenticationToken();

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



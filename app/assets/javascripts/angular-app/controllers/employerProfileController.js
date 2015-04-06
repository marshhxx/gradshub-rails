angular.module('mepedia.controllers').controller('employerProfileController',
    ['$scope', '$rootScope', '$http', '$upload', 'sessionService', '$state', 'Skill', 'Country', 'State', 'EmployerSkills', 'EmployerInterests', 'EmployerCompany', 'Utils',

        function($scope, $rootScope,$httpProvider, $upload, sessionService, $state, Skill, Country, State, EmployerSkills, EmployerInterests, EmployerCompany, Utils) {
            var init = function () {
                getData();

                /* SKILLS */
                initSkills();

                /* INTERESTS */
                initInterests();

                sessionService.requestCurrentUser().then(
                    function (user) {
                        $scope.user = user.employer;
                        initEmployerProfile();

                        // Fire event to catch it in editCompany directive
                        $scope.$broadcast('userLoaded');
                    },
                    function (error) {
                        console.log(error);
                        $state.go('home.page');
                    }
                );
            };

            var initEmployerProfile = function(){

                // this is static, it doesn't seems to be done.
                console.log($scope);
                $scope.user.company = [{
                    name: 'Ceibal',
                    industry: 'Information Techonology',
                    description: 'Mi descripcion man',
                    state: 'Montevideo',
                    country: 'Uruguay',
                    companyUrl: 'www.ceibal.edu.uy'
                }];
                
                $scope.employerCompany = $scope.user.company[0];

            }
            // Description
            $scope.descriptionEnable = false;

            $scope.enableDescriptionEditor = function() {
                $scope.summary = $scope.employerDescription;
                $scope.descriptionEnable = true;
                $scope.editorDescriptionEnabled = true;
            }

            $scope.saveDescription = function() {
                $scope.employerDescription = $scope.summary;
                $scope.descriptionEnable = false;
                $scope.editorDescriptionEnabled = false;
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
                        console.log($scope.selectedSkills);
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

                console.log($scope.employerSelectedSkills);

                $scope.selectedSkills = $scope.employerSelectedSkills.slice();
                console.log($scope.selectedSkills);

                var employerSkills = new EmployerSkills();
                
                console.log(employerSkills);

                employerSkills.candidate_id = $scope.user.uid;
                employerSkills.skills = $scope.selectedSkills.map(function(skillName) {
                    return {name: skillName}
                });
                // need to be updated in backend.
                $httpProvider.defaults.headers.common['Authorization'] = sessionService.authenticationToken();
                employerSkills.$update(
                    function (response) {
                        refreshSkills();
                    },
                    function(error) {
                        console.log(error)
                });
            };


            var refreshSkills = function () {
                EmployerSkills.query({candidate_id: $scope.user.uid}, function (skills) {
                    $scope.employerSelectedSkills = skills.skills;
                })
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


            var saveInterests = function(){
                $scope.disableInterestsEditor();
                $scope.selectedInterests = $scope.employerSelectedInterests.slice();
                var employerInterests = new EmployerInterests();
                employerInterests.candidate_id = $scope.user.uid;
                employerInterests.skills = $scope.selectedInterests.map(function(skillName) {
                    return {name: skillName}
                });
                // need to be updated in backend.
                $httpProvider.defaults.headers.common['Authorization'] = sessionService.authenticationToken();
                employerInterests.$update(
                    function (response) {
                        refreshSkills();
                    },
                    function(error) {
                        console.log(error)
                });
            };


            var refreshInterests = function () {
                EmployerInterests.query({candidate_id: $scope.user.uid}, function (skills) {
                    $scope.employerSelectedInterests = skills.skills;
                })
            };

            
            // company info
            $scope.saveEmployer = function(employerUser) {
                $scope.user = employerUser;
                $httpProvider.defaults.headers.common['Authorization'] = sessionService.authenticationToken();
                Utils.employerFromObject($scope.user).$update(function(response) {
                    console.log(response);
                }, function(error) {
                    console.log('An error has occurred');
                });
            }


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

                Skill.get(function(skills) {
                    $scope.skillsTags = skills.skills;
                });
              
            };
            init();
        }]);



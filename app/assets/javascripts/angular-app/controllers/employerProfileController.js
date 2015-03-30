angular.module('mepedia.controllers').controller('employerProfileController',
    ['$scope', '$rootScope', '$http', '$upload', 'sessionService', 'Skill', 'Country', 'State',

        function($scope, $rootScope,$httpProvider, $upload, sessionService, Skill, Country, State) {
            var init = function () {
                getData();

                /* SUMMARY 
                initSummary();
                */
                /* SKILLS */
                initSkills();

                sessionService.requestCurrentUser().then(
                    function (user) {
                        $scope.user = user.candidate;
                        initEmployerProfile();

                    },
                    function (error) {
                        console.log(error);
                        $state.go('home.page');
                    }
                );
            };

            var initEmployerProfile = function(){
                $scope.selectedSkills = $scope.user.skills;

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
                $scope.candidateSelectedSkills = [];
                $scope.selectedSkills = [];
                $scope.editorSkillsEnabled = false;

                $scope.enableSkillsEditor = function() {
                    console.log('hoal');
                    $scope.editorSkillsEnabled = true;
                    if($scope.selectedSkills.length > 0)
                        $scope.candidateSelectedSkills = $scope.selectedSkills.slice();
                };

                $scope.disableSkillsEditor = function() {
                    $scope.editorSkillsEnabled = false;
                };

                $scope.saveSkills = saveSkills;
            };


            var saveSkills = function(){
                $scope.disableSkillsEditor();
                $scope.selectedSkills = $scope.candidateSelectedSkills.slice();
                var candidateSkills = new CandidateSkills();
                candidateSkills.candidate_id = $scope.user.uid;
                candidateSkills.skills = $scope.selectedSkills.map(function(skillName) {
                    return {name: skillName}
                });
                $httpProvider.defaults.headers.common['Authorization'] = sessionService.authenticationToken();
                candidateSkills.$update(
                    function (response) {
                        refreshSkills();
                    },
                    function(error) {
                        console.log(error)
                });
            };


            var refreshSkills = function () {
                CandidateSkills.query({candidate_id: $scope.user.uid}, function (skills) {
                    $scope.candidateSelectedSkills = skills.skills;
                })
            };

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



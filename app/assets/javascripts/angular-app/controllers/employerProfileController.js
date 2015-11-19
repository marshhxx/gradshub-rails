angular.module('gradshub-ng.controllers').controller('employerProfileController',
    ['$scope', '$rootScope', '$http', '$upload', 'sessionService', '$state', '$stateParams','Skill', 'Country', 'State',
        'Employer', 'Utils', 'alertService', 'errors', 'eventTracker',

        function($scope, $rootScope,$httpProvider, $upload, sessionService, $state, $stateParams,Skill, Country, State,
                 Employer, Utils, alertService, errors, eventTracker) {
            var init = function () {
                getData();

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

                // hide
                $scope.descriptionEnable = false;
            }

            $scope.updateEmployerCompanyImage = function (companyImage){
                $scope.user.company_logo = companyImage;

                updateUser();

                eventTracker.saveCompanyLogo('Employer');
            }

            $scope.updateEmployerProfileImage = function (profileImage) {
                $scope.user.profile_image = profileImage;
                updateUser();

                eventTracker.saveProfilePhoto('Employer');
            }

            $scope.updateCompanyUser = function() {
                updateUser();
            }

            var updateUser = function () {
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
                // Employer description is stored on employerCompany.
                $scope.user.company.description = $scope.user.company_description;

                updateUser();
                $scope.disableDescriptionEditor();

                eventTracker.saveAboutMe('Employer');
            }

            $scope.disableDescriptionEditor = function() {
                $scope.descriptionEnable = false;
                $scope.editorDescriptionEnabled = false;
            }

            init();
        }]);



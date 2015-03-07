angular.module('mepedia.controllers').controller('profileController',
    ['$scope', '$rootScope', '$routeParams', '$location', '$upload', 'sessionService',

        function($scope, $rootScope, $routeParams, $location, $upload) {

//            $scope.user = sessionService.requestCurrentUser()
//
//            $scope.logout = function() {
//                sessionService.logout()
//            }
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
        }]);
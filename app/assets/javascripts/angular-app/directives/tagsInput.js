angular.module('mepedia.directives').directive('tagsInput', function () {
    return {
        restrict: 'E',
        scope: { tags: '=', placeholder: '@', customerInfo: '=info'},
        template:
            '<div class="tagsinput cont left">' +
            '<input type="text" ng-model="new_value" class="form-control tagsInput" typeahead="tag as tag.name for tag in tags | filter:$viewValue | limitTo:6">' +
            '</div>'   +  '<div class="tagsinput cont right">' +
            '<a class="tagsinput addbutton" ng-click="add()">Add</a>' + '</div>' +
            '<div class="tags">' +
            '<a class="tag" ng-model="flavor" ng-repeat="(idx, tag) in newTags" ng-click="remove(idx)">{{tag}}</a>' +
            '</div>',
        link: function ( $scope, $element) {
            var input = angular.element( $element.children()[0].childNodes[0] );
            $scope.newTags = [];

            // This adds the new tag to the tags array
            $scope.add = function() {
                if($scope.newTags.length < 9) {
                    if($scope.new_value.name) {
                        $scope.customerInfo.push($scope.new_value.name);
                        $scope.newTags.push($scope.new_value.name);
                        $scope.new_value = "";
                    }
                }
            };

            // This is the ng-click handler to remove an item
            $scope.remove = function ( idx ) {
                $scope.newTags.splice( idx, 1 );
                $scope.customerInfo.splice( idx, 1 );
            };

            input.attr('placeholder', $scope.placeholder);
            // Capture all keypresses
            input.bind('keypress', function ( event ) {

                console.log("$scope.placeholder");
                // But we only care when Enter was pressed
                if ( event.keyCode == 13 ) {
                    // There's probably a better way to handle this...
                    $scope.$apply( $scope.add );
                }
            });
        }
    };
});
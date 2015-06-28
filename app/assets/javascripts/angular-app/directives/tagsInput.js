angular.module('mepedia.directives').directive('tagsInput', function () {
    return {
        restrict: 'E',
        scope: { tags: '=', currentTags: '=info'},
        template: function (elem, attr) {
            var placeholder = attr.placeholder ? attr.placeholder : '';
            var signupClass = attr.signup == "" ? 'tags-box' : '';
            return '<div class="tagsinput-container">'+'<div class="tagsinput-right">' +
            '<a class="tagsinput addbutton btn-sm" ng-click="add()">Add</a>' + '</div>' +
            '<div class="tagsinput-left">' +
            '<input type="text" ng-model="new_value" class="input-sm form-control"' +
            'typeahead="tag as tag.name for tag in tags | filter:$viewValue | limitTo:6" placeholder="' + placeholder + '">' +
            '</div>' + '</div>' +
            '<div class="tags ' + signupClass + '">' +
            '<a class="tag" ng-model="flavor" ng-repeat="(idx, tag) in currentTags" ng-click="remove(idx)">{{tag}}</a>' +
            '</div>'
        },
        link: function ( $scope, $element) {
            var input = angular.element( $element.children()[0].childNodes[1] );

            // This adds the new tag to the tags array
            $scope.add = function() {
                if($scope.new_value.name && $scope.currentTags.indexOf($scope.new_value.name) == -1) {
                    $scope.currentTags.push($scope.new_value.name);
                }
                $scope.new_value = "";
            };

            // This is the ng-click handler to remove an item
            $scope.remove = function ( idx ) {
                $scope.currentTags.splice( idx, 1 );
            };

            // Capture all keypresses
            input.bind('keypress', function ( event ) {
                // But we only care when Enter was pressed
                if ( event.keyCode == 13 ) {
                    // There's probably a better way to handle this...
                    $scope.$apply( $scope.add );
                }
            });

        }
    };
});
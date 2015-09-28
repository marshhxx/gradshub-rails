documentClickListener = ($document) ->
  {
  restrict: 'A',
  link: (scope, elem, attr, ctrl) ->
    $document.bind 'click', (event) ->
        isClickedElementChildOfPopup = elem.find(event.target).length > 0

        if isClickedElementChildOfPopup then return
        
        scope.$parent.isOptionsVisible = false
        scope.$parent.$apply()
    
}
angular
  .module('gradshub-ng.directives')
  .directive('documentClickListener', ['$document', documentClickListener]);
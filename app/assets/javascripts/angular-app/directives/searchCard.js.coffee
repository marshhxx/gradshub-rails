SearchCard = () ->
  {
  scope: {
    user: '=data', # Represents User in users array
  },
  templateUrl: 'angular-app/templates/directives/search-card.html',
  link: ($scope, $element, attr) ->

  }
angular
.module('mepedia.directives')
.directive('searchCard', SearchCard);
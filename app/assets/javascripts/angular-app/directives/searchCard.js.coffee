SearchCard = ($state) ->
  {
  scope: {
    user: '=data', # Represents User in users array
  },
  templateUrl: 'angular-app/templates/directives/search-card.html',
  link: (scope, $element, attr) ->

    scope.goToProfile = ->
      $state.go "main.#{scope.user.type.toLowerCase()}_profile", {uid: scope.user.uid}, { reload: true }

  }
angular
.module('mepedia.directives')
.directive('searchCard', SearchCard);
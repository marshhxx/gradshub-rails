SearchCard = ($state, sessionService, presenceService) ->
  {
  scope: {
    user: '=data', # Represents User in users array
  },
  templateUrl: 'angular-app/templates/directives/search-card.html',
  link: (scope, $element, attr) ->
    scope.status = 'Offline'
    scope.logged = sessionService.isAuthenticated()

    scope.goToProfile = ->
      $state.go "main.#{scope.user.type.toLowerCase()}_profile", {uid: scope.user.uid}, { reload: true }

    presenceService.isOnline(scope.user.uid).then( (resp) ->
      scope.status = if resp.isPresent then 'Online' else 'Offline'
    )

    scope.$on('gradshub_presence-' + scope.user.uid + '-event', (event, args) ->
      scope.status = if args.event.action == 'join' then 'Online' else 'Offline'
      scope.$apply();
    )

  }
angular
.module('gradshub-ng.directives')
.directive('searchCard', SearchCard);
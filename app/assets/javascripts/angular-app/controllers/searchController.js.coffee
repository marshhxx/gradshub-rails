angular
.module('mepedia.controllers')
.controller("searchController",
  ['$scope', '$rootScope', '$q', '$http', '$state', 'sessionService',
    ($scope, $rootScope, $q, $httpProvider, $state, sessionService)->
      init = ->

      init()
  ])
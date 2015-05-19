AlertService = ($rootScope, $timeout) ->
  alertService = {};

  # create an array of alerts available globally
  $rootScope.alerts = [];

  alertService.add = (type, msg, timeout) ->
    $rootScope.alerts.push(
      {
        'type': type,
        'msg': msg,
        'close': -> alertService.closeAlert(this)
      })
    if timeout?
      $timeout(
        ->
          alertService.closeAlert(this)
      ,
        timeout)

  alertService.addInfo = (msg, timeout) ->
    alertService.add("success", msg, timeout)

  alertService.closeAlertByIndex = (index) ->
    $rootScope.alerts.splice(index, 1);

  alertService.closeAlert = (alert) ->
    alertService.closeAlertByIndex($rootScope.alerts.indexOf(alert))

  alertService.clear = ->
    $rootScope.alerts = [];

  alertService.addError = (error, timeout) ->
    for reason in error.reasons
      alertService.add("danger", reason, timeout)

  alertService;

angular
.module('mepedia.services')
.factory('alertService', AlertService);
AlertService = ($rootScope, $timeout, ALERT_CONSTANTS) ->
  alertService = {};

  titles = {'danger': 'Something went wrong', 'warning': 'Warning', 'success': 'Success'}

  # create an array of alerts available globally
  $rootScope.alerts = [];

  alertService.add = (type, msg, timeout) ->
    $rootScope.alerts = []
    $rootScope.alerts.push(
      {
        'title': titles[type],
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

  alertService.addErrors = (errors, timeout) ->
    if errors.reasons.length <= 1
      alertService.addError(errors, timeout)
    else
      reasons = 'Reasons:<br> <ul>'
      for reason in errors.reasons
        reasons += '<li>' + reason + '</li>'
      reasons += '</ul>'
      alertService.add("danger", reasons, timeout)

  alertService.defaultErrorCallback = (error) ->
    alertService.addErrors(error.data.error, ALERT_CONSTANTS.ERROR_TIMEOUT)

  alertService;

angular
.module('mepedia.services')
.factory('alertService', AlertService);
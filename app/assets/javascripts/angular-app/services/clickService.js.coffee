Click = ($timeout, $location, $anchorScroll) ->
	# timeout makes sure that it is invoked after any other event has been triggered.
	# e.g. click events that need to run before the focus or
	# inputs elements that are in a disabled state but are enabled when those events
	# are triggered.
	scrollTo = (id) ->
		old = $location.hash()
		$location.hash(id)
		$anchorScroll()
		$location.hash(old)

	(id) ->
		$timeout(
			->
				element = angular.element('#' + id)
				if element
					scrollTo(id)
					element.triggerHandler('click')
		)
angular
.module('mepedia.services')
.factory('click',['$timeout', '$location', '$anchorScroll', Click])
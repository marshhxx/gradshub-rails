angular.module('mepedia.services').factory "cookieJar", ($cookieStore) ->
	service = {
		get: (name) ->
			$cookieStore.get(name)
		,
		put: (name, vallue) ->
			$cookieStore.put(name, vallue)
		,
		delete: (name) ->
			$cookieStore.remove(name)
		,
		isDefined: (name) ->
			this.get(name)?
	}
	noCookies = {
		get: (name) ->

		,
		put: (name, vallue) ->

		,
		delete: (name) ->

		,
		isDefined: (name) ->
			false
	}
	noCookies
CookieJar = ($cookieStore) ->
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

angular
  .module('gradshub-ng.services')
  .factory "cookieJar", CookieJar

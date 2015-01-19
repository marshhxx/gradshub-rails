angular.module('mepedia.services', ['ngCookies', 'ngResource'])
angular.module('mepedia.directives',[])
angular.module('mepedia.controllers', ['mepedia.services', 'mepedia.directives', "ui.bootstrap"])

'use strict'
angular.module('mepedia.config', [])
angular.module('mepedia.services', ['ngCookies', 'ngResource', 'mepedia.config'])
angular.module('mepedia.directives',['mepedia.services'])
angular.module('mepedia.controllers', ['mepedia.services', 'mepedia.directives',
                                       "ui.bootstrap", "cloudinary", "angularFileUpload"])
angular.module('frapontillo.bootstrap-switch', [])
angular.module('app', ['toggle-switch'])


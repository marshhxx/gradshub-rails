'use strict'
angular.module('gradshub-ng.config', [])
angular.module('gradshub-ng.services', ['ngCookies', 'ngResource', 'gradshub-ng.config'])
angular.module('gradshub-ng.directives',['gradshub-ng.services'])
angular.module('gradshub-ng.controllers', ['gradshub-ng.services', 'gradshub-ng.directives',
                                       "ui.bootstrap", "cloudinary", "angularFileUpload"])


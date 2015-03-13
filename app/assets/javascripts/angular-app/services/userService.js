angular.module('mepedia.services').factory('User', function($resource) {
    return $resource('/api/users/:id', { id: '@uid' },
        {
            update: {
                method: 'PUT'
        }
    });
});
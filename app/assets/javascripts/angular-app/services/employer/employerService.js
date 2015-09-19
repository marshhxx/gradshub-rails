angular
    .module('mepedia.services')
    .factory('Employer', function($resource) {
        var Employer = $resource('/api/employers/:id', { id: '@uid' },
        {
            update: {
                method: 'PUT'
            },
            changePassword: {
                method: 'PUT',
                url: '/api/employers/:id/password'
            }
        });

        Employer.className = 'Employer';

        Employer.prototype.isEmployer = true;
        return Employer;
});
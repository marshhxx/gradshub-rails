var Utils = function(Candidate, Employer) {

    var utils = {};

    utils.candidateFromObject = function(user){
        var candidate = new Candidate();
        candidate.uid = user.uid;
        candidate.name = user.name;
        candidate.lastname = user.lastname;
        candidate.email = user.email;
        candidate.gender = user.gender;
        candidate.birth = user.birth;
        candidate.profile_image = user.profile_image;
        candidate.cover_image = user.cover_image;
        candidate.tag = user.tag;
        candidate.summary = user.summary;
        return candidate;
    };

    utils.employerFromObject = function(user){
        var employer = new Employer();
        employer.uid = user.uid;
        employer.name = user.name;
        employer.lastname = user.lastname;
        employer.email = user.email;
        employer.gender = user.gender;
        employer.birth = user.birth;
        employer.profile_image = user.profile_image;
        employer.cover_image = user.cover_image;
        employer.tag = user.tag;
        return employer;
    };

    return utils;
}
angular
    .module('mepedia.services')
    .factory('Utils', Utils);
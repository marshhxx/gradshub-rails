var Utils = function(Candidate) {

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
    }

    return utils;
}
angular
    .module('mepedia.services')
    .factory('Utils', Utils);
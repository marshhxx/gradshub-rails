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
        employer.birth = user.birth;
        employer.tag = user.tag;
        employer.company_image = user.company_image;
        employer.profile_image = user.profile_image;
        employer.cover_image = user.cover_image;
        employer.job_title = user.job_title;
        return employer;
    };

    utils.getMonth = function(month){
        switch (month)
        {
            case "01":
                return "January"
            case "02":
                return "February"
            case "03":
                return "March"
            case "04":
                return "April"
            case "05":
                return "May"
            case "06":
                return "June"
            case "07":
                return "July"
            case "08":
                return "August"
            case "09":
                return "September"
            case "10":
                return "October"
            case "11":
                return "November"
            case "12":
                return "December"
        }
    }

    return utils;
}
angular
    .module('mepedia.services')
    .factory('Utils', Utils);
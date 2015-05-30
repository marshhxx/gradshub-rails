var Utils = function(Candidate, Employer) {

    var utils = {};

    var monthToNumberMap = {"January": '01', "February": '02', "March": '03', "April": '04', "May": '05', "June": '06',
    "July": '07', "August": '08', "September": '09', "October": '10', "November": '11', "December": '12'};

    var compareDates = function(one, other) {
        var start = Date.parse(one.start_date);
        var otherStart = Date.parse(other.start_date);
        if (start > otherStart)
            return -1;
        if (start < otherStart)
            return 1;
        return 0;
    };

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
        employer.tag = user.tag;
        employer.company_image = user.company_image;
        employer.profile_image = user.profile_image;
        employer.cover_image = user.cover_image;
        employer.job_title = user.job_title;
        return employer;
    };

    utils.getMonthByNumber = function(number){
        return Object.keys(monthToNumberMap).filter(function (key) {
            return monthToNumberMap[key] == number
        })[0];
    };

    utils.getMonthNumber = function (month) {
      return monthToNumberMap[month]
    };

    utils.sortByStartDate = function (array) {
        array.sort(compareDates)
    };

    return utils;
};
angular
    .module('mepedia.services')
    .factory('Utils', Utils);
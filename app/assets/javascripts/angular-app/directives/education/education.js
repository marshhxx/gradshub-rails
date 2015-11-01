angular.module('gradshub-ng.directives').directive('education', function (Utils) {
  return {
    scope: {
      education: '=data',
      updateEducation: '=',
      onDeleteCallback: '=onDelete'
    },
    templateUrl: 'angular-app/templates/directives/education.html',
    link: function (scope, element, attrs) {

      scope.notMe = Utils.notMe();

      scope.onEducationEditor = function () {
        scope.educationTemp = angular.copy(scope.education);
        scope.educationTemp.country_id = scope.education.country ? scope.education.country.id : null;
        scope.educationTemp.state_id = scope.education.state ? scope.education.state.id : null;
        scope.educationEditor = true;
      };

      /* Methods */

      scope.onSave = function (valid, index) {
        if (valid) {
          scope.education.school_id = scope.educationTemp.school.id;
          scope.education.major_id = scope.educationTemp.major.id;
          scope.education.degree_id = scope.educationTemp.degree.id;
          scope.education.country_id = scope.educationTemp.country_id;
          scope.education.state_id = scope.educationTemp.state_id;
          scope.education.description = scope.educationTemp.description;
          scope.education.end_date = scope.educationTemp.end_date;
          scope.educationEditor = false;
          scope.updateEducation(valid, index);
        }
      };

      scope.onDelete = function (index) {
        scope.educationEditor = false;
        scope.onDeleteCallback(index);
      };

      scope.onCancel = function () {
        scope.educationEditor = false;
      };

      scope.onSchool = function (school) {
        if (!school) return;
        if (Utils.isObject(school)) {
          scope.education.school_id = school.id;
          scope.educationTemp.school = school;
        } else {
          scope.education.other_school = school
        }
      };

      scope.onState = function (state) {
        scope.educationTemp.state_id = state ? state.id : null;
        scope.educationTemp.state = state;
      };

      scope.onCountry = function (country) {
        scope.educationTemp.country_id = country ? country.id : null;
        //scope.educationTemp.country.id = country ? country.id : null;
        scope.educationTemp.country = country;
        scope.educationTemp.state = null;
        scope.educationTemp.state_id = null;
      };

      scope.onMajor = function (major) {
        if (!major) return;
        if (Utils.isObject(major)) {
          scope.education.major_id = major.id;
        } else {
          scope.education.other_major = major
        }
      };

      scope.onDegree = function (degree) {
        if (!degree) return;
        if (Utils.isObject(degree)) {
          scope.education.degree_id = degree.id;
        } else {
          scope.education.other_degree = degree
        }
      };

      scope.getMonth = Utils.getMonthByNumber;
    }
  };
});

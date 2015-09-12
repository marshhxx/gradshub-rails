EventTracker = ($analytics) ->
  eventTracker = {};

  eventTracker.saveAboutMe = (category) ->
    $analytics.eventTrack 'About Me', { category: category, label: 'Save button about me' }

  eventTracker.saveSkills = (category) ->
    $analytics.eventTrack 'Skills', { category: category, label: 'Save button skills' }

  eventTracker.saveInterests = (category) ->
    $analytics.eventTrack 'Interest', { category: category, label: 'Save button interests' }

  eventTracker.saveEducation = (category) ->
    $analytics.eventTrack 'Education', { category: category, label: 'Save button education' }

  eventTracker.saveExperience = (category) ->
    $analytics.eventTrack 'Experience', { category: category, label: 'Save button experience' }

  eventTracker.saveLanguage = (category) ->
    $analytics.eventTrack 'Language', { category: category, label: 'Save button language' }

  eventTracker.saveCoverPhoto = (category) ->
    $analytics.eventTrack 'Cover Photo', { category: category, label: 'Save Cover Photo' }

  eventTracker.saveProfilePhoto = (category) ->
    $analytics.eventTrack 'Profile Photo', { category: category, label: 'Save Profile Photo' }

  eventTracker.saveCompanyLogo = (category) ->
    $analytics.eventTrack 'Company Logo photo', { category: category, label: 'Save Company logo photo' }

  eventTracker.signUpLinkedIn = (category) ->
    $analytics.eventTrack 'Linkedin Sign-in/up', { category: category, label: 'Signup with Linkedin' }

  eventTracker.signUp = (category) ->
    $analytics.eventTrack 'Signup', { category: category, label: 'Signup' }

  eventTracker.login = (category) ->
    $analytics.eventTrack 'Login ' + category, { category: category, label: 'Internal Login ' + category }

  eventTracker.logOut = (category) ->
    $analytics.eventTrack 'Logout', { category: category, label: 'Logout ' + category }

  eventTracker.saveCompanyInfo = (category) ->
    $analytics.eventTrack 'Company Info', { category: category, label: 'Save button company info' }

  eventTracker;

angular
.module('mepedia.services')
.factory('eventTracker', EventTracker);
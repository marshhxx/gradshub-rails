ImagePicker = (Cloudinary, $httpProvider) ->
  {
  restrict: 'E',
  scope:{
    updateUser: '=',
    user: '=',
  },
  templateUrl: 'angular-app/templates/directives/image-picker.html',
  link: ($scope, $element) ->
    $scope.coverPhotoButtons = false
    $scope.temporaryCoverPhoto = true
    $scope.coverPhoto = false
    $scope.coverImageSelectorVisible = true
    $scope.coverLoaded = false
    $scope.spinnerVisible = false
    $scope.defaultCoverImageVisible = false
    $scope.cloudinaryCoverPhotoData = false
    initUser = false

    cloudinaryData = ""


    Cloudinary.config();

    #This method will be called whet the 'objectToInject' value is changes
    $scope.$watch "user", (value) ->
        #Checking if the given value is not undefined
        if value
          if !initUser
            initUser = true
            $scope.user = value
              #Do something
            $scope.coverPhotoURI = $scope.user.cover_image
            if $scope.coverPhotoURI
              #show:
              $scope.coverPhoto = true
              $scope.coverImageSelectorVisible = true
              $scope.defaultCoverImageVisible = true
              #hide:
              $scope.spinnerVisible = false
              $scope.temporaryCoverPhoto = false

    $scope.onFileSelectCover = ($files) ->
      file = $files[0]
      #Get image before upload
      temp_img = angular.element('#temp_cover_photo')

      #when user select a photo HIDE the following elements:
      # - image selector button
      # - save and cancel buttons

      $scope.coverImageSelectorVisible = false
      $scope.coverPhotoButtons = false

      #SHOW spinner
      $scope.spinnerVisible = true

      #when the user did not save any photo
      #* - SHOW the default cover photo
      #* - HIDE the cover photo loaded
      #*/
      if !$scope.coverPhotoURI
        $scope.defaultCoverImageVisible = true
        $scope.coverLoaded = false


      #/* when the temporary photo DIV is hidden
      #            * - SHOW temporary photo DIV
      #            */
      if !$scope.temporaryCoverPhoto
        $scope.temporaryCoverPhoto = true
        angular.element('.spinner-container').css({'z-index': '10'})


      delete $httpProvider.defaults.headers.common['Authorization']
      Cloudinary.uploadImage(file).then((data) ->
        $scope.cloudinaryCoverPhotoData = data
        $scope.coverLoaded = true
        $scope.defaultCoverImageVisible = false
        $scope.coverPhoto = false
      ).catch((error)->
      )

    pictureCoverPhoto = angular.element('#temp_cover_photo')
    contentCoverPhoto = angular.element('.profile.wrapper')

    pictureCoverPhoto.on('load',()->
      #show:
      $scope.coverPhotoInProgress = true;
      $scope.temporaryCoverPhoto = true;

      if $scope.coverPhoto
        $scope.coverPhoto = false;
        angular.element('.spinner-container').css({'z-index': '0'})

      pictureCoverPhoto.guillotine({eventOnChange: 'guillotinechange', width: contentCoverPhoto[0].offsetWidth - 2, height: 365})
      pictureCoverPhoto.guillotine('fit')
      data = pictureCoverPhoto.guillotine('getData')

      for key in data
        $('#' + key).html(data[key])

      pictureCoverPhoto.on('guillotinechange', (ev, data, action) ->
        data.scale = parseFloat(data.scale.toFixed(4));
        for k in data
          $('#' + k).html(data[k])
      )

        #show:
      $scope.coverPhotoButtons = true
        #hide:
      $scope.coverImageSelectorVisible = false;
      $scope.spinnerVisible = false;
      $scope.$apply()
    )

    $scope.saveCoverPhoto = () ->
      imageData = pictureCoverPhoto.guillotine('getData');
      imageData.w = $scope.cloudinaryCoverPhotoData.width;
      imageData.h = $scope.cloudinaryCoverPhotoData.height;
      imageData.x = Math.round(imageData.x / imageData.scale);
      imageData.y = Math.round(imageData.y / imageData.scale);
      coverPhotoThumbernail = Cloudinary.getThumbnail(imageData, $scope.cloudinaryCoverPhotoData) #Get Cropped Thumbernail

      delete $httpProvider.defaults.headers.common['Authorization'];
      Cloudinary.deleteImage($scope.user.tag).then((data)->
        #Success
        data = data
      ).catch((error)->

      )

      # get Secure URI.
      $scope.coverPhotoURI = coverPhotoThumbernail[0].src
      $scope.user.cover_image = $scope.coverPhotoURI #update user reference
      $scope.user.tag = $scope.cloudinaryCoverPhotoData.public_id
      #Update user image url
      $scope.updateUser()
      #Cover photo is changing
      $scope.coverPhotoInProgress = false


    angular.element('.cover-photo-img').on('load', () ->
      # we need to reset the guillotine plugin in order to call again later
      pictureCoverPhoto.guillotine('remove')

      #show:
      $scope.coverPhoto = true
      $scope.coverImageSelectorVisible = true
      $scope.defaultCoverImageVisible = true

      #hide:
      $scope.spinnerVisible = false
      $scope.temporaryCoverPhoto = false

      #it's necessary to call $apply in order to bind variables with the DOM
      $scope.$apply()
    )

    $scope.cancelCoverPhoto = () ->
      # we need to reset the guillotine plugin in order to call again later
      pictureCoverPhoto.guillotine('remove')
      #show:
      $scope.coverImageSelectorVisible = true

      # hide:
      $scope.temporaryCoverPhoto = false
      $scope.spinnerVisible = false
      $scope.coverPhotoInProgress = false

      if !$scope.coverPhoto
        $scope.defaultCoverImageVisible = true
        $scope.coverPhoto = true









  }





angular
.module('mepedia.directives')
.directive('simpleimagepicker', ['Cloudinary', '$http', ImagePicker]);
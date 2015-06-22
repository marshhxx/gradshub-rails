ImagePicker = (Cloudinary, $httpProvider, $timeout, Utils) ->
  {
  scope:{
    updateImage: '=',
    imageUrl: '=',
    circular: '=',
    size: '=', #Size can be SMALL or NORMAL
  },
  templateUrl: 'angular-app/templates/directives/image-picker.html',
  link: ($scope, $element, attr) ->

    # flag that shows if user is seeing its profile.
    $scope.notMe = Utils.notMe()
    
    $scope.default = attr.default
    $scope.$watch(
      -> attr.default
      ,
      (value) -> $scope.default = value
    )
    $scope.uploadImageBtn = true
    $scope.defaultImage = true
    $scope.photoButtons = false # Photo save and cancel buttons
    initUser = false

    guillotinePhotoElement = $element.find('#guillotine-photo')
    imageWrapper = $element.find('.image-picker.wrapper')

    Cloudinary.config(); #init Cloudinary settings

    #This method will be called when 'User' variable value changes
    $scope.$watch "imageUrl", (value) ->
        if value #Checking if the given value is not undefined
          if !initUser
            initUser = true
            $scope.imageUrl = value #Updates user
            $scope.photoURL = $scope.imageUrl #Set photo url
            if $scope.photoURL
              $scope.photo = true
              $scope.defaultImage = false
              $scope.guillotinePhoto = false

    #Method to upload file. Called when user clicks button to upload Image.
    $scope.onFileSelect = ($files) ->
      file = $files[0]                    #When user select a photo we HIDE and SHOW the following elements:
      $scope.uploadImageBtn = false         # - image upload button
      $scope.spinnerVisible = true          # - photo save and cancel buttons

      #Call Cloudinary upload Image method to upload image to cloudinary server
      delete $httpProvider.defaults.headers.common['Authorization']
      Cloudinary.uploadImage(file).then((data) ->
        $scope.cloudinaryPhotoData = data
      ).catch((error)->
        console.log(error)
      )

    #On guillotine image load
    guillotinePhotoElement.on('load',()->
      $scope.photo = false;
      guillotinePhotoElement.guillotine({eventOnChange: 'guillotinechange', width: imageWrapper[0].offsetWidth, height: imageWrapper[0].offsetHeight})
      guillotinePhotoElement.guillotine('fit')
      data = guillotinePhotoElement.guillotine('getData')

      for key in data
        $('#' + key).html(data[key])

      guillotinePhotoElement.on('guillotinechange', (ev, data, action) ->
        data.scale = parseFloat(data.scale.toFixed(4));
        for k in data
          $('#' + k).html(data[k])
      )

      #Timeout to wait components to load
      $timeout (->
        $scope.photo = false
        $scope.defaultImage = false;
        $scope.guillotinePhoto = true;
        $scope.spinnerVisible = false;
        $scope.photoButtons = true
        $scope.$apply()
      ), 3000
    )

    deleteImage = (imageUrl)->
      #Delete previous uploaded image
      delete $httpProvider.defaults.headers.common['Authorization'];
      if imageUrl
        publicIdSplitArray = imageUrl.split('/')
        publicId = (publicIdSplitArray[publicIdSplitArray.length-1]).split('.')
        Cloudinary.deleteImage(publicId[0]).then((data)->
          #On success
          data = data
        ).catch((error)->
          console.log(error)
        )

    #On save photo button click
    $scope.savePhoto = () ->
      $scope.spinnerVisible = true;
      imageData = guillotinePhotoElement.guillotine('getData')
      imageData.w = $scope.cloudinaryPhotoData.width
      imageData.h = Math.round(imageData.h / imageData.scale)
      imageData.x = Math.round(imageData.x / imageData.scale)
      imageData.y = Math.round(imageData.y / imageData.scale)
      coverPhotoThumbernail = Cloudinary.getThumbnail(imageData, $scope.cloudinaryPhotoData) #Get Cropped Thumbernail

      #Delete uploaded Image
      deleteImage($scope.imageUrl)

      #Set photo url
      $scope.photoURL = coverPhotoThumbernail[0].src
      $scope.imageUrl = $scope.photoURL #update user reference

      #Update user image url
      $scope.updateImage($scope.imageUrl)
      $scope.photoButtons = false

      $timeout (->
        $scope.spinnerVisible = false; #Hide spinner
      ), 2000

    $element.find('#image-picker-img').on('load', () ->
      #Reset variables
      guillotinePhotoElement.guillotine('remove')  #Reset guillotine plugin
      $scope.photo = true
      $scope.uploadImageBtn = true
      $scope.guillotinePhoto = false
      $scope.$apply()  #Bind variables with the DOM
    )

    $scope.cancelPhoto = () ->
      #Reset variables
      guillotinePhotoElement.guillotine('remove') #Reset guillotine plugin
      $scope.uploadImageBtn = true
      $scope.guillotinePhoto = false
      $scope.photoButtons = false

      deleteImage($scope.cloudinaryPhotoData.secure_url);

      if !$scope.photo
        $scope.defaultImage = true
      $scope.photo = true
  }

angular
.module('mepedia.directives')
.directive('simpleimagepicker', ['Cloudinary', '$http', '$timeout', 'Utils', ImagePicker]);
SearchService = () ->
  service = {}

  #Fake search service, creates an array of fake users and returns
  service.search = (keyword) ->
    users = [
      {name: "mariana", lastname: "ardoino", cover_image: "https://res.cloudinary.com/mepediacobas/image/upload/c_crop,h_556,w_1620,x_0,y_400/iao39j8csxzlffxzpchr", profile_image: "https://res.cloudinary.com/mepediacobas/image/upload/c_crop,h_768,w_1024,x_156,y_0/cjenx3iucx9uq2xact9y", headline: "Mobile Developer", current_position: "Android Developer", company: "The Electric Factory", city: "Montevideo"}
      {name: "mariana", lastname: "ardoino", cover_image: "https://res.cloudinary.com/mepediacobas/image/upload/c_crop,h_556,w_1620,x_0,y_400/iao39j8csxzlffxzpchr", profile_image: "https://res.cloudinary.com/mepediacobas/image/upload/c_crop,h_768,w_1024,x_156,y_0/cjenx3iucx9uq2xact9y", headline: "Mobile Developer", current_position: "Android Developer", company: "The Electric Factory", city: "Montevideo"}
      {name: "mariana", lastname: "ardoino", cover_image: "https://res.cloudinary.com/mepediacobas/image/upload/c_crop,h_556,w_1620,x_0,y_400/iao39j8csxzlffxzpchr", profile_image: "https://res.cloudinary.com/mepediacobas/image/upload/c_crop,h_768,w_1024,x_156,y_0/cjenx3iucx9uq2xact9y", headline: "Mobile Developer", current_position: "Android Developer", company: "The Electric Factory", city: "Montevideo"}
      {name: "mariana", lastname: "ardoino", cover_image: "https://res.cloudinary.com/mepediacobas/image/upload/c_crop,h_556,w_1620,x_0,y_400/iao39j8csxzlffxzpchr", profile_image: "https://res.cloudinary.com/mepediacobas/image/upload/c_crop,h_768,w_1024,x_156,y_0/cjenx3iucx9uq2xact9y", headline: "Mobile Developer", current_position: "Android Developer", company: "The Electric Factory", city: "Montevideo"}
      {name: "mariana", lastname: "ardoino", cover_image: "https://res.cloudinary.com/mepediacobas/image/upload/c_crop,h_556,w_1620,x_0,y_400/iao39j8csxzlffxzpchr", profile_image: "https://res.cloudinary.com/mepediacobas/image/upload/c_crop,h_768,w_1024,x_156,y_0/cjenx3iucx9uq2xact9y", headline: "Mobile Developer", current_position: "Android Developer", company: "The Electric Factory", city: "Montevideo"}
      {name: "mariana", lastname: "ardoino", cover_image: "https://res.cloudinary.com/mepediacobas/image/upload/c_crop,h_556,w_1620,x_0,y_400/iao39j8csxzlffxzpchr", profile_image: "https://res.cloudinary.com/mepediacobas/image/upload/c_crop,h_768,w_1024,x_156,y_0/cjenx3iucx9uq2xact9y", headline: "Mobile Developer", current_position: "Android Developer", company: "The Electric Factory", city: "Montevideo"}
      {name: "mariana", lastname: "ardoino", cover_image: "https://res.cloudinary.com/mepediacobas/image/upload/c_crop,h_556,w_1620,x_0,y_400/iao39j8csxzlffxzpchr", profile_image: "https://res.cloudinary.com/mepediacobas/image/upload/c_crop,h_768,w_1024,x_156,y_0/cjenx3iucx9uq2xact9y", headline: "Mobile Developer", current_position: "Android Developer", company: "The Electric Factory", city: "Montevideo"}
      {name: "mariana", lastname: "ardoino", cover_image: "https://res.cloudinary.com/mepediacobas/image/upload/c_crop,h_556,w_1620,x_0,y_400/iao39j8csxzlffxzpchr", profile_image: "https://res.cloudinary.com/mepediacobas/image/upload/c_crop,h_768,w_1024,x_156,y_0/cjenx3iucx9uq2xact9y", headline: "Mobile Developer", current_position: "Android Developer", company: "The Electric Factory", city: "Montevideo"}
      {name: "mariana", lastname: "ardoino", cover_image: "https://res.cloudinary.com/mepediacobas/image/upload/c_crop,h_556,w_1620,x_0,y_400/iao39j8csxzlffxzpchr", profile_image: "https://res.cloudinary.com/mepediacobas/image/upload/c_crop,h_768,w_1024,x_156,y_0/cjenx3iucx9uq2xact9y", headline: "Mobile Developer", current_position: "Android Developer", company: "The Electric Factory", city: "Montevideo"}
      {name: "mariana", lastname: "ardoino", cover_image: "https://res.cloudinary.com/mepediacobas/image/upload/c_crop,h_556,w_1620,x_0,y_400/iao39j8csxzlffxzpchr", profile_image: "https://res.cloudinary.com/mepediacobas/image/upload/c_crop,h_768,w_1024,x_156,y_0/cjenx3iucx9uq2xact9y", headline: "Mobile Developer", current_position: "Android Developer", company: "The Electric Factory", city: "Montevideo"}
    ]
    return users;

  service

angular
.module('mepedia.services')
.factory("searchService", SearchService)
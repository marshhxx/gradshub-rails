SearchService = ($http) ->
  service = {}

  #Fake search service, creates an array of fake users and returns
  userTemp = {name: "mariana", lastname: "ardoino", cover_image: "https://res.cloudinary.com/mepediacobas/image/upload/c_crop,h_556,w_1620,x_0,y_400/iao39j8csxzlffxzpchr", profile_image: "https://res.cloudinary.com/mepediacobas/image/upload/c_crop,h_768,w_1024,x_156,y_0/cjenx3iucx9uq2xact9y", headline: "Mobile Developer", current_position: "Android Developer", company: "The Electric Factory", city: "Montevideo", gender: "female"}
  users = [
    {name: "mariana", lastname: "ardoino", cover_image: undefined , profile_image: "https://res.cloudinary.com/mepediacobas/image/upload/c_crop,h_768,w_1024,x_156,y_0/cjenx3iucx9uq2xact9y", headline: "Mobile Developer", current_position: "Android Developer", company: "The Electric Factory", city: "Montevideo", gender: "female"}
    {name: "mariana", lastname: "ardoino", cover_image: "https://res.cloudinary.com/mepediacobas/image/upload/c_crop,h_556,w_1620,x_0,y_400/iao39j8csxzlffxzpchr", profile_image: undefined , headline: "Mobile Developer", current_position: "Android Developer", company: "The Electric Factory", city: "Montevideo", gender: "male"}
    {name: "mariana", lastname: "ardoino", cover_image: "https://res.cloudinary.com/mepediacobas/image/upload/c_crop,h_556,w_1620,x_0,y_400/iao39j8csxzlffxzpchr", profile_image: "https://res.cloudinary.com/mepediacobas/image/upload/c_crop,h_768,w_1024,x_156,y_0/cjenx3iucx9uq2xact9y", headline: "Mobile Developer", current_position: "Android Developer", company: "The Electric Factory", city: "Montevideo", gender: "female"}
    {name: "mariana", lastname: "ardoino", cover_image: "https://res.cloudinary.com/mepediacobas/image/upload/c_crop,h_556,w_1620,x_0,y_400/iao39j8csxzlffxzpchr", profile_image: "https://res.cloudinary.com/mepediacobas/image/upload/c_crop,h_768,w_1024,x_156,y_0/cjenx3iucx9uq2xact9y", headline: "Mobile Developer", current_position: "Android Developer", company: "The Electric Factory", city: "Montevideo", gender: "not_known"}
    {name: "mariana", lastname: "ardoino", cover_image: "https://res.cloudinary.com/mepediacobas/image/upload/c_crop,h_556,w_1620,x_0,y_400/iao39j8csxzlffxzpchr", profile_image: undefined , headline: "Mobile Developer", current_position: "Android Developer", company: "The Electric Factory", city: "Montevideo", gender: "female"}
    {name: "mariana", lastname: "ardoino", cover_image: "https://res.cloudinary.com/mepediacobas/image/upload/c_crop,h_556,w_1620,x_0,y_400/iao39j8csxzlffxzpchr", profile_image: "https://res.cloudinary.com/mepediacobas/image/upload/c_crop,h_768,w_1024,x_156,y_0/cjenx3iucx9uq2xact9y", headline: "Mobile Developer", current_position: "Android Developer", company: "The Electric Factory", city: "Montevideo", gender: "male"}
    {name: "mariana", lastname: "ardoino", cover_image: "https://res.cloudinary.com/mepediacobas/image/upload/c_crop,h_556,w_1620,x_0,y_400/iao39j8csxzlffxzpchr", profile_image: "https://res.cloudinary.com/mepediacobas/image/upload/c_crop,h_768,w_1024,x_156,y_0/cjenx3iucx9uq2xact9y", headline: "Mobile Developer", current_position: "Android Developer", company: "The Electric Factory", city: "Montevideo", gender: "female"}
    {name: "mariana", lastname: "ardoino", cover_image: "https://res.cloudinary.com/mepediacobas/image/upload/c_crop,h_556,w_1620,x_0,y_400/iao39j8csxzlffxzpchr", profile_image: "https://res.cloudinary.com/mepediacobas/image/upload/c_crop,h_768,w_1024,x_156,y_0/cjenx3iucx9uq2xact9y", headline: "Mobile Developer", current_position: "Android Developer", company: "The Electric Factory", city: "Montevideo", gender: "not_known"}
  ]

  #Infinite scroll option, add 8 "temp" users when scroll reachs bottom
  service.search = (keyword) ->
    return $http.get('/api/search', {params: {q: keyword, max: 100}})
#    last = users[users.length - 1]
#    i = 1
#    while i <= 8
#      users.push userTemp
#      i++
#    return users;

  return service

angular
.module('mepedia.services')
.factory("searchService", SearchService)
window.App.Controllers.User = Backbone.Router.extend({
  routes: {
    "users/new": "newUser"
  }

  newUser: () ->
    call_colorbox("/users/new")


})

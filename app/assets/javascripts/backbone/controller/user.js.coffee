window.App.Controllers.User = Backbone.Router.extend({
  routes: {
    "users/new": "newUser"
  }

  newUser: () ->
    #TODO: colorbox
    call_colorbox("/users/new", "#")


})

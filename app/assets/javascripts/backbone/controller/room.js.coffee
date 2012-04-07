window.App.Controllers.Room = Backbone.Router.extend({
  routes: {
    "rooms/:id": "showRoom"
  }

  showRoom: (id) ->
    call_colorbox("/rooms/" + id)

})

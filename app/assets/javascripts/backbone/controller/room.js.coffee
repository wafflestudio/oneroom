window.App.Controllers.Room = Backbone.Router.extend({
  routes: {
    "rooms/:id": "showRoom"
  }

  showRoom: (id) ->
    #TODO: don't reload showInfo if infowindow exist
    window.room.showInfo(window.map, id)
    call_colorbox("/rooms/" + id, "#map")

})

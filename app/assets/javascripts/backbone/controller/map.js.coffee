window.App.Controllers.Map = Backbone.Router.extend({
  routes: {
    "map": "index",
    "map/:id": "showRegion"
    "map/room/:id": "showRoom"
  }

  index: ->
    window.nav.navigate("nav_map")

  showRegion: (id) ->
    window.map.moveTo(id)
    window.nav.navigate("nav_map")

  showRoom: (id) ->
    window.room.showInfo(window.map, id)
})

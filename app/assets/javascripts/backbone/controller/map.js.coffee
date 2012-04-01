window.App.Controllers.Map = Backbone.Router.extend({
  routes: {
    "map": "index",
    "map/:id": "show"
  }

  index: ->
    window.nav.navigate("nav_map")

  show: (id) ->
    window.map.moveTo(id)
})

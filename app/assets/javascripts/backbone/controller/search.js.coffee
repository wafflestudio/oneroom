window.App.Controllers.Search = Backbone.Router.extend({
  routes: {
    "search": "index",
  }

  index: ->
    window.nav.navigate("nav_search")
})

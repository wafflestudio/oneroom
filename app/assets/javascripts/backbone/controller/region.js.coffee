window.App.Controllers.Region = Backbone.Router.extend({
  routes: {
    "region": "index",
  }

  index: ->
    window.nav.navigate("nav_region")
})

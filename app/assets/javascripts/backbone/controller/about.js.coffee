window.App.Controllers.About = Backbone.Router.extend({
  routes: {
    "about": "index"
  }

  index: ->
    window.nav.navigate("nav_about")
})

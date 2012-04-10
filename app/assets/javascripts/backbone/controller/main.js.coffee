window.App.Controllers.Main = Backbone.Router.extend({
  routes: {
    "about": "about"
    "contact": "contact"
  }

  about: () ->
    call_colorbox("/main/about", "#")

  contact: () ->
    call_colorbox("/main/contact", "#")
})

window.App.Controllers.Search = Backbone.Router.extend({
  routes: {
    "search": "index",
    "search/:keyword": "search"
  }

  index: ->
    window.nav.navigate("nav_search")

  search: (keyword) ->
    window.search.searchBasic(keyword)
})

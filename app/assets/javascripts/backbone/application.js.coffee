window.App = {
  Views: {},
  Controllers: {},
  init: () ->
    new window.App.Controllers.Map()
    new window.App.Controllers.About()
    new window.App.Controllers.Search()
    new window.App.Controllers.Room()
    new window.App.Controllers.User()
    Backbone.history.start()
    return true
}

#init
$(document).ready ->
  window.App.init()

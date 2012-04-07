window.App = {
  Views: {},
  Controllers: {},
  init: () ->
    new window.App.Controllers.Main()
    new window.App.Controllers.Map()
    new window.App.Controllers.Region()
    new window.App.Controllers.Search()
    new window.App.Controllers.Room()
    Backbone.history.start()
    return true
}

#init
$(document).ready ->
  window.App.init()

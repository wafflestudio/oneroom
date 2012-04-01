window.App = {
  Views: {},
  Controllers: {},
  init: () ->
    new window.App.Controllers.Map()
    new window.App.Controllers.Region()
    new window.App.Controllers.Search()
    Backbone.history.start()
    return true
}

#init
$(document).ready ->
  window.App.init()

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
    marker = window.room.findPin(id)
    #TODO: get marker if do not exist
    #TODO: route url when infowindow closed
    infowindow = new google.maps.InfoWindow({
      content: "loading.."
    })
    infowindow.open(window.map.mapobj, marker)

    $.getJSON("rooms/" + id + "/info", (res) ->
      infowindow.setContent(res.html)
    )
})

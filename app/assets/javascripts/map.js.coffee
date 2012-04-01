# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

#class
class Map
  mapobj: null
  loc: null
  #= move to location
  moveTo: (loc_id) ->
    this.mapobj.panTo(this.loc[loc_id])
    window.nav.navigate("nav_map")

#variables
window.map = new Map

#init
$(document).ready ->
  #init locations
  window.map.loc = {
    default: new google.maps.LatLng(37.459300249665695, 126.95059418678284),
    nok: new google.maps.LatLng(37.47060916727359, 126.9401228427887),
    ent: new google.maps.LatLng(37.47883430817924, 126.95232152938843),
    nak: new google.maps.LatLng(37.47760825763003, 126.96056127548218)
  }

  #load google map
  map_options = {
    center: window.map.loc.nok,
    zoom: 18,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  }
  window.map.mapobj = new google.maps.Map(document.getElementById("map_canvas"), map_options)

  #bind link to region
  $("#region a").each ->
    $(this).click ->
      window.map.moveTo($(this).attr('id'))
      return false

  return true


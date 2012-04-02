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

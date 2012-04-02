# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

#class
class Nav
  #= move to accordion
  navigate: (nav_id) ->
    $("#" + nav_id).trigger('click')

#variables
window.nav = new Nav


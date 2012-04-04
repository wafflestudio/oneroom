#class
class Nav
  #= move to accordion
  navigate: (nav_id) ->
    $("#" + nav_id).trigger('click')

#variables
window.nav = new Nav


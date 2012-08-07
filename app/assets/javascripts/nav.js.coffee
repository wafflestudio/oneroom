#class
class Nav
  #= move to accordion
  navigate: (nav_id) ->
    $("#" + nav_id).trigger('click')

    if nav_id == "nav_map" and window.search.getResultStatus()
      window.search.showResult()
    else
      window.search.hideResult()

#variables
window.nav = new Nav


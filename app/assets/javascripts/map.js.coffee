#class
class Map
  mapobj: null
  loc: null

  #= move to location
  moveTo: (loc_id) ->
    this.mapobj.panTo(this.loc[loc_id])
    
#variables
window.map = new Map

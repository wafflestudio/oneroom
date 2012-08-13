#class
class Room
  rooms: null

  type: {
    rent: 1,
    lease: 2
  }

  #==== STATUS ====
  #= get status
  getStatus: () ->
    status = parseInt($("#status").html())
    if(status == 0)
      return false
    else
      return true

  #= set status
  setStatus: (status) ->
    $("#status").html(status)

  #==== ROOM ====
  #= get rooms on condition
  getRooms: (id, callback) ->
    self = this
    self.setStatus(0)
  
    url = "rooms"
    url += "?" + "id=" + id if id

    $.getJSON(url, (res) ->
      window.map.addPins(res.data)
      self.setStatus(1)
      callback() if callback
    )

  #= show room info
  showInfo: (id) ->
    self = this
    status = this.getStatus()

    if(status)
      marker = window.map.findPin(id)
      window.map.showInfoWindow(id, marker)
    else
      call_func = () ->
        marker = window.map.findPin(id)
        window.map.showInfoWindow(id, marker)
      self.getRooms(id, call_func)
 
  #= show photo on click
  showPhoto: (from, to) ->
    $(from).live('click', () ->
      thumb_url = $(this).attr('src')
      original_url = thumb_url.replace("/thumb_", "/")
      $(to).html("<img src='" + original_url + "' />")

      $(to + " img").load(() ->
        $.colorbox.resize()
      )
    )

  #==== EVAL ====
  getEvaluations: (room_id, options, callback) ->
    $.get("/rooms/" + room_id + "/evaluations?" + options, (res) ->
      $(".room_evals").html(res.html)

      callback() if callback
    )

  #= form toggle on selection
  toggleEvalFields: () ->
    self = this
    $("input.evaluation_type").live('click', () ->
      t = parseInt($(this).attr('value'))
      if t == self.type.rent
        $(".evaluation_type_fields").show()
      else if t == self.type.lease
        $(".evaluation_type_fields").hide()
    )
 
  #= evaluate evaluations
  evaluateEvaluation: (room_id, id, ev) ->
    data = {'evaluate': ev}
    $.post("/rooms/" + room_id + "/evaluations/" + id + "/evaluate", data, (res) ->
      $("#evaluation_" + res.data._id + "_agree_detail").html(res.data.agree.length)
      $("#evaluation_" + res.data._id + "_disagree_detail").html(res.data.disagree.length)
      if res == "success"
        flash_notice(res.msg)
      else
        flash_error(res.msg)
    )


#variables
window.room = new Room

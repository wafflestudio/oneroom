#class
class Search
  search_basic_div: ".search_basic"
  search_advanced_div: ".search_advanced"
  search_result_div: "#search_result"

  searched_room: ".searched_room"
  search_close: "#search_close"

  result_status: false

  #==== INIT
  #= init range slide
  initSlider: (div, min, max, init_min, init_max) ->
    $(div + "-min").val(init_min)
    $(div + "-max").val(init_max)
    $(div + "-value").html(init_min + "만원" + " ~ " + init_max + "만원" )
    $(div + "-slider").slider({
      range: true,
      min: min,
      max: max,
      values: [init_min, init_max],
      slide: ( event, ui ) ->
        $(div + "-min").val(ui.values[0])
        $(div + "-max").val(ui.values[1])
        $(div + "-value").html(ui.values[0] + "만원" + " ~ " + ui.values[1] + "만원" )
    })

  #= init search button
  initSearch: () ->
    self = this
    $(".search_keyword").live('keypress', (e) ->
      if e.keyCode == 13
        params = $(self.search_basic_div + " input").fieldSerialize()
        params = params + "&search[type]=1"

        window.location.href = "#search/" + params
    )
    $(".search_btn").live('click', () ->
      params = $(self.search_basic_div + " input").fieldSerialize()
      params = params + "&" + $(self.search_advanced_div + " input").fieldSerialize() + "&search[type]=2"

      window.location.href = "#search/" + params
    )

  #==== RESULT
  #= result status
  setResultStatus: (bool) ->
    this.result_status = bool

  getResultStatus: () ->
    return this.result_status

  showResult: () ->
    $(this.search_result_div).show()

  hideResult: () ->
    $(this.search_result_div).hide()

  #==== SEARCH
  #= search room with params
  search: (keyword) ->
    self = this
    $.get("/rooms/search?" + keyword, (res) ->
      if res.status == 'success'
        window.map.removePins()
        window.map.addPins(res.data)

        #result html
        $(self.search_result_div).html(res.html)
        $(self.searched_room).live('click', () ->
          id = $(this).attr('rel')
          window.map.focusPin(id)
          window.room.showInfo(id)
        )
        $(self.searched_room).mouseenter(() ->
            id = $(this).attr('rel')
            window.map.findPin(id).setAnimation(google.maps.Animation.BOUNCE)
          ).mouseleave(() ->
            id = $(this).attr('rel')
            window.map.findPin(id).setAnimation(null)
        )
        $(self.search_close).live('click', () ->
          self.setResultStatus(false)
          self.hideResult()
          window.map.removePins()
          window.room.getRooms()
        )

        self.setResultStatus(true)
        self.showResult()
      else
        flash_error(res.msg)
    )

  

#variables
window.search = new Search

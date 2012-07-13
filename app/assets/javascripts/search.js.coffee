#class
class Search
  initSlider: (div, value_div, min, max, init_min, init_max) ->
    $(value_div).val(init_min + "만원" + " ~ " + init_max + "만원" )
    $(div).slider({
      range: true,
      min: min,
      max: max,
      values: [init_min, init_max],
      slide: ( event, ui ) ->
        $(value_div).val(ui.values[0] + "만원" + " ~ " + ui.values[1] + "만원" )
    })

  searchBasic: (keyword) ->
    #do basic search
    self = this
    $.get("/search?name=" + keyword, (res) ->
      console.log(res)
    )

  searchAdvanced: () ->
    #do advanced search

#variables
window.search = new Search

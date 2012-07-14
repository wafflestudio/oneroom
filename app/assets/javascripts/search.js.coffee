#class
class Search
  search_basic_div: ".search_basic"
  search_advanced_div: ".search_advanced"

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

  initSearch: () ->
    self = this
    $(".search_btn").live('click', () ->
      type = $(this).attr("rel")
      params = $(self.search_basic_div + " input").fieldSerialize()

      if type == self.search_basic_div
        params = params + "&search[type]=1"
      else
        params = params + "&" + $(self.search_advanced_div + " input").fieldSerialize() + "&search[type]=2"

      window.location.href = "#search/" + params
    )

  search: (keyword) ->
    self = this
    $.get("/rooms/search?" + keyword, (res) ->
      console.log(res)
    )

#variables
window.search = new Search

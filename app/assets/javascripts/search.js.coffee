#=== jQuery-ui Slider ===
init_slider = (div, value_div, min, max, init_min, init_max) ->
  $(value_div).val(init_min + "만원" + " ~ " + init_max + "만원" )
  $(div).slider({
    range: true,
    min: min,
    max: max,
    values: [init_min, init_max],
    slide: ( event, ui ) ->
      $(value_div).val(ui.values[0] + "만원" + " ~ " + ui.values[1] + "만원" )
  })

$(document).ready ->
  #load slider
  init_slider("#rent_deposit-slider", "#rent_deposit-value", 0, 1200, 200, 500)
  init_slider("#rent_rent-slider", "#rent_rent-value", 0, 80, 30, 40)
  init_slider("#lease_deposit-slider", "#lease_deposit-value", 2000, 10000, 3000, 7000)
  


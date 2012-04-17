#functions
@call_colorbox = (url, callback_url) ->
  $.colorbox({
    href: url,
    transition: 'fade',
    onClosed: () ->
      if callback_url then window.location.href = callback_url
  })

@init_qtip = (div) ->
  $(div).each ->
    $(this).qtip({
      content: {
        text: 'loading...',
        ajax: {
          url: $(this).attr('rel'),
          type: 'GET',
          success: (data, status) ->
            this.set('content.text', data)
            return true
        },
        title: {
          text: $(this).attr('title'),
          button: true
        }
      },
      position: {
        at: 'bottom center', # Position the tooltip above the link
        my: 'top center',
        viewport: $(window), # Keep the tooltip on-screen at all times
        effect: false # Disable positioning animation
      },
      show: {
        event: 'click'
      },
      hide: {
        event: 'unfocus'
      },
      style: {
        classes: 'ui-tooltip-wiki ui-tooltip-light ui-tooltip-shadow'
      }
    })
    return false


#init
$(document).ready ->
  #Accodion
  $("#nav").liteAccordion({
    containerWidht: 960,
    containerHeight: 500,
    activateOn: 'click',
    firstSlide: 2,
    slideSpeed: 500,
    easing: 'easeInOutQuart'
  })

  #init locations
  window.map.loc = {
    default: new google.maps.LatLng(37.459300249665695, 126.95059418678284),
    nokdoo: new google.maps.LatLng(37.47060916727359, 126.9401228427887),
    entrance: new google.maps.LatLng(37.47883430817924, 126.95232152938843),
    nakseongdae: new google.maps.LatLng(37.47760825763003, 126.96056127548218)
  }

  #load google map
  map_options = {
    center: window.map.loc.nokdoo,
    zoom: 18,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  }
  window.map.mapobj = new google.maps.Map(document.getElementById("map_canvas"), map_options)
  window.map.infowindow = new google.maps.InfoWindow({
      content: "loading..",
      maxWidth: 200
  })
  google.maps.event.addListener(window.map.infowindow, 'closeclick', () ->
    window.location.href = "#map"
  )

  #load room pins
  window.map.addPins(window.room)

  #default qtip
  init_qtip(".tooltip")
###

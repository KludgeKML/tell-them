load_prefs = ->
  prefs = JSON.parse(localStorage.getItem("tellThemPrefs"))
  return if !prefs?
  $('#tell-them-box').removeClass('pinned')
  if prefs.pinned == 1
  	$('#tell-them-box').addClass('pinned')
  	$('#tell-them-box .controls .pin').text('Unpin')
  $('#tell-them-box').removeClass('grid')
  if prefs.grid == 1
    $('#tell-them-box').addClass('grid')
    $('#tell-them-box .controls .pin').text('No Grid')
  $('#tell-them-box').addClass(prefs.corner)
  $('#tell-them-box .controls .corners button').removeClass('current')
  $('#tell-them-box .controls .corners button[data-target-corner=' + prefs.corner +  ']').addClass('current')

save_prefs = ->
  pin_value = 0
  if $('#tell-them-box').hasClass('pinned')
  	pin_value = 1
  grid_value = 0
  if $('#tell-them-box').hasClass('grid')
    grid_value = 1
  prefs = {
  	corner: $('#tell-them-box .controls .corners button.current').data('target-corner'),
  	pinned: pin_value,
    grid: grid_value
  }
  localStorage.setItem("tellThemPrefs", JSON.stringify(prefs))

change_corners = (e) ->
  $('#tell-them-box').removeClass('top-left top-right bottom-left bottom-right')
  $('#tell-them-box .controls .corners button').removeClass('current')
  $(this).addClass('current')
  $('#tell-them-box').addClass($(this).data('target-corner'))
  save_prefs()

toggle_pin = (e) ->
  $('#tell-them-box').toggleClass('pinned')
  if $('#tell-them-box').hasClass('pinned')
  	$('#tell-them-box .controls .pin').text('Unpin')
  else
  	$('#tell-them-box .controls .pin').text('Pin')
  save_prefs()

toggle_grid = (e) ->
  $('#tell-them-box').toggleClass('grid')
  if $('#tell-them-box').hasClass('grid')
    $('#tell-them-box .controls .grid').text('No Grid')
  else
    $('#tell-them-box .controls .grid').text('Grid')
  save_prefs()  

$ ->
  load_prefs()
  $('#tell-them-box .controls .corners button').on 'click', change_corners
  $('#tell-them-box .controls .grid').on 'click', toggle_grid
  $('#tell-them-box .controls .pin').on 'click', toggle_pin  
  $('#tell-them-box .controls').css('display', 'block')

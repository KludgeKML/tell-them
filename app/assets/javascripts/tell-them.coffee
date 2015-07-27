load_prefs = ->
  prefs = JSON.parse(localStorage.getItem("tellThemPrefs"))
  return if !prefs?
  remove_class(find('#tell-them-box'), 'pinned')
  if prefs.pinned == 1
    add_class(find('#tell-them-box'), 'pinned')
    set_text(find('#tell-them-box .controls .pin'), 'Unpin')
  add_class(find('#tell-them-box'), prefs.corner)
  remove_class(find('#tell-them-box .controls .corners button'), 'current')
  add_class(find('#tell-them-box .controls .corners button[data-target-corner=' + prefs.corner +  ']'), 'current')

save_prefs = ->
  pin_value = 0
  if has_class(find('#tell-them-box'), 'pinned')
    pin_value = 1
  prefs = {
    corner: data(find('#tell-them-box .controls .corners button.current'), 'target-corner'),
    pinned: pin_value
  }
  localStorage.setItem("tellThemPrefs", JSON.stringify(prefs))

change_corners = (e) ->
  remove_class(find('#tell-them-box'), 'top-left')
  remove_class(find('#tell-them-box'), 'top-right')
  remove_class(find('#tell-them-box'), 'bottom-left')
  remove_class(find('#tell-them-box'), 'bottom-right')
  remove_class(find('#tell-them-box .controls .corners button'), 'current')
  add_class(this, 'current')
  add_class(find('#tell-them-box'), data(this, 'target-corner'))
  save_prefs()

toggle_pin = (e) ->
  toggle_class(find('#tell-them-box'), 'pinned')
  if has_class(find('#tell-them-box'), 'pinned')
    set_text(find('#tell-them-box .controls .pin'), 'Unpin')
  else
    set_text(find('#tell-them-box .controls .pin'), 'Pin')
  save_prefs()

add_class = (el, className) ->
  if el.classList
    el.classList.add(className)
  else
    el.className += ' ' + className

data = (el, key) ->
  el.getAttribute('data-' + key);

find = (selector) ->
  document.querySelectorAll(selector)

has_class = (el, className) ->
  if el.classList
    el.classList.contains(className)
  else
    new RegExp('(^| )' + className + '( |$)', 'gi').test(el.className)

remove_class = (el, className) ->
  if el.classList
    el.classList.remove(className)
  else
    el.className = el.className.replace(new RegExp('(^|\\b)' + className.split(' ').join('|') + '(\\b|$)', 'gi'), ' ')

toggle_class = (el, className) ->
  if el.classList
    el.classList.toggle(className)
  else
    classes = el.className.split(' ')
    existingIndex = classes.indexOf(className)
  if existingIndex >= 0
    classes.splice(existingIndex, 1)
  else
    classes.push(className)
  el.className = classes.join(' ')

->
  load_prefs()
  find('#tell-them-box .controls .corners button').addEventListener('click', change_corners)
  find('#tell-them-box .controls .pin').addEventListener('click', toggle_pin)
  find('#tell-them-box .controls').style.display = 'block'
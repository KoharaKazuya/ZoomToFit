document.addEventListener 'DOMContentLoaded', ->

  min = document.querySelector 'input[name="min_zoom_rate"]'
  max = document.querySelector 'input[name="max_zoom_rate"]'
  checkbox = document.querySelector 'input[type="checkbox"]'
  button = document.querySelector '.save-option'
  message = document.querySelector '.done-message'
  messageTimer = undefined

  # apply previous options
  chrome.storage.local.get
    minZoomRate: 80
    maxZoomRate: 150
    autozoom: false
  , (values) ->
    min.value = values.minZoomRate
    max.value = values.maxZoomRate
    checkbox.checked = values.autozoom

  # save
  button.addEventListener 'click', ->
    chrome.storage.local.set minZoomRate: min.value
    chrome.storage.local.set maxZoomRate: max.value
    chrome.storage.local.set autozoom: checkbox.checked
    message.classList.remove 'hidden'

    clearTimeout messageTimer if messageTimer?
    messageTimer = setTimeout ->
      message.classList.add('hidden')
    , 2000

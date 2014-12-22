document.addEventListener 'DOMContentLoaded', ->

  min = document.querySelector 'input[name="min_zoom_rate"]'
  max = document.querySelector 'input[name="max_zoom_rate"]'
  checkbox = document.querySelector 'input'

  # apply previous options
  chrome.storage.local.get
    minZoomRate: 80
    maxZoomRate: 150
    autozoom: false
  , (values) ->
    min.value = values.minZoomRate
    max.value = values.maxZoomRate
    checkbox.checked = values.autozoom

  # change event
  min.addEventListener 'change', ->
    chrome.storage.local.set minZoomRate: @.value
  max.addEventListener 'change', ->
    chrome.storage.local.set maxZoomRate: @.value
  checkbox.addEventListener 'change', ->
    autozoom = @.checked
    chrome.storage.local.set autozoom: autozoom

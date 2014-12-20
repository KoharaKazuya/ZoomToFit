document.addEventListener 'DOMContentLoaded', ->

  checkbox = document.querySelector 'input'

  # apply previous options
  chrome.storage.local.get { autozoom: false }, (values) ->
    checkbox.checked = values.autozoom

  # change event
  checkbox.addEventListener 'change', ->
    autozoom = @.checked
    chrome.storage.local.set autozoom: autozoom

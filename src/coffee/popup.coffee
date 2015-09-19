document.addEventListener 'DOMContentLoaded', ->
  chrome.tabs.query
    currentWindow: true
    active: true
  , (tabs) ->
    chrome.runtime.sendMessage
      command: 'ZOOM_TO_FIT'
      tab_id: tabs[0].id
  window.close()

document.addEventListener 'DOMContentLoaded', ->
  document.querySelector('.option_page_link').addEventListener 'click', (->
    chrome.tabs.create url: chrome.extension.getURL('options.html')
  ), false
  document.querySelector('.zoom_button').addEventListener 'click', ->
    chrome.tabs.query
      currentWindow: true
      active: true
    , (tabs) ->
      chrome.runtime.sendMessage
        command: 'ZOOM_TO_FIT'
        tab_id: tabs[0].id
    window.close()
  document.querySelector '.reset_button'
    .addEventListener 'click', ->
      chrome.tabs.query
        currentWindow: true
        active: true
      , (tabs) ->
        chrome.tabs.setZoom tabs[0].id, 1
      window.close()

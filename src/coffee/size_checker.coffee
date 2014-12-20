###
水平方向のスクロールが可能な状態か？
###
isEnabledToScrollHorizontally = (id) ->
  document.body.scrollLeft = 100000
  document.body.scrollLeft isnt 0

chrome.runtime.onMessage.addListener (request, sender, sendResponse) ->
  switch request.command
    when 'CAN_SCROLL_HORIZONTALLY'
      sendResponse enabled: isEnabledToScrollHorizontally()


# 自動ズーム可能なら
chrome.runtime.sendMessage command: 'ZOOM_TO_FIT'

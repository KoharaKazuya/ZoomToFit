###
水平方向のスクロールが可能な状態か？
###
isEnabledToScrollHorizontally = (id) ->
  prev = document.body.scrollLeft
  document.body.scrollLeft = 100000
  enabled = (document.body.scrollLeft isnt 0)
  document.body.scrollLeft = prev
  enabled

chrome.runtime.onMessage.addListener (request, sender, sendResponse) ->
  switch request.command
    when 'CAN_SCROLL_HORIZONTALLY'
      sendResponse enabled: isEnabledToScrollHorizontally()


# 自動ズーム可能なら
chrome.storage.local.get { autozoom: false }, (values) ->
  if values.autozoom
    chrome.runtime.sendMessage command: 'ZOOM_TO_FIT'

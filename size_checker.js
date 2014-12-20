/**
 * 水平方向のスクロールが可能な状態か？
 */
function isEnabledToScrollHorizontally(id) {
  document.body.scrollLeft = 100000;
  return document.body.scrollLeft != 0;
}

chrome.runtime.onMessage.addListener(function(request, sender, sendResponse) {
  switch (request.command) {
    case "CAN_SCROLL_HORIZONTALLY":
      sendResponse({
        enabled: isEnabledToScrollHorizontally()
      });
      break;
  }
});

// 自動ズーム可能なら
chrome.runtime.sendMessage({
  command: "ZOOM_TO_FIT"
});

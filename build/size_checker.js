
/*
水平方向のスクロールが可能な状態か？
 */
var isEnabledToScrollHorizontally;

isEnabledToScrollHorizontally = function(id) {
  document.body.scrollLeft = 100000;
  return document.body.scrollLeft !== 0;
};

chrome.runtime.onMessage.addListener(function(request, sender, sendResponse) {
  switch (request.command) {
    case 'CAN_SCROLL_HORIZONTALLY':
      return sendResponse({
        enabled: isEnabledToScrollHorizontally()
      });
  }
});

chrome.runtime.sendMessage({
  command: 'ZOOM_TO_FIT'
});

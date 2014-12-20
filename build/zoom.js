
/*
横スクロールが発生しない範囲での最大限ズームの倍率を求める

@param id タブの ID
@param estimation 倍率の推定値
@param min 倍率の最小値
@param max 倍率の最大値
@param cb コールバック関数(最小倍率, 最大倍率)
 */
var binarySearchToFit, expandSearchToFit, option;

expandSearchToFit = function(id, estimation, min, max, cb) {
  var searchMax, searchMin;
  searchMax = function(smax, step, cb) {
    smax += step;
    if (max < smax) {
      cb(max);
    } else {
      chrome.tabs.setZoom(id, smax, function() {
        chrome.tabs.sendMessage(id, {
          command: "CAN_SCROLL_HORIZONTALLY"
        }, function(response) {
          if (response.enabled) {
            cb(smax);
          } else {
            searchMax(smax, step * 2, cb);
          }
        });
      });
    }
  };
  searchMin = function(smin, step, cb) {
    smin -= step;
    if (smin < min) {
      return cb(min);
    } else {
      return chrome.tabs.setZoom(id, smin, function() {
        return chrome.tabs.sendMessage(id, {
          command: "CAN_SCROLL_HORIZONTALLY"
        }, function(response) {
          if (response.enabled) {
            return searchMin(smin, step * 2, cb);
          } else {
            return cb(smin);
          }
        });
      });
    }
  };
  return searchMin(estimation, 0.01, function(smin) {
    return searchMax(estimation, 0.01, function(smax) {
      return cb(smin, smax);
    });
  });
};


/*
横スクロールが発生しない範囲での最大限ズームの倍率を求める

@param id タブの ID
@param min 倍率の最小値
@param max 倍率の最大値
@param cb コールバック関数(result)
 */

binarySearchToFit = function(id, min, max, cb) {
  var m;
  if (max - min < 0.01) {
    return cb(min);
  } else {
    m = (min + max) / 2;
    return chrome.tabs.setZoom(id, m, function() {
      return chrome.tabs.sendMessage(id, {
        command: "CAN_SCROLL_HORIZONTALLY"
      }, function(response) {
        if (response.enabled) {
          return binarySearchToFit(id, min, m, cb);
        } else {
          return binarySearchToFit(id, m, max, cb);
        }
      });
    });
  }
};

option = {
  zoom_min: 0.75,
  zoom_max: 1.5
};

chrome.runtime.onMessage.addListener(function(request, sender, sendResponse) {
  var id;
  switch (request.command) {
    case "ZOOM_TO_FIT":
      id = request.hasOwnProperty("tab_id") ? request.tab_id : sender.tab.id;
      return chrome.tabs.getZoom(id, function(zoom) {
        return expandSearchToFit(id, zoom, option.zoom_min - 0.05, option.zoom_max + 0.05, function(smin, smax) {
          return binarySearchToFit(id, smin, smax, function(result) {
            if (result < option.zoom_min) {
              result = option.zoom_min;
            }
            if (result > option.zoom_max) {
              result = option.zoom_max;
            }
            return chrome.tabs.setZoom(id, result);
          });
        });
      });
  }
});

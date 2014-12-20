document.addEventListener("DOMContentLoaded", function() {
  document.querySelector(".checkbox_for_blacklist").addEventListener("change", (function(e) {
    if (e.target.checked) {
      return console.log("add");
    } else {
      return console.log("remove");
    }
  }), false);
  document.querySelector(".option_page_link").addEventListener("click", (function() {
    return chrome.tabs.create({
      url: chrome.extension.getURL("options.html")
    });
  }), false);
  return document.querySelector(".zoom_button").addEventListener("click", function() {
    return chrome.tabs.query({
      currentWindow: true,
      active: true
    }, function(tabs) {
      return chrome.runtime.sendMessage({
        command: "ZOOM_TO_FIT",
        tab_id: tabs[0].id
      });
    });
  });
});

document.addEventListener("DOMContentLoaded", function() {

  document.querySelector(".checkbox_for_blacklist").addEventListener("change", function(e) {
    if (e.target.checked) {
      console.log("add");
    } else {
      console.log("remove");
    }
  }, false);

  document.querySelector(".option_page_link").addEventListener("click", function() {
    chrome.tabs.create({
      url: chrome.extension.getURL("options.html")
    });
  }, false);

  document.querySelector(".zoom_button").addEventListener("click", function() {
    chrome.tabs.query({ currentWindow: true, active: true }, function(tabs) {
      chrome.runtime.sendMessage({
        command: "ZOOM_TO_FIT",
        tab_id: tabs[0].id
      });
    });
  });

});

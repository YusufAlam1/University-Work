/** 
Author: Yusuf Alam 400568561
Date: March 29th
Description: Just a small piece of js to see if the email is the proper format
                an upgraded version of the function used in labe 9.1 chap 32
                but a downgraded version of a regex
*/

document.addEventListener("DOMContentLoaded", () => {
  document
    .getElementById("playerForm")
    .addEventListener("submit", function (event) {
      const email = document.getElementById("email").value;
      const errorMsg = document.getElementById("error-message");
      if (!email.includes("@") || !email.split("@")[1].includes(".")) {
        // the magic
        errorMsg.textContent =
          "Please enter a valid email address (example: user@domain.com)";
        event.preventDefault();
      } else {
        errorMsg.textContent = "";
      }
    });
});

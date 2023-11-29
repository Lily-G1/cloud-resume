// var counterContainer = document.querySelector(".website-counter");
// var visitCount = localStorage.getItem("page_view");

// if (visitCount) {
//   visitCount = Number(visitCount) + 1;
//   localStorage.setItem("page_view", visitCount);
// } else {
//   visitCount = 1;
//   localStorage.setItem("page_view", 1);
// };

// counterContainer.innerHTML = visitCount;

var counterContainer = document.querySelector(".website-counter");
async function updateCounter() {
  let response = await fetch("https://jbdmig890f.execute-api.us-east-1.amazonaws.com/dev/crc");
  let data = await response.json();
  counterContainer.innerHTML = `${data}`;
}

updateCounter();
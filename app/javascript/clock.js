const clock = document.getElementById("clock");
let seconds = 0;

function updateClock() {
  seconds++;
  clock.textContent = `${seconds}`;
}

setInterval(updateClock, 1000);
console.log("hello from clock");

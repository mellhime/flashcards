var seconds=0;
setInterval(timer, 1000);

function timer() {
  seconds += 1;
  document.getElementById('seconds').value = seconds;
}

function onClickFunc() {
    setTimeout(function(){
        seconds = 0;
    }, 100);
 }

var seconds=0;
setInterval(timer, 1000);

function timer() {
  seconds += 1;
  document.getElementById('seconds').value = seconds;
}

$('#check-form').submit(function(e) {
    e.preventDefault();
    this.submit();

    setTimeout(function(){
        seconds = 0;
    }, 100);
});

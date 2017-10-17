  function func1(returnValue) {
    document.getElementById('score').value = returnValue;
  }

  setTimeout(func1(5), 5000);
  setTimeout(func1(4), 10000);
  setTimeout(func1(3), 60000);

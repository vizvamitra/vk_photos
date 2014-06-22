var show_pricessing = function(){
  var opts = {
    lines: 8, // The number of lines to draw
    length: 6, // The length of each line
    width: 4, // The line thickness
    radius: 5, // The radius of the inner circle
    corners: 1, // Corner roundness (0..1)
    rotate: 0, // The rotation offset
    direction: 1, // 1: clockwise, -1: counterclockwise
    color: 'rgb(96, 115, 135)', // #rgb or #rrggbb or array of colors
    speed: 1.2, // Rounds per second
    trail: 60, // Afterglow percentage
    shadow: false, // Whether to render a shadow
    hwaccel: false, // Whether to use hardware acceleration
    className: 'spinner', // The CSS class to assign to the spinner
    zIndex: 2e9, // The z-index (defaults to 2000000000)
    top: '50%', // Top position relative to parent
    left: '50%' // Left position relative to parent
  };

  var target = document.getElementById('spinner_container');
  new Spinner(opts).spin(target);
  document.getElementById('processing').style.display = 'block';
}

var button = document.getElementById('begin')
var href = button.href;
button.addEventListener("click", function(event){
  event.preventDefault();
  show_pricessing();
  location.href = href
})
// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).on('turbolinks:load', function() {

// Turn RGB Values to Hex
function rgb2hex(rgb){
 rgb = rgb.match(/^rgba?[\s+]?\([\s+]?(\d+)[\s+]?,[\s+]?(\d+)[\s+]?,[\s+]?(\d+)[\s+]?/i);
 return (rgb && rgb.length === 4) ? "#" +
  ("0" + parseInt(rgb[1],10).toString(16)).slice(-2) +
  ("0" + parseInt(rgb[2],10).toString(16)).slice(-2) +
  ("0" + parseInt(rgb[3],10).toString(16)).slice(-2) : '';
}

// Turn the carot when the div expands
  $('.label-title > a').click(function(){
    $(this).children('.fa-caret-right').toggleClass('open');
  });



// Set initial color codes on load
  var firstColor = $('.label-single-color').first();
  var cssColor = $(firstColor).css('background-color');
  var hexColor = rgb2hex(cssColor);
    var colorHTML = "<div class='swatch' style='background-color:" + cssColor + "'></div><p>/* Hex */ color: " + hexColor + ";</p><p>/* RGB */ color: " + cssColor + "<p></p><p>/* Hex */ background-color: " + hexColor + ";</p><p>/* RGB */ background-color: " + cssColor + ";</p>";
  $('.css-colors-code').html(colorHTML);


//Change the color code in the box when you click the color.
  $('.label-single-color').click(function() {
    var cssColor = $(this).css('background-color');
    var hexColor = rgb2hex(cssColor);
    var colorHTML = "<div class='swatch' style='background-color:" + cssColor + "'></div><p>/* Hex */ color: " + hexColor + ";</p><p>/* RGB */ color: " + cssColor + "<p></p><p>/* Hex */ background-color: " + hexColor + ";</p><p>/* RGB */ background-color: " + cssColor + ";</p>";
    $('.css-colors-code').html(colorHTML);
  });


// Change the header title on hover
  $('.label-single-color').hover(function() {
    var cssColor = $(this).css('background-color');
    $('#site-title > a').css('color', cssColor);
  });

});


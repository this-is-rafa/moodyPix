// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).on('turbolinks:load', function() {
  
  var firstColor = $('.label-single-color').first();
  var cssColor = $(firstColor).css('background-color');
  var colorHTML = "<div class='swatch' style='background-color:" + cssColor + "'></div><p>color: " + cssColor + ";</p><p>background-color: " + cssColor + ";</p>";
  $('.css-colors-code').html(colorHTML);



  $('.label-title > a').click(function(){
    $(this).children('.fa-caret-right').toggleClass('open');
  });



  //Show the color code in the box when you click the color.
  $('.label-single-color').click(function() {
    var cssColor = $(this).css('background-color');
    var colorHTML = "<div class='swatch' style='background-color:" + cssColor + "'></div><p>color: " + cssColor + ";</p><p>background-color: " + cssColor + ";</p>";
    $('.css-colors-code').html(colorHTML);
  });

  //   $('.label-single-color').hover(function() {
  //   var cssColor = $(this).css('background-color');
  //   var colorHTML = "<div class='swatch' style='background-color:" + cssColor + "'></div><p>color: " + cssColor + ";</p><p>background-color: " + cssColor + ";</p>";
  //   $('.css-colors-code').html(colorHTML);
  // });
  
  $('.label-single-color').hover(function() {
    var cssColor = $(this).css('background-color');
    $('#site-title > a').css('color', cssColor);
  });


});
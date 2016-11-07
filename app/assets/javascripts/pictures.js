// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).on('turbolinks:load', function() {
  
  $('.label-single-color').first(function() {
    var cssColor = $(this).css('background-color');
    var colorHTML = "<p>color: " + cssColor + ";</p><p>background-color: " + cssColor + ";</p>";
    $('.css-colors-code').html(colorHTML);
  });
  //expand the image labels
  // $('.img-labels').click(function (){
  //   $(this).toggleClass('label-expand');
  // });

  //Show the color code in the box when you click the color.
  $('.label-single-color').click(function() {
    var cssColor = $(this).css('background-color');
    var colorHTML = "<p>color: " + cssColor + ";</p><p>background-color: " + cssColor + ";</p>";
    $('.css-colors-code').html(colorHTML);
  });

  
});
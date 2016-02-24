$(document).on('page:load', function() {
  $('select').material_select();
  $(".button-collapse").sideNav();
});
$(document).on('page:change', function() {
  $('select').material_select();
  $(".button-collapse").sideNav();
});

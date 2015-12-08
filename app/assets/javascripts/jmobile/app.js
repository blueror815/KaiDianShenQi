$("document").ready(function(){

  $('#js-mobile-form').submit(function() {
      var $input = $('#js-phone');
      if (/^1[0-9]{10}$/.test($input.val())) {
        $('#js-mobile-submit').prop('disabled', true);
        return true;
      }
      $input.parent('.mdl-textfield').addClass('is-invalid');
      return false;
  });

});

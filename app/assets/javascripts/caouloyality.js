$(document).ready(function(){
  $("#promotion_expiry_date").datepicker({
    dateFormat: "yy-mm-dd",
    changeYear: true,
    changeMonth: true
  });

  $("#send-test").click(function(){
    message = $("#promotxt1").val() + "\n" + $("#promotxt2").val();
    mobile_no = $("#test_contact_no").val();

    if( message != "" && mobile_no != "" ){
      myObj = {message: message, mobile_no: mobile_no};
      var shallowEncoded = $.param( myObj, true );
      $.post("/promotions/test_sms", shallowEncoded, function(){
        alert("Sms sent successfully.");
      })
    }
    return false
  })
})

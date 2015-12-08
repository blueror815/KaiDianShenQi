$(document).ready(function(){
  $("#member-filter").on("change", function(){
    $.post("/w_members/listing", {tag: $("#member-filter").val()}, function(rows){
      $("members-listing").html(rows);
    })
  })
})

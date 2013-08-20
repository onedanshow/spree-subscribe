$(document).ready(function() {
  var regularPrice = $(".price").text();
  $(":radio").click(function(e) {
    var interval = e.currentTarget.value;
    if(interval == 1){
      $("#subscriptions_interval_id").removeAttr("disabled");

      $("select#subscriptions_interval_id").change(function(e) {
        var price = "";
        $("select#subscriptions_interval_id option:selected").each(function(){
          price = "$" + $(this).attr("data-subscribed-price");
        });
        $(".price").text(price);
      })
      .change();
    }else{
      $("#subscriptions_interval_id").attr("disabled","disabled"); 
      $(".price").text(regularPrice);
    }
  });

})

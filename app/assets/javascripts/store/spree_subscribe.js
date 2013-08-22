$(document).ready(function() {
  var regularPrice = $('#product-price .price').text();

  var assignPrice = function(price){
    $('#product-price .price').text(price);
  };

  $('#subscriptions_interval_id').on('change', function(e) { 
    price = '$' + $(e.target).find('option:selected').data('subscribed-price');
    assignPrice(price);
  });

  $(':radio').click(function(e) {
    var oneTime = (e.currentTarget.value == 0);

    $('#subscriptions_interval_id').attr("disabled", oneTime);

    price = oneTime ? regularPrice : '$' + $('#subscriptions_interval_id option:selected').data('subscribed-price');

    assignPrice(price);
  });
})

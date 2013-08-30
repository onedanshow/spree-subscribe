Number.prototype.toMoney = function(decimals, decimal_sep, thousands_sep){
  var n = this,
  c = isNaN(decimals) ? 2 : Math.abs(decimals),
  d = decimal_sep || '.',
  t = (typeof thousands_sep === 'undefined') ? ',' : thousands_sep,
  sign = (n < 0) ? '-' : '',
  i = parseInt(n = Math.abs(n).toFixed(c)) + '',
  j = ((j = i.length) > 3) ? j % 3 : 0;
  return sign + (j ? i.substr(0, j) + t : '') + i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + t) + (c ? d + Math.abs(n - i).toFixed(c).slice(2) : '');
}

$(document).ready(function() {
  var regularPrice = $('#product-price .price').text();

  var assignPrice = function(price){
    $('#product-price .price').text(price.toMoney());
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

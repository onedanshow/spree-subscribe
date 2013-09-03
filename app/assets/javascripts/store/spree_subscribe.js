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


  var addToDropdown = function(data){
    $('#subscriptions_interval_id').append($('<option>',{
      value: data.id,
      text: data.name
    }));
    $('#subscriptions_active_1').prop('checked', true);
    $('#subscriptions_interval_id').attr("disabled", false);
    $('#subscriptions_interval_id > option[value=' + data.id + ' ]').prop('selected', true);
  }

  var removeSubscriptionForm = function(){
    $('#new_subscription_interval').remove();
  };

  var newSubscriptionButtons = function(){
   buttons = "<div><a href = '#' class='button icon-ok'>Crear</a> o " + 
       "<a href='#' class='button icon-remove'>Cancelar</a></div>";
   return buttons;
  };

  var cleanUpForm = function() {
    $('[data-hook="buttons"]').remove();
    $('#new_subscription_interval').append(newSubscriptionButtons());
    $('#subscription_interval_name_field').remove();
    addFunctionallity();
  };

  var regularPrice = $('#product-price .price').text();

  var assignPrice = function(price){
    $('#product-price .price').text(price.toMoney());
  };


  $(':radio').click(function(e) {
    var oneTime = (e.currentTarget.value == 0);

    $('#subscriptions_interval_id').attr("disabled", oneTime);

  });

  $('#client_new_subscription_interval_link').on('click', function(e){
    e.preventDefault();
    $.get('/admin/subscription_intervals/new', function(data) {
      $('#new_subscription_form').html(data);
      cleanUpForm();
    })
    });


  var addFunctionallity = function() {
    $('.icon-ok').on('click',function(e){
      e.preventDefault();
      $.post('/admin/subscription_intervals', {
        subscription_interval: {
          name: $('#subscription_interval_times').val() + ' ' + $('#subscription_interval_time_unit option:selected').text(),
          times: $('#subscription_interval_times').val(),
          time_unit: $('#subscription_interval_time_unit option:selected').val(),
          product_id: $('#product_id').val()
        }
      }).done(function(data) { 
        addToDropdown(data);
        removeSubscriptionForm();
      })
    });

    $('.icon-remove').on('click', function(e){
      e.preventDefault();
      removeSubscriptionForm();
    });
  }
})

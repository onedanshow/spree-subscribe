$(document).ready(function() {


  var addToDropdown = function(data){
    $('#subscriptions_interval_id').append($('<option>',{
      value: data.id,
      text: data.name
    }));
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
    $('#product-price .price').text(price);
  };

/*  $('#subscriptions_interval_id').on('change', function(e) { 
    price = $(e.target).find('option:selected').data('subscribed-price');
    assignPrice(price);
  });
*/

  $(':radio').click(function(e) {
    var oneTime = (e.currentTarget.value == 0);

    $('#subscriptions_interval_id').attr("disabled", oneTime);

//    price = oneTime ? regularPrice : $('#subscriptions_interval_id option:selected').data('subscribed-price');

//    assignPrice(price);
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

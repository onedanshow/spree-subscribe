$(document).ready(function() {

  $('.subscription-form').dialog({
    autoOpen: false,
    height: 250,
    width: 250,
    modal: true,
    buttons: {
      Crear: function(){
        new_interval = { subscription_interval: {} };
        times = $('#subscription_interval_times');
        unit = $('#subscription_interval_time_unit');

        new_interval.subscription_interval = {
          name: times.val() + ' ' + unit.text(),
          times: times.val(),
          time_unit: unit.val(),
          product_id: $('#product_id').val()
        };

        $.post('/client_subscription_intervals', new_interval)
          .done(function(data) {
            addToDropdown(data);
          });
        $(this).dialog('close');
      },
      Cancelar: function() {
        $(this).dialog('close');
      }
    },

    close: function() {
      $('#subscription_interval_times').val('');
    }
  });

  var addToDropdown = function(data){
    $('#subscriptions_interval_id').prepend($('<option>', {
      value: data.id,
      text: data.name
    }));
    $('#subscriptions_active_1').prop('checked', true);
    $('#subscriptions_interval_id').attr('disabled', false);
    $('#subscriptions_interval_id > option[value=' + data.id + ' ]')
      .prop('selected', true);
    $('#add-to-cart-button').attr('disabled', false);
  }

  $(':radio').click(function(e) {
    var oneTime = (e.currentTarget.value == 0);

    $('#subscriptions_interval_id').attr('disabled', oneTime);
    var popup = ($('#subscriptions_interval_id option').length == 1 && !oneTime);
    showPopup(popup);
  });

  var showPopup = function(popup) {
    $('#add-to-cart-button').attr('disabled', popup);
    if(popup) {
      $('.subscription-form').dialog('open');
    }
  };

  $('#subscriptions_interval_id').on('change', function(e){
    var popup = ($(e.target).find('option:selected').val() == -1);
    showPopup(popup);
  });
})

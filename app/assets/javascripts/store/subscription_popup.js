$(document).ready(function() {

  var isValid = function(field){
    return (field.val() > 0);
  }

  $('.subscription-form').dialog({
    autoOpen: false,
    height: 200,
    width: 250,
    modal: true,
    buttons: {
      Crear: function(){
        new_interval = { subscription_interval: {} };
        times = $('#subscription_interval_times');
        unit = $('#subscription_interval_time_unit option:selected');

        if(isValid(times)) {
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
        } else {
          times.addClass('field_with_error');
        }
      },
      Cancelar: function() {
        $(this).dialog('close');
      }
    },

    close: function() {
      $('#subscription_interval_times').val('');
      $('#subscription_interval_times').removeClass('field_with_error');
    }
  });

  var addToDropdown = function(data){
    attributes = { value: data.id, text: data.name }
    var interval = $('#subscriptions_interval_id')
    if(interval.find('option[value=' + attributes.value + ']').length == 0) {
      interval.prepend($('<option>', attributes));
    }
    interval
      .find('option[value=' + attributes.value + ' ]')
      .prop('selected', true);
    $('#add-to-cart-button').attr('disabled', false);
  }

  $(':radio').click(function(e) {
    var oneTime = (e.currentTarget.value == 0);

    $('#subscriptions_interval_id').attr('disabled', oneTime);
    var popup = (e.currentTarget.name == 'subscriptions[active]' && $('#subscriptions_interval_id option').length == 1 && !oneTime);
    showPopup(popup);
  });

  var showPopup = function(popup) {
    $('#add-to-cart-button').attr('disabled', popup);
    if(popup) {
      $('.subscription-form').dialog('open');
      $('.ui-dialog-titlebar').remove();
    }
  };

  $('#subscriptions_interval_id').on('change', function(e){
    var popup = ($(e.target).find('option:selected').val() == -1);
    showPopup(popup);
  });
})


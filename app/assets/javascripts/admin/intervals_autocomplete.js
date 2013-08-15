window.subscribeApp || (window.subscribeApp = {});

subscribeApp.Interval = (function() {
  function Interval() {}

  Interval.prototype.template = function(interval) {
    random = Math.floor(Math.random() * 1000 + 1);
    var element = '<div id=interval_product_' + interval.id + '><label>' + interval.name + '</label>' +
    '<input name="product[spree_subscription_interval_products_attributes][' + random + '][subscribed_price]" type="text">' +
    '<input name="product[spree_subscription_interval_products_attributes][' + random + '][subscription_interval_id]" type="hidden" value="' + interval.id + '">' +
    '<input name="product[spree_subscription_interval_products_attributes][' + random + '][_destroy]" type="checkbox"></div>'
    return element;
  };

  return Interval;

})();

function cleanIntervals(data) {
  var intervals = $.map(data['intervals'], function(result) {
    return result
  })
  return intervals;
}

$(document).ready(function() {
  $("#intervals").select2({
    placeholder: "",
    multiple: true,
    initSelection: function(element, callback) {
      url = Spree.url(Spree.routes.interval_search, { ids: element.val() })
      return $.getJSON(url, null, function(data) {
        return callback(self.cleanIntervals(data));
      })
    },
    ajax: {
      url: Spree.routes.interval_search,
      datatype: 'json',
      data: function(term, page) {
        return { q: term }
      },
      results: function (data, page) {
        return { results: self.cleanIntervals(data) }
      }
    },
    formatResult: function(interval) {
      return interval.name
    },
    formatSelection: function(interval, object, query) {
      exist = $('#'+ interval.name.replace(' ', '_')).length;
      if (!exist) {
        var intervalProduct = new subscribeApp.Interval()
        $('#interval_products').append(intervalProduct.template(interval));
      }
      return interval.name;
    }
  });

  $("#intervals").on('removed', function(e) {
    $("#" + e.choice.name.replace(' ', '_')).hide();
  });
})

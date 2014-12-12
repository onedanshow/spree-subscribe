function cleanIntervals(data) {
  var intervals = $.map(data['intervals'], function(result) {
    return result
  })
  return intervals;
}

$(document).ready(function() {
  if ($("#product_subscription_interval_ids").length > 0) {
    $("#product_subscription_interval_ids").select2({
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
      formatSelection: function(interval) {
        return interval.name
      }
    })
  }
})

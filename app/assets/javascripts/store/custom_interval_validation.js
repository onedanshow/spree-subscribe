window.subscribeApp || (window.subscribeApp = {});

subscribeApp.CustomInterval = (function(){
  function CustomInterval() {}

  CustomInterval.prototype.timeUnits;

  CustomInterval.prototype.intervalTimes;

  CustomInterval.prototype.setup = function() {
    this.timeUnits = $('#subscription_interval_time_unit');
    this.intervalTimes = $('#subscription_interval_times');
    this.validateMinimun();
  };

  CustomInterval.prototype.updateValues = function(min, val) {
    this.intervalTimes.attr('min', min)
                      .val(val);
  };

  CustomInterval.prototype.getValues = function(selected) {
    var min, value;
    switch(selected){
      case '1':
        min = 15;
        value = 15;
        break;
      case '2':
        min = 2;
        value = 2;
        break;
      default:
        min = 1;
        value = 1;
    };
    return [min, value];
  };

  CustomInterval.prototype.validateMinimun = function() {
    var _this_ = this;
    this.timeUnits.on('change', function(e) {
      var values = _this_.getValues($(e.target).val());
      _this_.updateValues(values[0], values[1]);
    });
  };

  return CustomInterval;
})();

import Toybox.Activity;
import Toybox.Lang;
import Toybox.Time;
import Toybox.WatchUi;

class CaloriesETAFieldView extends WatchUi.SimpleDataField {
  var target_calories = 0;
  var no_eta_string = null;
  var target_reached_string = null;

  // Set the label of the data field here.
  function initialize() {
    SimpleDataField.initialize();
    target_calories = Application.getApp().getProperty("targetCalories");
    label =
      WatchUi.loadResource(Rez.Strings.Label1) +
      target_calories.toNumber() +
      WatchUi.loadResource(Rez.Strings.Label2);

    no_eta_string = WatchUi.loadResource(Rez.Strings.no_eta_string);
    target_reached_string = WatchUi.loadResource(Rez.Strings.target_reached_string);
  }

  // The given info object contains all the current workout
  // information. Calculate a value and return it in this method.
  // Note that compute() and onUpdate() are asynchronous, and there is no
  // guarantee that compute() will be called before onUpdate().
  function compute(
    info as Activity.Info
  ) as Numeric or Duration or String or Null {
    if (info.calories == null || info.calories <= 0) {
      return no_eta_string;
    }
    if (info.energyExpenditure == null || info.energyExpenditure <= 0) {
      return no_eta_string;
    }

    var current_calories = info.calories;
    var remaining_cal = target_calories - current_calories;
    var cal_per_second = info.energyExpenditure / 60.0;
    var remaining_seconds = remaining_cal / cal_per_second;

    if (remaining_seconds <= 0) {
      return target_reached_string;
    }
    return new Time.Duration(remaining_seconds.toNumber());
  }
}

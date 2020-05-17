using Toybox.WatchUi;
using Toybox.Graphics;

class S2CView extends WatchUi.DataField {
  hidden var cadence;
  hidden var cadenceValue;

  function initialize() {
    DataField.initialize();
    cadence = new Cadence();
  }

  function onLayout(dc) {
    View.setLayout(Rez.Layouts.MainLayout(dc));
    var labelView = View.findDrawableById("label");
    labelView.locY = labelView.locY - 32;

    var valueView = View.findDrawableById("value");
    valueView.locX = valueView.locX + 37;
    valueView.locY = valueView.locY + 16;

    var unitView = View.findDrawableById("unit");
    unitView.locX = unitView.locX + 54;
    unitView.locY = unitView.locY - 10;

    View.findDrawableById("label").setText(Rez.Strings.label);
    View.findDrawableById("unit").setText("r\np\nm");

    return true;
  }

  function compute(info) {
    // See Activity.Info in the documentation for available information.
    if(info has :currentSpeed){
      if(info.currentSpeed != null){
        cadenceValue = cadence.add(info.currentSpeed).compute();
      } else {
        cadenceValue = 0.0f;
      }
    }
  }

  function onUpdate(dc) {
    // Set the background color
    View.findDrawableById("Background").setColor(getBackgroundColor());

    // Set the foreground color and value
    var value = View.findDrawableById("value");
    if (getBackgroundColor() == Graphics.COLOR_BLACK) {
      value.setColor(Graphics.COLOR_WHITE);
    } else {
      value.setColor(Graphics.COLOR_BLACK);
    }
    if (cadenceValue == 0) {
      value.setText("___");
    } else {
      value.setText(cadenceValue.format("%u"));
    }

    // Call parent's onUpdate(dc) to redraw the layout
    View.onUpdate(dc);
  }

  function reconfigure() {
    cadence = new Cadence();
  }
}

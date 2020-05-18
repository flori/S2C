using Toybox.WatchUi;
using Toybox.Graphics;

class S2CView extends WatchUi.DataField {
  hidden var cadence;
  hidden var cadenceValue;
  hidden var fitContributor;

  function initialize() {
    DataField.initialize();
    cadence = new Cadence();
    fitContributor = new CadenceFitContributor(self);
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
    if(info has :currentSpeed){
      if(info.currentSpeed != null){
        cadenceValue = cadence.add(info.currentSpeed).compute();
        fitContributor.compute(cadenceValue);
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

  function onTimerStart() {
    fitContributor.setTimerRunning( true );
  }

  function onTimerStop() {
    fitContributor.setTimerRunning( false );
  }

  function onTimerPause() {
    fitContributor.setTimerRunning( false );
  }

  function onTimerResume() {
    fitContributor.setTimerRunning( true );
  }

  function onTimerLap() {
    fitContributor.onTimerLap();
  }

  function onTimerReset() {
    fitContributor.onTimerReset();
  }
}

using Toybox.WatchUi;
using Toybox.Graphics;

class S2CView extends WatchUi.DataField {
  enum {
    CONFIG,
    CADENCE,
    SPEED,
  }

  hidden var cadenceSpeed;
  hidden var cadenceValue = 0;
  hidden var speedValue = 0;
  hidden var displayState = CONFIG;
  hidden var nextDisplayState = CADENCE;
  hidden var countDown = 10;
  hidden var fitContributor;
  hidden var labelView = null;
  hidden var valueView = null;
  hidden var unitView = null;

  function initialize() {
    DataField.initialize();
    cadenceSpeed = new CadenceSpeed();
    fitContributor = new CadenceFitContributor(self);
  }

  function onLayout(dc) {
    switch (displayState) {
      case CONFIG:
        drawConfigurePage(dc);
        System.println("Switched to configure layout " + countDown);
        break;
      case CADENCE:
        drawCadencePage(dc);
        System.println("Switched to cadence layout " + countDown);
        break;
      case SPEED:
        drawSpeedPage(dc);
        System.println("Switched to speed layout " + countDown);
        break;
      default:
        System.error(displayState.format("Invalid state %u encountered"));
    }
    configureDrawables();
    return true;
  }

  private function drawConfigurePage(dc) {
    var height = dc.getHeight();

    View.setLayout(Rez.Layouts.ConfigureLayout(dc));
    labelView = View.findDrawableById("label");
    if (height < 87) {
      labelView.locY = labelView.locY - 26;
    } else {
      labelView.locY = labelView.locY - 32;
    }

    valueView = View.findDrawableById("value");
    if (height < 87) {
      valueView.locY = valueView.locY + 4;
    } else {
      valueView.locY = valueView.locY + 16;
    }

    View.findDrawableById("label").setText("Ratio");
  }

  private function drawCadencePage(dc) {
    var height = dc.getHeight();
    if (height < 87) {
      View.setLayout(Rez.Layouts.SmallLayout(dc));
      labelView = View.findDrawableById("label");
      labelView.locY = labelView.locY - 26;

      valueView = View.findDrawableById("value");
      valueView.locX = valueView.locX + 37;
      valueView.locY = valueView.locY + 4;
    } else {
      View.setLayout(Rez.Layouts.MainLayout(dc));
      labelView = View.findDrawableById("label");
      labelView.locY = labelView.locY - 32;

      valueView = View.findDrawableById("value");
      valueView.locX = valueView.locX + 37;
      valueView.locY = valueView.locY + 16;

      unitView = View.findDrawableById("unit");
      unitView.locX = unitView.locX + 54;
      unitView.locY = unitView.locY - 10;
    }

    View.findDrawableById("label").setText("Cadence");
    View.findDrawableById("unit").setText("r\np\nm");
  }

  private function drawSpeedPage(dc) {
    var height = dc.getHeight();
    if (height < 87) {
      View.setLayout(Rez.Layouts.SmallLayout(dc));
      labelView = View.findDrawableById("label");
      labelView.locY = labelView.locY - 26;

      valueView = View.findDrawableById("value");
      valueView.locX = valueView.locX + 37;
      valueView.locY = valueView.locY + 4;
    } else {
      View.setLayout(Rez.Layouts.MainLayout(dc));
      labelView = View.findDrawableById("label");
      labelView.locY = labelView.locY - 32;

      valueView = View.findDrawableById("value");
      valueView.locX = valueView.locX + 37;
      valueView.locY = valueView.locY + 16;

      unitView = View.findDrawableById("unit");
      unitView.locX = unitView.locX + 54;
      unitView.locY = unitView.locY - 10;
    }

    View.findDrawableById("label").setText("Speed");
    View.findDrawableById("unit").setText("km\n–\nh");
  }

  function compute(info) {
    if (info has : currentSpeed) {
      if (info.currentSpeed != null) {
        cadenceSpeed.add(info.currentSpeed);
        cadenceValue = cadenceSpeed.cadenceRpm();
        fitContributor.compute(cadenceValue);
        speedValue = cadenceSpeed.speedKph();
      } else {
        cadenceValue = 0.0d;
        speedValue = 0.0d;
      }
      System.println("Compute: cadence = " + Math.round(cadenceValue) +
                     ", speed = " + Math.round(speedValue));
    }
  }

  private function setColorOnDrawable(drawable) {
    if (drawable == null) {
      return;
    }
    if (getBackgroundColor() == Graphics.COLOR_BLACK) {
      drawable.setColor(Graphics.COLOR_WHITE);
    } else {
      drawable.setColor(Graphics.COLOR_BLACK);
    }
  }

  private function configureDrawables() {
    // Set the background color
    View.findDrawableById("Background").setColor(getBackgroundColor());

    // Set the foreground color on views
    setColorOnDrawable(labelView);
    setColorOnDrawable(valueView);
    setColorOnDrawable(unitView);
  }

  function onUpdate(dc) {
    var switchEnabled = Application.Properties.getValue("switch");
    var switchDuration = Application.Properties.getValue("switchDuration").toLong();
    if (countDown > 0) {
      countDown--;
    } else {
      if (nextDisplayState == CONFIG) {
        displayState = nextDisplayState;
        nextDisplayState = CADENCE;
        countDown = 10;
        onLayout(dc);
      } else if (switchEnabled) {
        displayState = nextDisplayState;
        nextDisplayState = displayState == CADENCE ? SPEED : CADENCE;
        countDown = switchDuration;
        onLayout(dc);
      } else {
        displayState = CADENCE;
        nextDisplayState = CADENCE;
        countDown = 3600;
        onLayout(dc);
      }
    }

    switch (displayState) {
      case CONFIG:
        valueView.setText(cadenceSpeed.chainringSize.format("%u") + ":" +
                          cadenceSpeed.cogSize.format("%u"));
        break;
      case CADENCE:
        if (cadenceValue == 0) {
          valueView.setText("___");
        } else {
          valueView.setText(cadenceValue.format("%u"));
        }
        break;
      case SPEED:
        if (speedValue == 0) {
          valueView.setText("___");
        } else {
          valueView.setText(speedValue.format("%u"));
        }
        break;
      default:
        System.error(displayState.format("Invalid state %u encountered"));
    }

    // Call parent's onUpdate(dc) to redraw the layout
    View.onUpdate(dc);
  }

  function reconfigure() {
    cadenceSpeed = new CadenceSpeed();
    nextDisplayState = CONFIG;
    countDown = 0;
  }

  function onTimerStart() { fitContributor.setTimerRunning(true); }

  function onTimerStop() { fitContributor.setTimerRunning(false); }

  function onTimerPause() { fitContributor.setTimerRunning(false); }

  function onTimerResume() { fitContributor.setTimerRunning(true); }

  function onTimerLap() { fitContributor.onTimerLap(); }

  function onTimerReset() { fitContributor.onTimerReset(); }
}

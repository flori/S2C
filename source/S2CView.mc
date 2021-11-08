using Toybox.WatchUi;
using Toybox.Graphics;

class S2CView extends WatchUi.DataField {
  hidden var cadence;
  hidden var cadenceValue = 0;
  hidden var showConfigurePage = false;
  hidden var configureCountDown = 0;
  hidden var fitContributor;
  hidden var labelView = null;
  hidden var valueView = null;
  hidden var unitView = null;

  function initialize() {
    DataField.initialize();
    cadence = new Cadence();
    fitContributor = new CadenceFitContributor(self);
  }

  function onLayout(dc) {
    if (showConfigurePage) {
      drawConfigurePage(dc);
    } else {
      drawCadencePage(dc);
    }
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

    View.findDrawableById("label").setText(Rez.Strings.label);
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

      View.findDrawableById("label").setText(Rez.Strings.label);
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

      View.findDrawableById("label").setText(Rez.Strings.label);
      View.findDrawableById("unit").setText("r\np\nm");
    }
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
    if (configureCountDown > 0 && !showConfigurePage) {
      System.println("Switching to configure page");
      showConfigurePage = true;
      drawConfigurePage(dc);
    } else {
      if (configureCountDown <= 0 && showConfigurePage) {
        System.println("Switching to cadence page");
        showConfigurePage = false;
        onLayout(dc);
      }
    }

    if (configureCountDown > 0) {
      configureCountDown--;
    }

    configureDrawables();

    if (showConfigurePage) {
      valueView.setText(
        cadence.chainringSize.format("%u") + ":" +
        cadence.cogSize.format("%u")
      );
    } else {
      if (cadenceValue == 0) {
        valueView.setText("___");
      } else {
        valueView.setText(cadenceValue.format("%u"));
      }
    }

    // Call parent's onUpdate(dc) to redraw the layout
    View.onUpdate(dc);
  }

  function reconfigure() {
    cadence = new Cadence();
    configureCountDown = 10;
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

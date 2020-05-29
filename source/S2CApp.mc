using Toybox.Application;

class S2CApp extends Application.AppBase {
  hidden var view;

  function initialize() {
    System.println("Starting version " + version());
    AppBase.initialize();
    view = new S2CView();
  }

  function version() {
    if (Application has :Properties) {
      return Application.Properties.getValue("version");
    } else {
      return "0.0.0";
    }
  }

  function getInitialView() {
    return [ view ];
  }

  function onSettingsChanged() {
    view.reconfigure();
  }
}

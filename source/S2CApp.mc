using Toybox.Application;

class S2CApp extends Application.AppBase {
  hidden var view;

  function initialize() {
    AppBase.initialize();
    view = new S2CView();
  }

  function getInitialView() {
    return [ view ];
  }

  function onSettingsChanged() {
    view.reconfigure();
  }
}

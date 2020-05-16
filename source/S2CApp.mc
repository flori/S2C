using Toybox.Application;

class S2CApp extends Application.AppBase {
  function initialize() {
    AppBase.initialize();
  }

  function onStart(state) {
  }

  function onStop(state) {
  }

  function getInitialView() {
    return [ new S2CView() ];
  }
}

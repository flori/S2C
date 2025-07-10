using Toybox.Application;

class S2CApp extends Application.AppBase {
  hidden var view; // Reference to the initial view of the application

  /* 
   * Initializes the S2CApp object by setting up the base application and creating the initial view.
   */
  function initialize() {
    AppBase.initialize(); // Initialize the base application functionality
    view = new S2CView(); // Create an instance of the initial view
  }

  /* 
   * Specifies the initial view to be displayed when the application starts.
   * @return An array containing the initial view
   */
  function getInitialView() { return [view]; } // Return the initial view as a single-element array

  /* 
   * Handles changes in application settings by reconfiguring the view.
   */
  function onSettingsChanged() { 
    view.reconfigure(); // Reconfigure the view when settings are updated
  }
}

using Toybox.WatchUi;
using Toybox.Graphics;

class S2CView extends WatchUi.DataField {
  enum {
    CONFIG,      // Configuration display state
    CADENCE,     // Cadence display state
    SPEED        // Speed display state
  }

  hidden var cadenceSpeed;               // Reference to the CadenceSpeed object for tracking metrics
  hidden var cadenceValue = 0;           // Current cadence value in RPM
  hidden var speedValue = 0;             // Current speed value in km/h
  hidden var displayState = CONFIG;      // Current display state (CONFIG, CADENCE, or SPEED)
  hidden var nextDisplayState = CADENCE; // Next display state to switch to
  hidden var countDown = 10;             // Countdown timer for switching displays
  hidden var fitContributor;             // Reference to the Fit contributor object
  hidden var labelView = null;           // Pointer to the label view element
  hidden var valueView = null;           // Pointer to the value view element
  hidden var unitView = null;            // Pointer to the unit view element
  hidden var timerState = null;          // Current state of the timer

  /* 
   * Initializes the S2CView object by setting up initial values and creating necessary objects.
   */
  function initialize() {
    DataField.initialize(); // Initialize the base DataField functionality
    cadenceSpeed = new CadenceSpeed(); // Create an instance of CadenceSpeed for tracking metrics
    fitContributor = new CadenceFitContributor(self); // Create an instance of Fit contributor
  }

  /* 
   * Handles layout configuration based on the current display state.
   * @param dc The drawing context used to render the view
   */
  function onLayout(dc) {
    switch (displayState) {     // Switch based on the current display state
      case CONFIG:              // Configuration display state
        drawConfigurePage(dc);  // Draw the configuration page
        System.println("Switched to configure layout " + countDown);
        break;
      case CADENCE:             // Cadence display state
        drawCadencePage(dc);    // Draw the cadence page
        System.println("Switched to cadence layout " + countDown);
        break;
      case SPEED:               // Speed display state
        drawSpeedPage(dc);      // Draw the speed page
        System.println("Switched to speed layout " + countDown);
        break;
      default:
        System.error(displayState.format("Invalid state %u encountered"));
    }
    configureDrawables();       // Configure the view elements with appropriate colors
  }

  /* 
   * Draws the configuration page based on the device's screen height.
   * @param dc The drawing context used to render the view
   */
  private function drawConfigurePage(dc) {
    var height = dc.getHeight();

    View.setLayout(Rez.Layouts.ConfigureLayout(dc)); // Set the layout for configuration display
    labelView = View.findDrawableById("label");     // Find the label view element

    if (height < 87) {                             // Adjust positions based on screen height
      labelView.locY = labelView.locY - 26;
    } else {
      labelView.locY = labelView.locY - 32;
    }

    valueView = View.findDrawableById("value");     // Find the value view element

    if (height < 87) {
      valueView.locY = valueView.locY + 4;
    } else {
      valueView.locY = valueView.locY + 16;
    }

    (View.findDrawableById("label") as Toybox.WatchUi.Text).setText("Ratio"); // Set the label text
  }

  /* 
   * Draws the cadence page based on the device's screen height.
   * @param dc The drawing context used to render the view
   */
  private function drawCadencePage(dc) {
    var height = dc.getHeight();

    if (height < 87) {                             // Set layout for smaller screens
      View.setLayout(Rez.Layouts.SmallLayout(dc));
      labelView = View.findDrawableById("label");
      labelView.locY = labelView.locY - 26;

      valueView = View.findDrawableById("value");
      valueView.locX = valueView.locX + 37;
      valueView.locY = valueView.locY + 4;
    } else {                                       // Set layout for larger screens
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

    (View.findDrawableById("label") as Toybox.WatchUi.Text).setText("Cadence"); // Set the label text
    (View.findDrawableById("unit") as Toybox.WatchUi.Text).setText("r\np\nm");   // Set the unit text
  }

  /* 
   * Draws the speed page based on the device's screen height.
   * @param dc The drawing context used to render the view
   */
  private function drawSpeedPage(dc) {
    var height = dc.getHeight();

    if (height < 87) {                             // Set layout for smaller screens
      View.setLayout(Rez.Layouts.SmallLayout(dc));
      labelView = View.findDrawableById("label");
      labelView.locY = labelView.locY - 26;

      valueView = View.findDrawableById("value");
      valueView.locX = valueView.locX + 37;
      valueView.locY = valueView.locY + 4;
    } else {                                       // Set layout for larger screens
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

    (View.findDrawableById("label") as Toybox.WatchUi.Text).setText("Speed");   // Set the label text
    (View.findDrawableById("unit") as Toybox.WatchUi.Text).setText("km\n–\nh"); // Set the unit text
  }

  /* 
   * Computes and updates the cadence and speed values based on incoming data.
   * @param info The information containing current metrics
   */
  function compute(info) {
    if (info has :currentSpeed) {                  // Check if current speed is available
      if (info.currentSpeed != null) {             // Ensure the speed value is not null
        cadenceSpeed.add(info.currentSpeed);       // Add the speed to CadenceSpeed for tracking
        cadenceValue = cadenceSpeed.cadenceRpm();  // Calculate and store the current cadence
        fitContributor.compute(cadenceValue);      // Compute metrics for Fit contributor
        speedValue = cadenceSpeed.speedKph();      // Calculate and store the current speed
      } else {                                     // If no valid speed is available
        cadenceValue = 0.0d;                      // Reset cadence to 0
        speedValue = 0.0d;                        // Reset speed to 0
      }
      System.println("Compute: cadence = " + Math.round(cadenceValue) +
                     ", speed = " + Math.round(speedValue));
    }
    if (info has :timerState) {                    // Check if timer state is available
      timerState = info.timerState;               // Update the current timer state
    }
  }

  /* 
   * Sets the color of a drawable element based on the background color.
   * @param drawable The drawable element to set the color for
   */
  private function setColorOnDrawable(drawable) {
    if (drawable == null) {                       // Return if the drawable is not found
      return;
    }
    if (getBackgroundColor() == Graphics.COLOR_BLACK) { // Check if background is black
      drawable.setColor(Graphics.COLOR_WHITE);       // Set text color to white
    } else {                                       // If background is not black
      drawable.setColor(Graphics.COLOR_BLACK);      // Set text color to black
    }
  }

  /* 
   * Configures the colors of all view elements based on the current background color.
   */
  private function configureDrawables() {
    // Set the background color
    (View.findDrawableById("Background") as Toybox.WatchUi.Text).setColor(getBackgroundColor());

    // Set the foreground color on views
    setColorOnDrawable(labelView);                // Set label text color
    setColorOnDrawable(valueView);                // Set value text color
    setColorOnDrawable(unitView);                 // Set unit text color
  }

  /* 
   * Handles updates to the view, including switching between display states.
   * @param dc The drawing context used to render the view
   */
  function onUpdate(dc) {
    var switchEnabled = Application.Properties.getValue("switch"); // Get switch enabled status
    var switchDuration = Application.Properties.getValue("switchDuration").toLong(); // Get switch duration

    if (countDown > 0) {                         // Decrement countdown if not zero
      countDown--;
    } else {                                     // If countdown reaches zero
      if (nextDisplayState == CONFIG) {           // Switch to configuration state
        displayState = nextDisplayState;
        nextDisplayState = CADENCE;               // Set next state to cadence
        countDown = 10;                          // Reset countdown to 10
        onLayout(dc);                            // Redraw the layout
      } else if (switchEnabled) {                // If switch is enabled
        if (timerState != null && timerState == Activity.TIMER_STATE_ON) {
          displayState = nextDisplayState;        // Switch to next display state
          nextDisplayState = displayState == CADENCE ? SPEED : CADENCE; // Toggle between cadence and speed
          countDown = switchDuration;            // Set countdown based on switch duration
        } else {                                 // If timer is not running or invalid state
          displayState = CADENCE;                 // Reset to cadence display
          nextDisplayState = CADENCE;             // Keep next state as cadence
          countDown = switchDuration;            // Set countdown based on switch duration
        }
        onLayout(dc);                            // Redraw the layout
      } else {                                   // If switch is disabled
        displayState = CADENCE;                   // Reset to cadence display
        nextDisplayState = CADENCE;               // Keep next state as cadence
        countDown = 3600;                        // Set countdown to 3600 (long duration)
        onLayout(dc);                            // Redraw the layout
      }
    }

    switch (displayState) {                       // Update display based on current state
      case CONFIG:
        valueView.setText(cadenceSpeed.chainringSize.format("%u") + ":" +
                          cadenceSpeed.cogSize.format("%u"));
        break;
      case CADENCE:
        if (cadenceValue == 0) {
          valueView.setText("___");               // Display "___" if no cadence data
        } else {
          valueView.setText(cadenceValue.format("%u")); // Display current cadence
        }
        break;
      case SPEED:
        if (speedValue == 0) {
          valueView.setText("___");               // Display "___" if no speed data
        } else {
          valueView.setText(speedValue.format("%u"));   // Display current speed
        }
        break;
      default:
        System.error(displayState.format("Invalid state %u encountered"));
    }

    // Call parent's onUpdate(dc) to redraw the layout
    View.onUpdate(dc);
  }

  /* 
   * Reconfigures the view by resetting necessary variables and recreating objects.
   */
  function reconfigure() {
    cadenceSpeed = new CadenceSpeed();             // Recreate CadenceSpeed object
    nextDisplayState = CONFIG;                     // Reset next display state to configuration
    countDown = 0;                                // Reset countdown to zero
  }

  /* 
   * Handles the timer start event.
   */
  function onTimerStart() {
    fitContributor.setTimerRunning(true);         // Set Fit contributor's timer running status
  }

  /* 
   * Handles the timer stop event.
   */
  function onTimerStop() {
    fitContributor.setTimerRunning(false);        // Set Fit contributor's timer running status
  }

  /* 
   * Handles the timer pause event.
   */
  function onTimerPause() {
    fitContributor.setTimerRunning(false);        // Set Fit contributor's timer running status
  }

  /* 
   * Handles the timer resume event.
   */
  function onTimerResume() {
    fitContributor.setTimerRunning(true);         // Set Fit contributor's timer running status
  }

  /* 
   * Handles the timer lap event.
   */
  function onTimerLap() {
    fitContributor.onTimerLap();                  // Handle timer lap in Fit contributor
  }

  /* 
   * Handles the timer reset event.
   */
  function onTimerReset() {
    fitContributor.onTimerReset();                // Handle timer reset in Fit contributor
  }
}
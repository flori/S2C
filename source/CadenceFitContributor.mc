using Toybox.WatchUi;
using Toybox.System;
using Toybox.FitContributor;
using Toybox.Math;

class CadenceFitContributor {
  hidden var currentCadenceField;    // Holds the current cadence data field
  hidden var lapAvgCadenceField;     // Holds the average cadence per lap data field
  hidden var lapMaxCadenceField;     // Holds the maximum cadence per lap data field
  hidden var sessionAvgCadenceField; // Holds the average cadence for the session data field
  hidden var sessionMaxCadenceField; // Holds the maximum cadence for the session data field
  hidden var lapStats;               // Statistics tracker for lap data
  hidden var sessionStats;           // Statistics tracker for session data
  hidden var timerRunning;           // Indicates whether the timer is running

  /* 
   * Initializes the CadenceFitContributor object and sets up data fields for tracking cadence metrics.
   * @param dataField The data field used to store and update cadence values
   */
  function initialize(dataField) {
    currentCadenceField = dataField.createField(
      "cadence", 0, FitContributor.DATA_TYPE_UINT8,
      { 
        :nativeNum => 4,          // Native number for the current cadence field
        :mesgType  => FitContributor.MESG_TYPE_RECORD,// Message type for recording cadence data
        :units     => "rpm"       // Units of measurement (revolutions per minute)
      }
    );

    lapAvgCadenceField = dataField.createField(
      "avg_cadence", 1, FitContributor.DATA_TYPE_UINT8,
      { 
        :nativeNum => 17,         // Native number for the average cadence per lap field
        :mesgType  => FitContributor.MESG_TYPE_LAP,// Message type for lap data
        :units     => "rpm"       // Units of measurement
      }
    );

    lapMaxCadenceField = dataField.createField(
      "max_cadence", 2, FitContributor.DATA_TYPE_UINT8,
      { 
        :nativeNum => 18,         // Native number for the maximum cadence per lap field
        :mesgType  => FitContributor.MESG_TYPE_LAP,// Message type for lap data
        :units     => "rpm"       // Units of measurement
      }
    );

    sessionAvgCadenceField = dataField.createField(
      "avg_cadence", 3, FitContributor.DATA_TYPE_UINT8,
      { 
        :nativeNum => 18,         // Native number for the average cadence per session field
        :mesgType  => FitContributor.MESG_TYPE_SESSION,// Message type for session data
        :units     => "rpm"       // Units of measurement
      }
    );

    sessionMaxCadenceField = dataField.createField(
      "max_cadence", 4, FitContributor.DATA_TYPE_UINT8,
      { 
        :nativeNum => 19,         // Native number for the maximum cadence per session field
        :mesgType  => FitContributor.MESG_TYPE_SESSION,// Message type for session data
        :units     => "rpm"       // Units of measurement
      }
    );

    lapStats = new Stats();        // Initialize statistics tracker for laps
    sessionStats = new Stats();    // Initialize statistics tracker for sessions

    timerRunning = true;           // Set timer as running by default
    compute(0);                    // Initialize with zero cadence value
    timerRunning = false;          // Stop the timer after initialization
  }

  /* 
   * Computes and updates cadence metrics based on the current cadence value.
   * @param cadenceValue The current cadence value in RPM
   */
  function compute(cadenceValue) {
    if (!timerRunning) {           // Check if the timer is running
      return;                      // Exit if timer is not running
    }

    currentCadenceField.setData(Math.round(cadenceValue)); // Update current cadence value

    lapStats.add(cadenceValue);     // Add current cadence to lap statistics
    sessionStats.add(cadenceValue); // Add current cadence to session statistics

    lapAvgCadenceField.setData(Math.round(lapStats.average()));  // Update average cadence per lap
    lapMaxCadenceField.setData(Math.round(lapStats.maximum()));  // Update maximum cadence per lap

    sessionAvgCadenceField.setData(Math.round(sessionStats.average()));  // Update average cadence for session
    sessionMaxCadenceField.setData(Math.round(sessionStats.maximum()));  // Update maximum cadence for session

    System.println( // Log the updated metrics
      "Fit: cadence = " + Math.round(cadenceValue) +
        ", lapAvg = " + Math.round(lapStats.average()) +
        ", lapMax = " + Math.round(lapStats.maximum()) +
        ", sessionAvg = " + Math.round(sessionStats.average()) +
        ", sessionMax = " + Math.round(sessionStats.maximum()));
  }

  /* 
   * Sets the running status of the timer.
   * @param enabled Boolean indicating whether the timer should be running
   */
  function setTimerRunning(enabled) { 
    timerRunning = enabled; // Update the timer running status
  }

  /* 
   * Handles the timer reset event by resetting session statistics.
   */
  function onTimerReset() {
    System.println("timer reset"); // Log the reset event
    sessionStats.reset();          // Reset all session statistics to their initial values
  }

  /* 
   * Handles the timer lap event by resetting lap statistics.
   */
  function onTimerLap() {
    System.println("timer lap");  // Log the lap event
    lapStats.reset();             // Reset all lap statistics to their initial values
  }
}

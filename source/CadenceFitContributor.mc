using Toybox.WatchUi;
using Toybox.System;
using Toybox.FitContributor;
using Toybox.Math;

class CadenceFitContributor {
  hidden var currentCadenceField;
  hidden var lapAvgCadenceField;
  hidden var sessionAvgCadenceField;
  hidden var lapMaxCadenceField;
  hidden var sessionMaxCadenceField;
  hidden var lapStats;
  hidden var sessionStats;
  hidden var timerRunning;

  function initialize(dataField) {
    currentCadenceField = dataField.createField(
        "cadence", 0, FitContributor.DATA_TYPE_UINT8,
      {
      :nativeNum => 4,
      :mesgType  => FitContributor.MESG_TYPE_RECORD,
      :units     => "rpm"
      }
    );

    lapAvgCadenceField = dataField.createField(
      "lap_avg_cadence", 1, FitContributor.DATA_TYPE_UINT8,
      {
      :nativeNum => 17,
      :mesgType  => FitContributor.MESG_TYPE_LAP,
      :units     => "rpm"
      }
    );

    lapMaxCadenceField = dataField.createField(
      "lap_max_cadence", 2, FitContributor.DATA_TYPE_UINT8,
      {
      :nativeNum => 18,
      :mesgType  => FitContributor.MESG_TYPE_LAP,
      :units     => "rpm"
      }
    );

    sessionAvgCadenceField = dataField.createField(
      "session_avg_cadence", 3, FitContributor.DATA_TYPE_UINT8,
      {
      :nativeNum => 18,
      :mesgType  => FitContributor.MESG_TYPE_SESSION,
      :units     => "rpm"
      }
    );

    sessionMaxCadenceField = dataField.createField(
      "session_max_cadence", 4, FitContributor.DATA_TYPE_UINT8,
      {
      :nativeNum => 19,
      :mesgType  => FitContributor.MESG_TYPE_SESSION,
      :units     => "rpm"
      }
    );

    lapStats = new Stats();
    sessionStats = new Stats();

    timerRunning = true;
    compute(0); // initialize with zero
    timerRunning = false;
  }

  function compute(cadenceValue) {
    if (!timerRunning) {
      return;
    }

    currentCadenceField.setData(cadenceValue);

    lapStats.add(cadenceValue);
    sessionStats.add(Math.round(cadenceValue));

    lapAvgCadenceField.setData(Math.round(lapStats.average()));
    lapMaxCadenceField.setData(Math.round(lapStats.maximum()));

    sessionAvgCadenceField.setData(Math.round(sessionStats.average()));
    sessionMaxCadenceField.setData(Math.round(sessionStats.maximum()));

    System.println("Fit: cadence = " + Math.round(cadenceValue) +
        ", lapAvg = " + Math.round(lapStats.average()) +
        ", lapMax = " + Math.round(lapStats.maximum()) +
        ", sessionAvg = " + Math.round(sessionStats.average()) +
        ", sessionMax = " + Math.round(sessionStats.maximum())
        );
  }

  function setTimerRunning(enabled) {
    timerRunning = enabled;
  }

  function onTimerReset() {
    System.println("timer reset");
    sessionStats.reset();
  }

  function onTimerLap() {
    System.println("timer lap");
    lapStats.reset();
  }
}

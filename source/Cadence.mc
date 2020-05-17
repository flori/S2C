class Cadence {
  var speed; // m/s
  var wheelCircumference; // mm
  var chainringSize; // teeth
  var cogSize; // teeth

  function initialize() {
    speed = 0.0d;
    chainringSize = Application.Properties.getValue("chainringSize").toDouble();
    cogSize = Application.Properties.getValue("cogSize").toDouble();
    wheelCircumference = Application.Properties.getValue("wheelCircumference").toDouble();
    System.println("Configured cadence with chainring = " + chainringSize + ", cog = " + cogSize + ", wheel = " + wheelCircumference);
  }

  function add(currentSpeed) {
    speed = currentSpeed.toDouble();
    return self;
  }

  function speedKph() {
    return speed * 3.6d;
  }

  function cadenceRpm() {
    return ((speed * 1000 * 60) / wheelCircumference) * (cogSize / chainringSize);
  }

  function compute() {
    if (speed <= 0) {
      return 0.0;
    } else {
      var cadence = cadenceRpm();
      System.println("speed = " + speedKph() + ", cadence = " + cadence);
      return cadence;
    }
  }
}

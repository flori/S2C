class Cadence {
  var speed; // m/s
  const wheelCircumference = 2105; // mm
  const chainringSize = 48.0d; // teeth
  const cogSize = 16.0d; // teeth

  function initialize() {
    speed = 0.0d;
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

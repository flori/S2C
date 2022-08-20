class CadenceSpeed {
  hidden var speed;               // m/s
  hidden var wheelCircumference;  // mm
  var chainringSize;              // teeth
  var cogSize;                    // teeth

  function initialize() {
    speed = 0.0d;
    configure();
    System.println("Configured cadence with chainring = " + chainringSize +
                   ", cog = " + cogSize + ", wheel = " + wheelCircumference);
  }

  private function configure() {
    if (Application has : Properties) {
      chainringSize =
          Application.Properties.getValue("chainringSize").toDouble();
      cogSize = Application.Properties.getValue("cogSize").toDouble();
      wheelCircumference =
          Application.Properties.getValue("wheelCircumference").toDouble();
    } else {
      chainringSize = 48.0;
      cogSize = 17.0;
      wheelCircumference = 2105.0;
    }
  }

  function add(currentSpeed) {
    speed = currentSpeed.toDouble();
    return self;
  }

  function speedKph() { return speed <= 0 ? 0.0 : speed * 3.6d; }

  function cadenceRpm() {
    return speed <= 0 ? 0.0
                      : ((speed * 1000 * 60) / wheelCircumference) * (cogSize / chainringSize);
  }
}
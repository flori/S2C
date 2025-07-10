class CadenceSpeed {
  hidden var speed;               // m/s
  hidden var wheelCircumference;  // mm
  var chainringSize;              // teeth
  var cogSize;                    // teeth

  /* 
   * Initializes the CadenceSpeed object by setting initial values and configuring properties.
   */
  function initialize() {
    speed = 0.0d;               // Set initial speed to 0 meters per second
    configure();                // Configure the object using application properties or defaults
    System.println("Configured cadence with chainring = " + chainringSize +
                   ", cog = " + cogSize + ", wheel = " + wheelCircumference);
  }

  /* 
   * Configures the object using application properties if available, otherwise sets default values.
   */
  private function configure() {
    if (Application has : Properties) { // Check if application properties are available
      chainringSize =
          Application.Properties.getValue("chainringSize").toDouble(); // Set chainring size from property
      cogSize = Application.Properties.getValue("cogSize").toDouble(); // Set cog size from property
      wheelCircumference =
          Application.Properties.getValue("wheelCircumference").toDouble(); // Set wheel circumference from property
    } else { // If no properties are available, use default values
      chainringSize = 48.0;        // Default chainring size in teeth
      cogSize = 17.0;              // Default cog size in teeth
      wheelCircumference = 2105.0; // Default wheel circumference in millimeters
    }
  }

  /* 
   * Updates the current speed value.
   * @param currentSpeed The new speed value to set
   * @return self Allows method chaining
   */
  function add(currentSpeed) {
    speed = currentSpeed.toDouble(); // Set the speed value as a double
    return self;                     // Return the instance for method chaining
  }

  /* 
   * Converts the current speed from m/s to km/h.
   * @return The speed in kilometers per hour or 0 if speed is non-positive
   */
  function speedKph() { 
    return speed <= 0 ? 0.0 : speed * 3.6d; // Convert speed to km/h using the formula (m/s * 3.6)
  }

  /* 
   * Calculates the cadence in revolutions per minute (RPM) based on the current speed and gear ratios.
   * @return The cadence in RPM or 0 if speed is non-positive
   */
  function cadenceRpm() {
    return speed <= 0 ? 0.0 // Return 0 if speed is non-positive
                      : ((speed * 1000 * 60) / wheelCircumference) * (cogSize / chainringSize); 
    // Calculate RPM using the formula:
    // (speed in m/s * 1000 mm/m * 60 s/min) / wheel circumference in mm = rotations per minute
    // Multiply by cog size / chainring size to account for gear ratio
  }
}

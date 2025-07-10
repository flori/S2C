class Stats {
  hidden var total;    // Stores the cumulative sum of all added values
  hidden var max;      // Keeps track of the highest value encountered
  hidden var count;    // Counts the number of values that have been added

  /* 
   * Initializes the Stats object by resetting all variables to their starting values.
   */
  function initialize() { reset(); }

  /* 
   * Adds a new value to the statistics tracker.
   * @param value The value to be added (converted to double for precision)
   * @return self Allows method chaining
   */
  function add(value) {
    count++;          // Increment the count of values
    value = value.toDouble();  // Ensure the value is treated as a double
    if (value > max) {        // Check if this is the highest value encountered
      max = value;            // Update max if the new value is higher
    }
    total += value;          // Add the value to the cumulative total
    return self;             // Return the instance for method chaining
  }

  /* 
   * Calculates and returns the average of all added values.
   * @return The average value or 0 if no values have been added
   */
  function average() {
    if (count > 0) {         // Ensure there are values to avoid division by zero
      return total / count;  // Return the calculated average
    } else {
      return 0;              // Return 0 if no values have been added
    }
  }

  /* 
   * Returns the highest value that has been added so far.
   * @return The maximum value or 0 if no values have been added
   */
  function maximum() { 
    return max;             // Return the current maximum value
  }

  /* 
   * Resets all tracked statistics to their initial values (total, max, and count).
   */
  function reset() {
    total = 0.0d;          // Reset total to 0 as a double
    max = 0.0d;            // Reset max to 0 as a double
    count = 0;             // Reset count to 0
  }
}

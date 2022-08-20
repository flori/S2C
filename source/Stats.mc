class Stats {
  hidden var total;
  hidden var max;
  hidden var count;

  function initialize() { reset(); }

  function add(value) {
    count++;
    value = value.toDouble();
    if (value > max) {
      max = value;
    }
    total += value;
    return self;
  }

  function average() {
    if (count > 0) {
      return total / count;
    } else {
      return 0;
    }
  }

  function maximum() { return max; }

  function reset() {
    total = 0.0d;
    max = 0.0d;
    count = 0;
  }
}
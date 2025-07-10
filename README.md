# S2C (Speed2Cadence) - Track Cadence for Garmin Connect IQ based on Speed

## Overview

The **Speed2Cadence (S2C)** application is a Garmin Connect IQ solution
designed to calculate and display cadence data for fixed-gear bicycles. By
leveraging speed, gear ratio, and wheel circumference, this app derives cadence
without the need for additional sensors.

## Features

- **Cadence Calculation**: Computes cadence in RPM using speed, chainring size,
cog size, and wheel circumference.
- **FIT Data Contribution**: Syncs calculated cadence data with Garmin devices
for comprehensive tracking.
- **Dynamic UI**: Switches between displaying configuration settings, current
cadence, and speed based on user preferences or timer events.
- **Configuration Customization**: Allows users to set gear ratios and wheel
circumference via application properties.
- **Gear Ratio Display**: After configuration, the app briefly shows the
configured gear ratio for verification.

## Key Components

1. **`Stats.mc`**
   - Utility class for maintaining statistics (total, average, maximum) for
   both lap and session metrics.

2. **`CadenceFitContributor.mc`**
   - Manages FIT data fields for cadence tracking, including current cadence,
   lap averages/maxima, and session averages/maxima.
   - Integrates with the `Stats` class to update metrics in real-time.

3. **`CadenceSpeed.mc`**
   - Converts speed (m/s) to RPM using gear ratios and wheel circumference.
   - Handles configuration via application properties or defaults.

4. **`S2CBackground.mc`**
   - Provides a customizable background component for the watch UI.

5. **`S2CApp.mc`**
   - Initializes and manages the app’s view hierarchy, serving as the main
   entry point.

6. **`S2CView.mc`**
   - Main view class responsible for displaying metrics (cadence, speed) or
   configuration settings.
   - Implements state management to switch between different display modes
   dynamically.
   - Briefly displays the configured gear ratio after initial setup for user
   verification.

## Usage

1. **Installation**:
   - Install the app on your Garmin device via the Connect IQ Store or using
   the Garmin Developer Toolkit.

2. **Configuration**:
   - Set up application properties for gear ratios (chainring and cog size) and
   wheel circumference.
   - Adjust settings such as switch duration to control how frequently the
   display updates between metrics.
   - After configuration, the app will briefly show the configured gear ratio
   for verification.

3. **Operation**:
   - Once configured, the app will start calculating cadence based on your
   speed input.
   - The UI dynamically switches between displaying configuration, cadence, or
   speed based on predefined rules and user interactions.

## Development Setup

1. **Prerequisites**:
   - Garmin Developer Toolkit installed.
   - Basic understanding of Monkey C programming language and the Connect IQ
    platform.
2. **Building the Project**:
   - Open the project in the Garmin Developer Toolkit.
   - Build and deploy the app to your device for testing.

3. **Debugging**:
   - Use `System.println()` statements strategically throughout the codebase to log debug information.
   - Monitor logs via the Garmin SDK tools or on-device logging features.

## License

This project is open-source software released under the [MIT License](LICENSE).

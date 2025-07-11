# Changes

## 2024-05-03 v0.4.0

* Conform to SDK **7.1.1**:
  + Update `SDK_VERSION` constant to use the new version
  + Modify `configure_sdk` method to handle changes in SDK 7.1.1
* Add support for Edge 1030 plus:
  + Implement `Edge1030Plus` class with methods for interacting with the device
  + Update `device_types` array to include the new device type

## 2022-08-23 v0.3.1

* Disable switching if `timer` is turned off, preventing unintended frequent
  switching.
  + Avoids state where switching occurs more often than intended due to
    `onUpdate` method being called more frequently than every second.

## 2022-08-21 v0.3.0

* Added configurable switching of display mode between `speed` and `cadence`
* Introduced new method to switch display mode, currently implemented as a
  simple toggle
* Variable `display_mode` now holds the current display mode (`'speed'` or
  `'cadence'`)

## 2021-11-09 v0.2.0

  * Start

using Toybox.WatchUi;
using Toybox.Application;
using Toybox.Graphics;

class Background extends WatchUi.Drawable {
  hidden var mColor; // Holds the color of the background

  /* 
   * Initializes the Background object with a specific identifier.
   */
  function initialize() {
    var dictionary = { :identifier => "Background" }; // Create initialization dictionary with identifier
    Drawable.initialize(dictionary);                  // Initialize the base Drawable functionality
  }

  /* 
   * Sets the color of the background.
   * @param color The color to set for the background
   */
  function setColor(color) {
    mColor = color; // Set the background color using the provided value
  }

  /* 
   * Draws the background with the specified color.
   * @param dc The drawing context used to render the background
   */
  function draw(dc) {
    dc.setColor(Graphics.COLOR_TRANSPARENT, mColor); // Set the color with transparency
    dc.clear();                                      // Clear the drawing context to apply the background color
  }
}

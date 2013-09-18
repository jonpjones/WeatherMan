## Setting Screen
* The box should have padding of 10 points on the left and right and 30 points on the top
* Tapping on the blurred area should dismiss the settings screen without changing the settings
* All internal elements spacing should be separated by 10 points
* The color of the elements in this screen should be the opposite of the main screen
* The blur effect should be the light effect

## Main Screen

* If the current temperature is less than 60˚, all the elements on the screen should be blue (0x007aff), otherwise orange (0xFF9500). If there is no weather condition loaded, it should be orange.
* The title should be the current weather's display city from the current conditions.
* The background should be 0xdedede

### Header Bar
* The height of the header bar should be 116 pts tall
* The provided gradient images should be used in place of the page color.
* The cog should be 10 points from the top and right side
* The temperature should be 10 points from the top and Helvetica Neue Ultra Light at 75 points
* The conditions should be 15 points below the temperature label and should be Subheadlines
* The temperature and the conditions should be centered in the view

### Cells
* The cells should be 80 points by 80 points
* The weather icon should be 40 points by 40 points and centered in the cell
* The time and temperature in the should both be of type Subheadlines
* The high temperature for the day for the dataset should be the warm gradient and all elements should be white
* The low temperature for the day for the dataset should be the cool gradient and all elements should be white
* Fetching the cell weather icon should use the provided category on `NSURLRequest`

### Error View
* The umbrella image should be horizontally centered. It should be offset 10 points high from the vertical center
* The text should be a headline. It should have padding of 10 points on the left and right and 10 points below the the umbrella icon
* The color of the top in error conditions should be the orange gradient

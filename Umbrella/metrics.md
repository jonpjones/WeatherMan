# Weather Screen
* The warm color is 0xFF9800.
* The cool color is 0x03A9F4.

## Current Conditions
* The default color for when there is no ZIP Code entered is the warm color.

### Portrait
* The city/state label should be a headline font. It should be 30 points from the top of the screen. It should be 10 points from left of the screen.
* The settings cog (image: settingsCog) should be aligned vertically with the city/state label. It should be 10 points from the right of the screen.
* The current temperature label should be a light weight font at 60 points. It should be 5 points under the city/state label. It should be horizontally centered in the view. It should always be rounded to a whole number.
* The current conditions label should be a subheadline, 5 points under the current temperature label and horizontally centered. There should be 5 points of space between the bottom of the label and the bottom of the current conditions box.

### Landscape
* The background box should always be 240 points wide.
* The settings cog should be 10 points from the right and top of the background.
* The current temperature should be center aligned both vertically and horizontally.
* The city/state label should be a 10 points above the current temperature label and horizontally centered.
* The current conditions label should be 10 points under the current temperature label and horizontally centered.

## Hourly Forecast
* The section insets for the scrollable area is 20 points on all sides. The minimum space for cells is 10 points. The minimum spacing for lines is 20 points.
* The scrollable area should take the remaining space that the current conditions box doesn’t use

### Section Header 
* The top of the daily group has a 2 point tall line full width of the group. It should be 0x888888.
* The day header label should be the relative date where applicable (today, tomorrow, etc). It should be 20 points left of the scrollable area and centered vertically. It should be a headline and black.
* The line under the day header label should be 1 point tall and full width. It also should be 0x888888.
* The height of the section header should be 50 points.

### Hourly Cells
* The weather cells should be 62 points x 62 points
* The weather cell date should be 12 point system font and 2 points above the icon. It should be a short style (e.g. 12:00 AM)
* The weather cell icon should be 28 points by 28 points and be vertically and horizontally centered in the cell
* The weather cell temperature should be 12 point system font and 2 points below the icon. It should be horizontally centered. It should always be rounded to a whole number.

# Enter ZIP Screen
* The background of the settings screen should be the weather screen blurred with a dark effect. Tapping on the blurred area should dismiss this view.
* The zip code background should be 15 points from the left and right of the screen. It should be 45 points from the top of the screen. The background is white and has a corner radius of 10 points.
* The search hourglass should be 10 points from the left of the background and vertically centered in the field.
* The zip code entry should be vertically centered. It should be 10 points from the left of the search glass and 10 points from the right side of the background field
* The segmented control should be 25 points from the bottom of the zip field. It should be horizontally centered and 225 points wide. It should use a vibrancy effect.
* The "Get the weather" button should be centered in the container and 25 points from the bottom of the segmented control. It should use a vibrancy effect.
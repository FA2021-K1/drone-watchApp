# drone-watchApp

App installed on an apple watch which is mounted to the drone.

## Prerequisites

The apple watch needs to be prepared in order to work properly
- watchOS 8 or later is needed (for the always on functionality)
- ensure that the always on display is turned on
- turn wrist detection off (settings -> passcode -> wrist detection)
- set return to clock to 1 hour (settings -> general -> return to clock)

this enables the app to run for 1 hour in the foreground such that we can periodically check if we are already in range of a buoy

## first usage

On first startup, the user needs to accept that the app joins the required wifi networks. This is the only required user interaction.


# Toit-Examples
Step by step user examples to Toit projects, high level code for ESP32.
Note that there is one big project including all dependencies, if you want the individual package dependencies, there is a link to each example from Toit where the specific packages are listed.

I built the projects in the following order: Hello, Touch, Time, Display and Telegram.
The idea is to include what I learnt from the previous project in the next one, so that the Telegram project should mix all the previous ones. That is why this is a big project, since the Telegram .toit file references .toit files from other folders.

At the beggining I just followed the instructions given in the documentation, which are very clear, and as I got confident I started to get more creative and write my own code. I recommend doing the same, since the first projects are easily readable and understandable.

Here, I assume that you have followed the first steps from [Toit](https://docs.toit.io/getstarted) for the IDE setup, and project initialization.

## [Hello](https://docs.toit.io/tutorials/setup/firstprogram)

This simple project helps introduce to the Toit language and does a simple console display.

## [Touch](https://docs.toit.io/tutorials/hardware/touch)

This simple project requires only a wire and the SMT32. It displays on console the different values registered when the wire connected to a pin from the board is touched.

## [Time](https://docs.toit.io/tutorials/misc/date-time)

This project has two main files
* time.toit
* updatedTime.toit
  
The other file contains a function that is referenced in other projects.

## [Display](https://docs.toit.io/language/sdk/display)

This project has one core file
* get_display.toit

and then, the other files are different, increasingly more complex displays
* simpleDisplay.toit prints text via the OLED screen
* displayCurrentTime.toit prints the timpestamp of the execution time via the OLED screen
* displayCTMod.toit does the same than the previous program but modularized, introduces imports from the same project
* displayTimeRefresh.toit with modular programming, displays current time and date via the OLED screen, dividing the OLED screen in two rectangles. The rectangle where the time is displayed is refreshed every second, keeping the timestamp on screen updated

## [Telegram bot](https://docs.toit.io/tutorials/network/telegram)

This project implements a Telegram bot. After having configured the bot via Telegram, it uses a private chat to answer to some commands.
It also displays on the screen device the last message received

There are two files in this project:
* secrets.toit Includes sensitive information. More information about secrets [here](https://docs.toit.io/tutorials/misc/secrets).
* telegram.toit Contains the main code. The program is modularized, and uses methods from Time and Display projects.

The three defined commands are:
* fact: responds with a random fact retrieved fromt he public API
* date: responds with a message including the current date
* time: responds with a message with the current timestamp
For every other input, the SMT32 sends an default answer via chat.

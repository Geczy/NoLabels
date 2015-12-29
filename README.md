#NoLabels
This is a very simple tweak that I created in order to help people start writing Cydia tweaks. I wrote a blog post explaining the process of writing this program. You can check it out [here](https://blog.melone.co/intro-to-cydia-development).

##How to compile
First, you are going to need [Theos](https://github.com/DHowett/theos) set up correctly on your device or computer. Clone this repository into your project folder. You will also need some Preference headers. Download them from [here](https://github.com/nmcae/resources/raw/master/Preferences.zip) and place them in `$THEOS/include`. Make sure you the files have the correct permissions. Now you can compile.

`make` will create just the binary file

`make package`will create the binary file and package it into a deb file

`make package install`will install the program on your device
##Contributing 
If you would like to contribute to this project, I would greatly appreciate it if you opened an issue or fork this repository and start a pull request.

If you want to help contribute to the guide, see here.

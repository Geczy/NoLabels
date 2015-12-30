#NoLabels
This is a very simple tweak that I created in order to help people start writing Cydia tweaks. I wrote a blog post explaining the process of writing this program. You can check it out [here](https://blog.melone.co/intro-to-cydia-development).

##How to compile
First, you are going to need [Theos](https://github.com/kirb/theos) set up correctly on your device or computer. Clone this repository into your project folder. Make sure you the files have the correct permissions. Now you can compile.

`make` will create just the binary file

`make package`will create the binary file and package it into a deb file

`make package install`will install the program on your device
##Contributing 
If you would like to contribute to this project, I would greatly appreciate it if you opened an issue or fork this repository and start a pull request.

If you want to help contribute to the guide, see here.

#NoLabels is a very simple tweak that I wrote that hides the labels under the icons on your iOS device. I wrote a [post](https://blog.melone.co/intro-to-cydia-development) on my blog explaining the whole process.

##Compiling
I wrote this with a [fork of Theos](https://github.com/kirb/theos) by @kirb. It is a huge improvement over the original Theos by Dustin Howett, and it is great especially for beginners.
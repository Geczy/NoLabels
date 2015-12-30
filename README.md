#NoLabels 
This is a very simple tweak that I wrote that hides the labels under the icons on your iOS device. I wrote a [post](https://blog.melone.co/intro-to-cydia-development) on my blog explaining the whole process.

##Compiling
I wrote this with a [fork of Theos](https://github.com/kirb/theos) by @kirb. It is a huge improvement over the original Theos by Dustin Howett, and it's great especially for beginners. If you are having any difficulty compiling it, it most likely is an issue with your Theos setup. You can take a look at the [troubleshooting page](http://iphonedevwiki.net/index.php/Theos/Troubleshooting) on the iPhoneDevWiki.

Clone this repository in your projects folder, `cd` into the `nolabels` folder and you can run any of the following commands.

`make` Will create a `dylib` (dynamic library) file in the `obj` folder. There isn't much you can do with this.

`make package` Will create a deb file containing the correct file structure to make Cydia Substrate load it. Do this is you would like to distribute the file or manually install it on your device.

`make package install` Will install the tweak on your device so you can see instant results.

##Contributing 
If you feel like you could help by making the code a little bit more readable or opening an issue to help squash a nasty bug, I would greatly appreciate either one. 

See [this page]()if you want to help contribute to the guide itself.

I can be contacted via Twitter ([@nmcae](https://twitter.com/nmcae))
Or you can shoot me an email (caetano@melone.co)
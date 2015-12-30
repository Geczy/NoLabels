#Intro to Cydia development

I wrote this to help people get their start in the Cydia developer community.

After asking on /r/jailbreak whether or not to write this guide, I decided to do it due to popular demand. A few notes:

* If you have never touched or heard of the command line or the shell, you probably shouldn't be here
* This is NOT an introduction to Objective-C or programming. It is simply helping you get comfortable with it.

This guide is split up into two parts.

* How to write a basic tweak with Logos and Objective-C
* Create a preference pane to add configuration to your tweak

####What is "Theos" and how do tweaks work?

`Theos` is a collection of Perl scripts that makes it easier to manage, compile, and package your projects. It isn't an IDE, all compiling is done strictly command line. Before you go ahead and create your project, first you need to research what you want to modify by looking through headers. Once you find something you want to hijack, you go ahead and start writing some code. Logos (included with Theos) is a collection of constructors that makes it very simple to "hook" into anything. The compiler is LLVM+Clang. Once it compiles, you are left with a `dylib` (dynamic library) file. This is what Cydia Substrate uses to load the tweak.

####Installing Theos
If you would like to install Theos, you have plenty of options. You can use Dustin Howett's original (but rarely updated) version, Ryan Petrich's fork, or kirb's fork that is updated regularly and makes it even more convenient to write tweaks. There is also the option of installing it on different Operating Systems. iOS, Windows, Linux, and Mac are supported. There is **no** difference in how the code looks accross OS's, it might just be harder to get Theos set up. If you would like to install kirb's Theos on your machine, please see [the wiki post by kirb](https://github.com/kirb/theos/wiki/Installation). [This](http://iphonedevwiki.net/index.php/Theos/Setup) iPhoneDevWiki page is also a great resource.


##Writing your first tweak


####Requirements
* Windows, Mac, Linux, or iOS device
* Confidence using the command line
* Theos installed correctly on the computer

####Research

Now that you have Theos correctly set up, let's do a little research. The way we find methods to change is to look through headers. Headers might control how a specific part of the device's software behaves or looks. The easiest and fastest way to sift through headers, in my opinion, is [Limneos' developer portal](http://developer.limneos.net). You can easily search for any header or framework at the click of a button.

We will be hijacking a SpringBoard method. The SpringBoard is what controls the appearance and behavior of places like the home screen and lock screen. It is actually treated like any other system app.

Sometimes, it is fun to see if a method that was created a few years ago is still present in the firmware we use today. So what you are going to want to do is switch to the iOS 6 section on Limneos' website. When you want to write a tweak, you are always going to want to have an idea of what you would like to change. I want to hide the labels underneath all the icons on the SpringBoard. Let's search for IconLabel. The first header that popped up was `SBIconLabelImageParameters.h`. Let's take a look.

```objective-c
#import <SpringBoard/SpringBoard-Structs.h>
#import <CoreFoundation/NSCopying.h>

@class NSString;

@interface SBIconLabelImageParameters : NSObject <NSCopying> {

    NSString* _text;
    char _containsNonLatinLikeCharacters;
    char _containsEmoji;
    char _canEllipsize;
    CGSize _maxSize;

}
+(id)parametersWithText:(id)arg1 canEllipsize:(char)arg2 maxSize:(CGSize)arg3 ;
-(id)initWithText:(id)arg1 canEllipsize:(char)arg2 maxSize:(CGSize)arg3 ;
-(char)canEllipsize;
-(char)colorspaceIsGrayscale;
-(CGSize)maxSize;
-(id)font;
-(id)text;
-(float)shadowBlur;
-(CGSize)shadowOffset;
-(id)textColor;
-(id)shadowColor;
-(void)dealloc;
-(id)copyWithZone:(NSZone*)arg1 ;
-(char)isEqual:(id)arg1 ;
-(unsigned)hash;
-(id)description;
@end
```

It seems like the class `SBIconLabelImageParameters` controls the font, the text color, and the shadow color of the icon labels. There is also a method called `-(id)text` that looks interesting . Maybe we can do something with this.

####Writing the code

Open your Terminal, and create a folder where all your projects will be held. The best option is probably to store it in your home folder.

```bash
mkdir ~/Projects
```

Now `cd` into ~/Projects. Run the following command:

```bash
$THEOS/bin/nic.pl
```

This will start the NIC (New Instance Creator). This is where Theos asks you what type of project you would like to create. This should be the output:

```
NIC 2.0 - New Instance Creator
------------------------------
[1.] iphone/activator_event
[2.] iphone/application_modern
[3.] iphone/cydget
[4.] iphone/flipswitch_switch
[5.] iphone/framework
[6.] iphone/ios7_notification_center_widget
[7.] iphone/library
[8.] iphone/notification_center_widget
[9.] iphone/preference_bundle_modern
[10.] iphone/tool
[11.] iphone/tweak
[12.] iphone/xpc_service
```
We want to make a tweak, right? So let's select 11. I will go through all the different options.
<pre>Project Name (required):</pre>
This is the name of the tweak. I'll call it NoLabels



<pre>Package Name [com.yourcompany.tweakname]:</pre>
This is our bundle identifier. Cydia uses this to differentiate packages from one another in case they have the same name. If you own a domain name (ex: melone.co) I would have my package name be `co.melone.nolabels`. If you don't have a domain, then it is perfectly fine to use something like `com.john.nolabels`. Please note that is it important to have a different package name than me in this guide, it can possibly mess up your code.

<pre>Author/Maintainer Name [Caetano Melone]:</pre>
If you would like to receive email support for your packages, you can put something like `Caetano Melone <caetano@melone.co>`.

<pre>MobileSubstrate Bundle filter [com.apple.springboard]:</pre>

This is where you select the process you would like to hook into. Click enter.

<pre>List of applications to terminate upon installation (space-separated, '-' for none) [SpringBoard]:</pre>
Here you get to choose what process gets killed when your tweak is compiled. Click enter.

Now go to the folder Theos just created. In my case it is `~/Projects/nolabels`.

There were four files created.

* The control file includes basic info about the tweak
* The Makefile is a file full of commands that make sure your tweak compiles correctly
* NoLabels.plist is what Cydia Substrate reads when looking what process to hook into. Your tweak will NOT work without it
* Tweak.xm is where all the code goes.

Now let's start writing some actual code.

Open the Tweak.xm file. Delete everything inside. We will start by telling Logos which class we would like to modify. The `%hook` constructor literally "hooks" into a class. So let's type

```logos
%hook SBIconLabelImageParameters
```

Now Logos knows we want to modify methods inside of the `SBIconLabelImageParameters` class.

Start a new line and type the method that we wanted to modify. Hint: it was `(id)text`.
This is what your code should look like so far:

```logos
%hook SBIconLabelImageParameters
-(id)text
```

Next, we are going to return the value we want it to be. In this case, since our method represents the label text, wouldn't it make sense to return it as nothing? That is called `nil` or `null`. Open a curly bracket (`{`) and type:

```logos
return nil;
```

Then close your bracket (`}`). And now let's tell Logos that we are done modifying this class by using the `%end` constructor. This is what my Tweak.xm looks like now:

```logos
%hook SBIconLabelImageParameters
-(id)text {
    return nil;
}
%end
```

Now that you are 100% sure that all the code is written correctly, we can go ahead and compile. Make sure that you are in your project folder.

Every time I tell you to compile your tweak, I mean to run a specific command.

`make` only creates the binary file (dylib)

`make package` creates a deb file that includes the dylib file

`make package install` installs the tweak on your device

`make do` is a shortcut for `make package install`

You can run either one of these, but if you would like to see the results on your device, I would suggest the last two.

I ran `make do`, and it compiled with no errors.

Once you unlock your device you will see that you have no icon labels.

Congrats! You are now a tweak developer. If you want your icon labels back, you can uninstall NoLabels from Cydia.

##Creating a Preference Bundle for our tweak
######Requirements

Ready to add some customization to our tweak? Great!

The first thing you are going to want to do is `cd` into the nolabels folder. For example, I would run
```bash
cd ~/Projects/nolabels
```
Now you need to bring the NIC up again.
```bash
$THEOS/bin/nic.pl
```
Select option number eight. Keep the project and package name the same as our initial project to avoid confusion. I will make the class name prefix `NBL`.


Now you should have a new folder called "nolabels" in your project folder. Open it up,  and take a look. You should see three files and one folder.

* entry.plist is where all the basic information about the bundle goes. For example, the name of the icon file.

* NBLRootListController.m is where all the code goes.

* NBLRootListController.h is a header file. We don't have to worry about this.

* We already know what a Makefile is

* And there are 2 files in the "Resources" folder

    * Info.plist is also some extra bundle information

    * Root.plist is where you can configure the layout of your preference page. You will be spending a lot of time in this file.

In order to add the ability to turn our tweak on and off,  we need to head back to our Tweak.xm file.

The first thing we are going to want to do is define where we want the preference values stored. I will store it as an NSString for later use. We will eventually set it up so our tweak can read the file,  and knowing what value is the correct one. Don't forget to replace my bundle identifier with yours!

```objective-c
NSString *settingsPath = @"/var/mobile/Library/Preferences/co.melone.nolabels.plist";
```

Now we are going to add the ability to read the file with an NSMutableDictionary.

```objective-c
NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsPath];
```
Next, we are going to choose a `key` so we can tell if the tweak is enabled at any given time.

To make things easy, my key will be `enabled`.

Now skip to after we had `-(id)text {`, and add this line:
```objective-c
BOOL enabled = [prefs objectForKey:@"enabled"] ? [[prefs objectForKey:@"enabled"] boolValue] : YES;
```
This is checking for the status of a bool value called `enabled` in the plist file we defined.

This is what your file should look like so far:
```objective-c
NSString *settingsPath = @"/var/mobile/Library/Preferences/co.melone.nolabels.plist";
NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsPath];

%hook SBIconLabelImageParameters
-(id)text {

  BOOL enabled = [prefs objectForKey:@"enabled"] ? [[prefs objectForKey:@"enabled"] boolValue] : YES;
```

Now that that is done, we have to write a couple of "if" and "else" statements.
Start a new line, and type:
```objective-c
if(enabled) {
```
So basically if the user wants the tweak to be enabled, we should return the value that makes the icon labels disappear.
```logos
return nil;
```

Close the bracket and on another new line, we'll be checking if the value is anything other than enabled.
```objective-c
else {
```
Now in the case that our user doesn't want the tweak enabled, we have to return our original value.  In Logos, we do this with `%orig;`. Type
```logos
return %orig;
```
and close the bracket.

After all that typing, this is what your Tweak.xm file will look like.

```objective-c
NSString *settingsPath = @"/var/mobile/Library/Preferences/co.melone.nolabels.plist";
NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsPath];

%hook SBIconLabelImageParameters
-(id)text {

  BOOL enabled = [prefs objectForKey:@"enabled"] ? [[prefs objectForKey:@"enabled"] boolValue] : YES;

  if(enabled) {
    return nil;
  }
  else {
  return %orig;
    }
}
%end
```

Remember when we first started writing our tweak and the value that hid our icon labels was `nil`? Well, thats what we are going to put here. Type out

```logos
return nil;
```

and close the bracket.

This is what your code should look like:

```logos
if(enabled) {
  return nil;
}
```

In a nutshell what this is doing is saying that "if" the user has the tweak enabled, it will return `nil`  or `null` which hides the icon labels. This is our default value.


Next, let's create an "else" statement. All you have to do is write `else` and open a bracket. Here we will call our original function with `%orig`. This will have the user return to his default settings, or actually having icon labels now. Also, don't forget to close the bracket.

Code:

```logos
else {
  return %orig;
}
```

Now close the original bracket, we will telling Logos that we are done with this method with the constructor `%end`.

This should be your Tweak.xm after everything. Please don't forget to replace my bundle identifier with yours.

```objective-c
NSString *settingsPath = @"/var/mobile/Library/Preferences/co.melone.nolabels.plist";
NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsPath];

%hook SBIconLabelImageParameters
-(id)text {

  BOOL enabled = [prefs objectForKey:@"enabled"] ? [[prefs objectForKey:@"enabled"] boolValue] : YES;

  if(enabled) {
    return nil;
  }
  else {
    return %orig;
  }
}
%end
```

Now that we are done with that, head to the `Resources` folder in the newly created preference directory.
After we are done with our Tweak.xm, we can head to the "Resources" folder in our newly created preference directory. Open Root.plist and you it will look exactly like this (other than the identifier being different). This file controls the layout of our preference pane.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>items</key>
	<array>
		<dict>
			<key>cell</key>
			<string>PSGroupCell</string>
			<key>label</key>
			<string>NoLabels First Page</string>
		</dict>
		<dict>
			<key>cell</key>
			<string>PSSwitchCell</string>
			<key>default</key>
			<true/>
			<key>defaults</key>
			<string>co.melone.nolabels</string>
			<key>key</key>
			<string>AwesomeSwitch1</string>
			<key>label</key>
			<string>Awesome Switch 1</string>
		</dict>
	</array>
	<key>title</key>
	<string>NoLabels</string>
</dict>
</plist>
```

Delete everything between the two "dict" tags after "array" so we can get comfortable writing plist files. So now we should have something like this:


```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
        <dict>
            <key>items</key>
            <array>
            </array>
            <key>title</key>
            <string>NoLabels</string>
        </dict>
</plist>
```

Now, open a "dict" tag after array and press enter. After you do this, you are going to want to create a "key" tag. Put "cell" between them. For example: `<key>cell<key>`. A `string` tag is basically what the key tag was asking for. So in between the string tags put `PSSwitchCell`. What it is should be self explanatory. It is an on/off switch that either outputs a BOOL value of TRUE or FALSE.

After we are done with that, we are going to want to create a default value. So create a key `default`. This time we will not be be using a string tag. Under the link you just wrote, type this: `<true/>`.

Don't worry, we just have three more things to put here. Please do not confuse the next tag with the previous one. This one will be named `defaults`. The string will be your bundle identfier. This is how your Tweak.xm knows the status of the on/off switch. After the user toggles it on or off, the preference pane writes this value to the plist we defined in the Tweak.xm.

I'll let you do this one on your own. Create a key named `key` and a string with the key we put in our Tweak.xm. In our case it was `enabled`.


Now create a key named `label` and we will call the string `Enable`.


After writing everything, this is what your plist file should look like:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
      <dict>
          <key>items</key>
          <array>
              <dict>
                  <key>cell</key>
                  <string>PSSwitchCell</string>
                  <key>default</key>
                  <true/>
                  <key>defaults</key>
                  <string>co.melone.nolabels</string>
                  <key>key</key>
                  <string>enabled</string>
                  <key>label</key>
                  <string>Enable</string>
              </dict>
          </array>
          <key>title</key>
          <string>NoLabels</string>
      </dict>
</plist>
```

Compile your tweak, open the Settings app, and scroll to the NoLabels bundle. Open it, and you should see and on/off switch with the label `Enabled`. You will see if you turn this tweak off, and respring, you will have your icon labels back.

Congrats, you have just created your first on/off switch.

There is one last thing I would like you to do. Open your the `control` file. It should look like this:
```
Package: co.melone.nolabels
Name: NoLabels
Depends: mobilesubstrate
Version: 0.0.1
Architecture: iphoneos-arm
Description: An awesome MobileSubstrate tweak!
Maintainer: Caetano Melone <caetano@melone.co>
Author: Caetano Melone <caetano@melone.co>
Section: Tweaks
```

I am going to change the description to: `Hide those icon labels!` and add a dependency. Add a comma after `mobilesubstrate` and type `preferenceloader`. This makes sure that the user will be able to see our preference pane after installing your tweak.

```
Depends: mobilesubstrate, preferenceloader
```

Thank you for taking the time to read this. If you would like to contribute to this guide, please take a look at [this](https://github.com/nmcae/NoLabels/tree/master/guide#contributing) page.

NoLabels is open sourced on [Github](https://github.com/nmcae/nolabels).

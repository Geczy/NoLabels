/*
© 2015 Caetano Melone
MIT License
https://github.com/nmcae/nolabels
*/
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

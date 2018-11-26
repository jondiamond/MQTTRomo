//
//  AppDelegate.m
//  HelloRMCharacter
//

#import "AppDelegate.h"

#import "ViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Register user defaults
    NSString *settingsBundlePath = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"bundle"];
    NSBundle *settingsBundle = [NSBundle bundleWithPath:settingsBundlePath];
    NSString *rootPlistPath = [settingsBundle pathForResource:@"Root" ofType:@"plist"];
    NSDictionary *settingsDict = [[NSDictionary alloc] initWithContentsOfFile:rootPlistPath];
    NSArray *settingsItems = [settingsDict objectForKey:@"PreferenceSpecifiers"];
    NSMutableDictionary *defaultDict = [NSMutableDictionary new];
    for (NSDictionary *itemDict in settingsItems) {
        if ([itemDict objectForKey:@"DefaultValue"]) {
            [defaultDict setObject:[itemDict objectForKey:@"DefaultValue"] forKey:[itemDict objectForKey:@"Key"]];
        }
    }
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultDict];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.viewController = [[ViewController alloc] initWithNibName:nil bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end

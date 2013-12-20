//
//  AppDelegate.m
//  BuildAnywhere
//
//  Created by Viktor Sydorenko on 2/16/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "AppDelegate.h"
#import "DbManager.h"
#import "UserSettings.h"
#import "iCloudHandler.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self registerDefaultsFromSettingsBundle];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(iCloudAccountAvailabilityChanged:)
                                                 name: NSUbiquityIdentityDidChangeNotification
                                               object: nil];
    
    [self initUbiqURL];
    
    self.dbManager = [[DbManager alloc] init];
    
    return YES;
}

-(void)iCloudAccountAvailabilityChanged{
    DLog(@"iCloudAccountAvailabilityChanged");
    [self initUbiqURL];
}

-(void)initUbiqURL{
    _ubiquityContainerUrl = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:[iCloudHandler getInstance]];
    
    dispatch_async (dispatch_get_global_queue (DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        _ubiquityContainerUrl = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
        if (_ubiquityContainerUrl != nil) {
            dispatch_async (dispatch_get_main_queue (), ^(void) {
                NSMetadataQuery *query = [[NSMetadataQuery alloc] init];
                [iCloudHandler getInstance].query = query;
                [query setSearchScopes:[NSArray arrayWithObject:
                                        NSMetadataQueryUbiquitousDocumentsScope]];
                NSPredicate *pred = [NSPredicate predicateWithFormat:@"%K ENDSWITH '.proj'", NSMetadataItemFSNameKey];
                DLog(@"Predicate: %@", pred.description);
                [query setPredicate:pred];
                
                [[NSNotificationCenter defaultCenter] addObserver:[iCloudHandler getInstance] selector:@selector(queryDidFinishGathering:)
                 name:NSMetadataQueryDidFinishGatheringNotification object:query];
                
                [[NSNotificationCenter defaultCenter] addObserver:[iCloudHandler getInstance] selector:@selector(queryDidFinishUpdating:)
                name:NSMetadataQueryDidUpdateNotification object:query];
                
                [query startQuery];
            });
        }
    });
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    UIApplication  *app = [UIApplication sharedApplication];
    UIBackgroundTaskIdentifier bgTask = 0;
    
    // in case user started some action (compiling the code) and immideately minimized the app
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        [app endBackgroundTask:bgTask];
    }];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)registerDefaultsFromSettingsBundle
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults synchronize];
    
    NSString *settingsBundle = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"bundle"];
    if(!settingsBundle)
    {
        return;
    }
    
    NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:[settingsBundle stringByAppendingPathComponent:@"Root.plist"]];
    NSArray *preferences = [settings objectForKey:@"PreferenceSpecifiers"];
    NSMutableDictionary *defaultsToRegister = [[NSMutableDictionary alloc] initWithCapacity:preferences.count];
    
    for (NSDictionary *prefSpecification in preferences)
    {
        NSString *key = [prefSpecification objectForKey:@"Key"];
        if (key){
            // check if value readable in userDefaults
            id currentObject = [userDefaults objectForKey:key];
            if (currentObject == nil){
                // not readable: set value from Settings.bundle
                id objectToSet = [prefSpecification objectForKey:@"DefaultValue"];
                [defaultsToRegister setObject:objectToSet forKey:key];
            } else{
                // already readable: don't touch
            }
        }
    }
    
    [userDefaults registerDefaults:defaultsToRegister];
    [userDefaults synchronize];
}

@end

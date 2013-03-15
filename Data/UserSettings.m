//
//  UserSettings.m
//  PocketCoder
//
//  Created by Viktor Sydorenko on 3/14/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "UserSettings.h"

@implementation UserSettings

+(BOOL) getSymbolsInitializedForLang:(int)lang{
    NSString* key = [NSString stringWithFormat:@"%@_%d", SYMBOLS_INITIALISED, lang];
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}
+(void) setSymbolsInitializedForLang:(int)lang{
    NSString* key = [NSString stringWithFormat:@"%@_%d", SYMBOLS_INITIALISED, lang];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:key];
}

+(BOOL) getBaseSymbolsInitialized{
    return [[NSUserDefaults standardUserDefaults] boolForKey:SYMBOLS_INITIALISED];
}
+(void) setBaseSymbolsInitialized{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:SYMBOLS_INITIALISED];
}

@end

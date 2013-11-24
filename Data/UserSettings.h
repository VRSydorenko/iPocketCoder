//
//  UserSettings.h
//  PocketCoder
//
//  Created by Viktor Sydorenko on 3/14/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SYMBOLS_INITIALISED @"symbols_initialised"
#define SAMPLES_INITIALISED @"samples_initialised"

@interface UserSettings : NSObject

+(BOOL) getSymbolsInitializedForLang:(int)lang;
+(void) setSymbolsInitializedForLang:(int)lang;
+(BOOL) getBaseSymbolsInitialized;
+(void) setBaseSymbolsInitialized;
+(BOOL) getCodeSamplesInitialized;
+(void) setCodeSamplesInitialized;

@end

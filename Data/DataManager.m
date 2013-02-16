//
//  DataManager.m
//  BuildAnywhere
//
//  Created by Viktor Sydorenko on 2/16/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "DataManager.h"
#import "DbManager.h"

@implementation DataManager

+(DbManager*) getDbManager{ // private
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).dbManager;
}

+(NSString*) getLanguageName:(int)language{
    return [[self getDbManager] getLanguageName:language];
}

@end

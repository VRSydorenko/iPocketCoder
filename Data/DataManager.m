//
//  DataManager.m
//  BuildAnywhere
//
//  Created by Viktor Sydorenko on 2/16/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "DataManager.h"

#define IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad

@implementation DataManager

+(DbManager*) getDbManager{ // private
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).dbManager;
}

+(int) saveProject:(Project*)project{
    return [[self getDbManager] saveProject:project];
}

+(NSString*) getLanguageName:(int)language{
    return [[self getDbManager] getLanguageName:language];
}

+(NSDictionary*) getProjectsBasicInfo{
    return [[self getDbManager] getProjectsBasicInfo];
}

+(NSDictionary*) getLanguages{
    return [[self getDbManager] getLanguages];
}

+(Project*) loadProject:(NSString*)name{
    return [[self getDbManager] loadProject:name];
}

@end

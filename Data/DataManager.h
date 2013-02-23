//
//  DataManager.h
//  BuildAnywhere
//
//  Created by Viktor Sydorenko on 2/16/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "Utils.h"
#import "ProjectCell.h"

@interface DataManager : NSObject

+(int) saveProject:(Project*)project;
+(int) saveSnippet:(Snippet*)snippet;

+(NSDictionary*) getLanguages;
+(NSString*) getLanguageName:(int)language;
+(NSDictionary*) getProjectsBasicInfo;
+(NSArray*) getSnippetNamesForLanguage:(int)lang;

+(Project*) loadProject:(NSString*)name;

+(NSArray*) getQuickSymbols;

@end

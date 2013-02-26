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
#import "Project.h"
#import "Snippet.h"

@interface DataManager : NSObject

+(int) saveProject:(Project*)project;
+(int) saveSnippet:(Snippet*)snippet;

+(NSDictionary*) getLanguages;
+(NSString*) getLanguageName:(int)language;
+(NSDictionary*) getProjectsBasicInfo;
+(NSArray*) getSnippetNamesForLanguage:(int)lang;

+(Project*) loadProject:(NSString*)name;
+(Snippet*) loadSnippet:(NSString*)name language:(int)lang;

+(NSArray*) getQuickSymbols;

+(void) deleteSnippet:(NSString*)name language:(int)lang;
+(void) deleteProject:(NSString*)name;

@end

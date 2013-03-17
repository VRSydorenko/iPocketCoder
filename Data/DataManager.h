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
+(QuickSymbol*) loadQuickSymbol:(int)iD;

+(NSArray*) getLanguagesSymbolUsedFor:(int)iD;
+(NSArray*) getQuickSymbols;
+(NSDictionary*) getQuickSymbolsDictionary;
+(NSDictionary*)getOrderedSymbolIDsForLanguage:(int)lang;
+(void) putQuickSymbol:(QuickSymbol*)symbol toLanguageUsage:(int)lang atIndex:(int)index;
+(void)removeQuickSymbol:(int)iD fomLanguageUsage:(int)lang;

+(void) deleteSnippet:(NSString*)name language:(int)lang;
+(void) deleteProject:(NSString*)name;
+(void) deleteQuickSymbol:(int)iD;

@end

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
+(int) createQuickSymbol:(NSString*)symbol;

+(NSDictionary*) getLanguages;
+(NSString*) getLanguageName:(int)language;
+(NSDictionary*) getBasicInfosForEntity:(EntityType)entity;
+(NSArray*) getSnippetNamesForLanguage:(int)lang;

+(Project*) loadProject:(NSString*)name;
+(Snippet*) loadSnippet:(NSString*)name language:(int)lang;
+(QuickSymbol*) loadQuickSymbol:(int)iD;
+(void)addDeletionRecord:(EntityType)entitiy withCreationDate:(int)when;
+(int)findDeletionRecord:(EntityType)entitiy withCreationDate:(int)when;

+(NSArray*) getLanguagesSymbolUsedFor:(int)iD;
+(NSArray*) getQuickSymbols;
+(NSDictionary*) getQuickSymbolsDictionary;
+(NSDictionary*)getOrderedSymbolIDsForLanguage:(int)lang;
+(void) putQuickSymbol:(int)symbId toLanguageUsage:(int)lang atIndex:(int)index;
+(void)removeQuickSymbol:(int)iD fomLanguageUsage:(int)lang;

+(void) deleteSnippet:(NSString*)name language:(int)lang;
+(void) deleteProject:(NSString*)name;
+(void) deleteQuickSymbol:(int)iD;

@end

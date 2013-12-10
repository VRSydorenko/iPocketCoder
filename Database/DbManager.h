//
//  DbHelper.h
//  SapidChat
//
//  Created by Viktor Sydorenko on 9/26/12.
//  Copyright (c) 2012 Viktor Sydorenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Project.h"
#import "Snippet.h"
#import "QuickSymbol.h"
#import "UserSettings.h"

@interface DbManager : NSObject

-(id) init;

-(void) open;
-(void) close;

// actions on single objects
-(int) saveProject:(Project*)project;
-(int) saveSnippet:(Snippet*)snippet;
-(int) createQuickSymbol:(NSString*)symbol;
-(Snippet*) loadSnippet:(NSString*)name language:(int)lang;
-(Project*) loadProject:(NSString*)name;
-(QuickSymbol*) loadQuickSymbol:(int)iD;
-(void) deleteProject:(NSString*)name;
-(void) deleteQuickSymbol:(int)iD;
-(void) deleteSnippet:(NSString*)name language:(int)lang;

// actions on multipte objects
-(NSDictionary*) getBasicInfosForEntity:(EntityType)entity; // <key: name, value:language>
-(NSArray*) getSnippetNamesForLanguage:(int)lang;

-(NSDictionary*) getLanguages;
-(NSString*) getLanguageName:(int)language;

-(NSArray*) getLanguagesSymbolUsedFor:(int)iD;
-(NSArray*) getQuickSymbols;
-(NSDictionary*) getQuickSymbolsDictionary;
-(NSDictionary*)getOrderedSymbolIDsForLanguage:(int)lang;
-(void) putQuickSymbol:(int)symbId toLanguageUsage:(int)lang atIndex:(int)index;
-(void)removeQuickSymbol:(int)iD fomLanguageUsage:(int)lang;

@end

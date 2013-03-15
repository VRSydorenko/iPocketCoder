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
-(Snippet*) loadSnippet:(NSString*)name language:(int)lang;
-(Project*) loadProject:(NSString*)name;
-(QuickSymbol*) loadQuickSymbol:(int)iD;
-(void) deleteProject:(NSString*)name;
-(void) deleteSnippet:(NSString*)name language:(int)lang;

// actions on multipte objects
-(NSDictionary*) getProjectsBasicInfo; // <key: name, value:language>
-(NSArray*) getSnippetNamesForLanguage:(int)lang;

-(NSDictionary*) getLanguages;
-(NSString*) getLanguageName:(int)language;

-(NSArray*) getQuickSymbols;
-(NSDictionary*)getOrderedSymbolIDsForLanguage:(int)lang;
-(void) putQuickSymbol:(QuickSymbol*)symbol toLanguageUsage:(int)lang atIndex:(int)index;

@end

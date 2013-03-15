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

+(int) saveSnippet:(Snippet *)snippet{
    return [[self getDbManager] saveSnippet:snippet];
}

+(NSString*) getLanguageName:(int)language{
    return [[self getDbManager] getLanguageName:language];
}

+(NSDictionary*) getProjectsBasicInfo{
    return [[self getDbManager] getProjectsBasicInfo];
}

+(NSArray*) getSnippetNamesForLanguage:(int)lang{
    return [[self getDbManager] getSnippetNamesForLanguage:lang];
}

+(NSDictionary*) getLanguages{
    return [[self getDbManager] getLanguages];
}

+(Project*) loadProject:(NSString*)name{
    return [[self getDbManager] loadProject:name];
}

+(Snippet*) loadSnippet:(NSString*)name language:(int)lang{
    return [[self getDbManager] loadSnippet:name language:lang];
}

+(QuickSymbol*) loadQuickSymbol:(int)iD{
    return [[self getDbManager] loadQuickSymbol:iD];
}

+(NSArray*) getQuickSymbols{
    return [[self getDbManager] getQuickSymbols];
}
+(NSDictionary*)getOrderedSymbolIDsForLanguage:(int)lang{
    return [[self getDbManager] getOrderedSymbolIDsForLanguage:lang];
}
+(void) putQuickSymbol:(QuickSymbol*)symbol toLanguageUsage:(int)lang atIndex:(int)index{
    [[self getDbManager] putQuickSymbol:symbol toLanguageUsage:lang atIndex:index];
}

+(void) deleteSnippet:(NSString*)name language:(int)lang{
    [[self getDbManager] deleteSnippet:name language:lang];
}

+(void) deleteProject:(NSString*)name{
    [[self getDbManager] deleteProject:name];
}

@end

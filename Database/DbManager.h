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

@interface DbManager : NSObject

-(id) init;

-(void) open;
-(void) close;

-(int) saveProject:(Project*)project;
-(int) saveSnippet:(Snippet*)snippet;

-(Snippet*) loadSnippet:(NSString*)name language:(int)lang;
-(Project*) loadProject:(NSString*)name;

-(void) deleteProject:(NSString*)name;
-(void) deleteSnippet:(NSString*)name language:(int)lang;

-(NSString*) getLanguageName:(int)language;

@end

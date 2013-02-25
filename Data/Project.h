//
//  Project.h
//  BuildAnywhere
//
//  Created by Viktor Sydorenko on 2/16/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Project : NSObject

@property int projId;
@property int projLanguage;
@property NSString* projCode;
@property NSString* projName;
@property NSString* projLink;
@property NSString* projInput;

-(id) initWithLanguage:(int)language name:(NSString*)name;

-(void) setId:(int)iD;
-(void) setCode:(NSString*)code;
-(void) setLink:(NSString*)link;
-(void) setInput:(NSString*)input;

-(void)save;

@end

//
//  Project.h
//  BuildAnywhere
//
//  Created by Viktor Sydorenko on 2/16/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Project : UIDocument

@property (readonly) int projId;
@property (readonly) int projLanguage;
@property (readonly) NSString* projCode;
@property (readonly) NSString* projName;
@property (readonly) NSString* projLink;
@property (readonly) NSString* projInput;

@property (readonly) BOOL isInCloud;

-(id) initWithLanguage:(int)language name:(NSString*)name;
-(id) initInCloudWithLanguage:(int)language name:(NSString*)name;

-(void) setId:(int)iD;
-(void) setCode:(NSString*)code;
-(void) setLink:(NSString*)link;
-(void) setInput:(NSString*)input;

-(void)save;
-(void)remove;
-(void)close;

@end

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

-(id) initWithLanguage:(int)language name:(NSString*)name code:(NSString*)code;

-(void) setId:(int)iD;
-(void) setLink:(NSString*)link;

@end

//
//  Project.h
//  BuildAnywhere
//
//  Created by Viktor Sydorenko on 2/16/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Snippet : NSObject

@property (readonly) int snipId;
@property (readonly) int snipLanguage;
@property (readonly) NSString* snipCode;
@property (readonly) NSString* snipName;

-(id) initWithLanguage:(int)language name:(NSString*)name code:(NSString*)code;

-(void)setId:(int)iD;

@end

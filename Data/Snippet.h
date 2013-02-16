//
//  Project.h
//  BuildAnywhere
//
//  Created by Viktor Sydorenko on 2/16/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Snippet : NSObject

@property int snipId;
@property int snipLanguage;
@property NSString* snipCode;
@property NSString* snipName;

-(id) initWithLanguage:(int)language name:(NSString*)name code:(NSString*)code;

-(void) setId:(int)iD;

@end

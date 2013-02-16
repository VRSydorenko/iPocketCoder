//
//  Project.m
//  BuildAnywhere
//
//  Created by Viktor Sydorenko on 2/16/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "Snippet.h"

@implementation Snippet

@synthesize snipLanguage, snipCode, snipName;

-(id) initWithLanguage:(int)language name:(NSString*)name code:(NSString*)code{
    self = [super init];
    if (self){
        self.snipLanguage = language;
        self.snipName = name;
        self.snipCode = code;
    }
    return self;
}

-(void) setId:(int)iD{
    self.snipId = iD;
}

@end

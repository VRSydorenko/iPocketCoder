//
//  Project.m
//  BuildAnywhere
//
//  Created by Viktor Sydorenko on 2/16/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "Project.h"

@implementation Project

@synthesize projId = _projId;
@synthesize projLanguage, projCode, projName;
@synthesize projLink  = _projLink;

-(id) initWithLanguage:(int)language name:(NSString*)name code:(NSString*)code{
    self = [super init];
    if (self){
        self.projLanguage = language;
        self.projName = name;
        self.projCode = code;
        self.projLink = @"";
        self.projId = -1;
    }
    return self;
}

-(void) setId:(int)iD{
    self.projId = iD;
}

-(void) setLink:(NSString*)link{
    self.projLink = link;
}

@end

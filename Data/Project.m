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
@synthesize projInput = _projInput;

-(id) initWithLanguage:(int)language name:(NSString*)name{
    self = [super init];
    if (self){
        self.projLanguage = language;
        self.projName = name;
        self.projCode = @"";
        self.projLink = @"";
        self.projId = -1;
        self.projInput = @"";
    }
    return self;
}

-(void) setId:(int)iD{
    self.projId = iD;
}

-(void) setCode:(NSString*)code{
    self.projCode = code;
}

-(void) setLink:(NSString*)link{
    self.projLink = link;
}

-(void) setInput:(NSString*)input{
    self.projInput = input;
}

@end

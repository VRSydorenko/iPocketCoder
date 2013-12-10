//
//  Project.m
//  BuildAnywhere
//
//  Created by Viktor Sydorenko on 2/16/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "Snippet.h"
#import "DataManager.h"

@implementation Snippet

-(id) initWithLanguage:(int)language name:(NSString*)name code:(NSString*)code{
    self = [super init];
    if (self){
        _snipLanguage = language;
        _snipName = name;
        _snipCode = code;
    }
    return self;
}

-(void)setId:(int)iD{
    _snipId = iD;
}

@end

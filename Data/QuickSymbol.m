//
//  QuickSymbol.m
//  BuildAnywhere
//
//  Created by Viktor Sydorenko on 2/22/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "QuickSymbol.h"

@implementation QuickSymbol

@synthesize symbId = _symbId;
@synthesize symbTitle = _symbTitle;
@synthesize symbContent = _symbContent;

-(id) initWithId:(int)iD title:(NSString*)title content:(NSString*)content{
    self = [super init];
    if (self){
        self.symbId = iD;
        self.symbTitle = title;
        self.symbContent = content;
    }
    return self;
}

@end

//
//  DbField.m
//  SapidChat
//
//  Created by Viktor Sydorenko on 9/26/12.
//  Copyright (c) 2012 Viktor Sydorenko. All rights reserved.
//

#import "DbField.h"

@implementation DbField{
    NSString* fName;
    NSString* fType;
    bool fNotNull;
}

-(id) initWithName:(NSString*)name type:(NSString*)type notNull:(bool)notNull{
    self = [super init];
    if (self){
        fName = name;
        fType = type;
        fNotNull = notNull;
    }
    return self;
}

-(NSString*) getSignature{
    NSString* notnull = fNotNull ? @" not null" : @"";
    return [NSString stringWithFormat:@"%@ %@%@", fName, fType, notnull];
    //fName + " " + fType + (fNotNull ? " not null" : "");
}

@end
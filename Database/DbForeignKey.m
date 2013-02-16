//
//  DbForeignKey.m
//  SapidChat
//
//  Created by Viktor Sydorenko on 9/26/12.
//  Copyright (c) 2012 Viktor Sydorenko. All rights reserved.
//

#import "DbForeignKey.h"

@implementation DbForeignKey{
    NSString* fName;
    NSString* fRefTable;
    NSString* fRefField;
}

-(id) initWithName:(NSString*)name type:(NSString*)refTable notNull:(NSString*)refField{
    self = [super init];
    if (self){
        fName = name;
        fRefTable = refTable;
        fRefField = refField;
    }
    return self;
}

-(NSString*) getSignature{
    return [NSString stringWithFormat:@"FOREIGN KEY (%@) REFERENCES %@(%@)", fName, fRefTable, fRefField];
    //return "FOREIGN KEY (" + FieldName + ") REFERENCES " + RefTable + (RefField.length()>0 ? "("+RefField+")" : "");
}

@end
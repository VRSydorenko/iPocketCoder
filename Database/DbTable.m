//
//  DbTable.m
//  SapidChat
//
//  Created by Viktor Sydorenko on 9/26/12.
//  Copyright (c) 2012 Viktor Sydorenko. All rights reserved.
//

#import "DbTable.h"
#import "DbField.h"
#import "DbForeignKey.h"

@implementation DbTable{
    NSString* tName;
    NSMutableArray* tFields;
}

-(id) initWithTableName:(NSString*)tableName{
    self = [super init];
    if (self){
        tName = tableName;
        tFields = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void) addField:(NSString*)name type:(NSString*)type notNull:(BOOL)notNull{
    DbField* field = [[DbField alloc] initWithName:name type:type notNull:notNull];
    [tFields addObject:field];
}

-(void) addForeignKey:(NSString*)name refTable:(NSString*)refTable refField:(NSString*)refField{
    DbForeignKey* foreignKey = [[DbForeignKey alloc] initWithName:name type:refTable notNull:refField];
    [tFields addObject:foreignKey];
}

-(NSString*) getTableCreationSQL{
    NSString* sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@", tName, PRIMARY_KEY_AUTO_INCREMENT];
    for (id field in tFields) {
        if ([field isKindOfClass:[DbField class]]){
            sql = [sql stringByAppendingFormat:@", %@", [(DbField*)field getSignature]];
        }
        if ([field isKindOfClass:[DbForeignKey class]]){
            sql = [sql stringByAppendingFormat:@", %@", [(DbForeignKey*)field getSignature]];
        }
    }
    return [sql stringByAppendingString:@");"];
}

@end

//
//  DBDefinition.m
//  SapidChat
//
//  Created by Viktor Sydorenko on 9/26/12.
//  Copyright (c) 2012 Viktor Sydorenko. All rights reserved.
//

#import "DBDefinition.h"
#import "DbTable.h"

@implementation DBDefinition{
    NSMutableArray* tables;
}

-(id) init{
    self = [super init];
    if (self){
        [self initialize];
    }
    return self;
}

-(void) initialize{
    tables = [[NSMutableArray alloc] init];
    
    DbTable* tLangs = [[DbTable alloc] initWithTableName:T_LANGS];
    [tLangs addField:F_LANG type:DBTYPE_REAL notNull:YES];
    [tLangs addField:F_NAME type:DBTYPE_TEXT notNull:YES];
    [tables addObject:tLangs];
    
    DbTable* tProjects = [[DbTable alloc] initWithTableName:T_PROJECTS];
    [tProjects addField:F_LANG type:DBTYPE_REAL notNull:YES];
    [tProjects addField:F_NAME type:DBTYPE_TEXT notNull:YES];
    [tProjects addField:F_CODE type:DBTYPE_TEXT notNull:YES];
    [tProjects addField:F_LINK type:DBTYPE_TEXT notNull:NO];
    [tables addObject:tProjects];
    
    DbTable* tSnippets = [[DbTable alloc] initWithTableName:T_SNIPPETS];
    [tSnippets addField:F_LANG type:DBTYPE_REAL notNull:YES];
    [tSnippets addField:F_NAME type:DBTYPE_TEXT notNull:YES];
    [tSnippets addField:F_CODE type:DBTYPE_TEXT notNull:YES];
    [tables addObject:tSnippets];
}

-(NSString*) getTablesCreationSQL{
    NSString* sql = [[NSString alloc] init];
    for (DbTable* table in tables) {
        sql = [sql stringByAppendingString:[table getTableCreationSQL]];
    }
    return sql;
}

@end

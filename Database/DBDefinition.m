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
    [tProjects addField:F_INPUT type:DBTYPE_TEXT notNull:NO];
    [tables addObject:tProjects];
    
    DbTable* tSnippets = [[DbTable alloc] initWithTableName:T_SNIPPETS];
    [tSnippets addField:F_LANG type:DBTYPE_REAL notNull:YES];
    [tSnippets addField:F_NAME type:DBTYPE_TEXT notNull:YES];
    [tSnippets addField:F_CODE type:DBTYPE_TEXT notNull:YES];
    [tables addObject:tSnippets];
    
    DbTable* tSymbols = [[DbTable alloc] initWithTableName:T_SYMBOLS];
    [tSymbols addField:F_SYMB_ID type:DBTYPE_REAL notNull:YES];
    [tSymbols addField:F_NAME type:DBTYPE_TEXT notNull:YES];
    [tSymbols addField:F_CODE type:DBTYPE_TEXT notNull:YES];
    [tables addObject:tSymbols];
    
    DbTable* tSymbolsOrder = [[DbTable alloc] initWithTableName:T_SYMBOLS_ORDER];
    [tSymbolsOrder addField:F_SYMB_ID type:DBTYPE_REAL notNull:YES];
    [tSymbolsOrder addField:F_LANG type:DBTYPE_REAL notNull:YES];
    [tSymbolsOrder addField:F_SYMB_ORDER type:DBTYPE_REAL notNull:YES];
    [tables addObject:tSymbolsOrder];
}

-(NSString*) getTablesCreationSQL{
    NSString* sql = [[NSString alloc] init];
    for (DbTable* table in tables) {
        sql = [sql stringByAppendingString:[table getTableCreationSQL]];
    }
    return sql;
}

@end

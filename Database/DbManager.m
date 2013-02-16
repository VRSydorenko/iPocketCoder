//
//  DbHelper.m
//  SapidChat
//
//  Created by Viktor Sydorenko on 9/26/12.
//  Copyright (c) 2012 Viktor Sydorenko. All rights reserved.
//

#import "DbManager.h"
#import "DBDefinition.h"
#import "sqlite3.h"

@implementation DbManager{
    sqlite3 *buildAnywhereDb;
}

-(id) init{
    self = [super init];
    if (self){
        [self initDatabase];
    }
    return self;
}

-(void) open{
    [self initDatabase];
}

-(void) close{
    sqlite3_close(buildAnywhereDb);
}

-(void) initDatabase{
    // Get the documents directory
    NSArray* dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    NSString* databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: DATABASE_NAME]];
    
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &buildAnywhereDb) == SQLITE_OK)
    {
        char *errMsg;
        DBDefinition* dbDef = [[DBDefinition alloc] init];
        const char *sql = [[dbDef getTablesCreationSQL] UTF8String];
        if (sqlite3_exec(buildAnywhereDb, sql, NULL, NULL, &errMsg) != SQLITE_OK)
        {
            NSLog(@"Error creating DB table(s)");
            NSLog(@"Info:%s", sqlite3_errmsg(buildAnywhereDb));
        }
    } else {
        NSLog(@"Failed to open/create database");
        NSLog(@"Info:%s", sqlite3_errmsg(buildAnywhereDb));
    }
}

// public methods
-(NSString*) getLanguageName:(int)language{
    NSString *querySQL = [NSString stringWithFormat: @"SELECT %@ FROM %@ WHERE %@=%d", F_NAME, T_LANGS, F_ID, language];
    const char *query_stmt = [querySQL UTF8String];
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(buildAnywhereDb, query_stmt, -1, &statement, NULL) == SQLITE_OK)
    {
        if (sqlite3_step(statement) == SQLITE_ROW)
        {
            NSString *nameField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
            return nameField;
        } else {
            NSLog(@"Language not found");
        }
    }
    sqlite3_finalize(statement);

    return @"";
}

-(int) saveProject:(Project*)project{
    Project* exists = [self loadProject:project.projName];
    NSString* sql;
    NSString *logMsg = @"";
    
    if (exists){ // already exists so update
        sql = [NSString stringWithFormat: @"UPDATE %@ SET %@ = ?, %@ = %d, %@ = ?, %@ = ? WHERE %@ =%d", T_PROJECTS, F_NAME, F_LANG, project.projLanguage, F_CODE, F_LINK, F_ID, exists.projId];
        logMsg = @"Project updated";
    } else { // doesnt exist so insert
        sql = [NSString stringWithFormat: @"INSERT INTO %@ (%@, %@, %@, %@) VALUES (?, %d, ?, ?)", T_PROJECTS, F_NAME, F_LANG, F_CODE, F_LINK, project.projLanguage];
        logMsg = @"Project inserted";
    }
    const char *insert_stmt = [sql UTF8String];
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(buildAnywhereDb, insert_stmt, -1, &statement, NULL) == SQLITE_OK){
        sqlite3_bind_text(statement, 1, [project.projName cStringUsingEncoding:NSUTF8StringEncoding], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 2, [project.projCode cStringUsingEncoding:NSUTF8StringEncoding], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 3, [project.projLink cStringUsingEncoding:NSUTF8StringEncoding], -1, SQLITE_TRANSIENT);
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"%@", logMsg);
            return [self loadProject:project.projName].projId;
        } else {
            NSLog(@"Failed to save project");
            NSLog(@"Info:%s", sqlite3_errmsg(buildAnywhereDb));
        }
    }
    sqlite3_finalize(statement);
    
    return -1;
}

-(int) saveSnippet:(Snippet*)snippet{
    Snippet* exists = [self loadSnippet:snippet.snipName language:snippet.snipLanguage];
    NSString* sql;
    NSString *logMsg = @"";
    
    if (exists){ // already exists so update
        sql = [NSString stringWithFormat: @"UPDATE %@ SET %@ = ?, %@ = %d, %@ = ? WHERE %@ =%d", T_SNIPPETS, F_NAME, F_LANG, snippet.snipLanguage, F_CODE, F_ID, snippet.snipId];
        logMsg = @"Snippet updated";
    } else { // doesnt exist so insert
        sql = [NSString stringWithFormat: @"INSERT INTO %@ (%@, %@, %@) VALUES (?, %d, ?)", T_SNIPPETS, F_NAME, F_LANG, F_CODE, snippet.snipLanguage];
        logMsg = @"Snippet inserted";
    }
    const char *insert_stmt = [sql UTF8String];
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(buildAnywhereDb, insert_stmt, -1, &statement, NULL) == SQLITE_OK){
        sqlite3_bind_text(statement, 1, [snippet.snipName cStringUsingEncoding:NSUTF8StringEncoding], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 2, [snippet.snipCode cStringUsingEncoding:NSUTF8StringEncoding], -1, SQLITE_TRANSIENT);
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"%@", logMsg);
            return [self loadSnippet:snippet.snipName language:snippet.snipLanguage].snipId;
        } else {
            NSLog(@"Failed to save snippet");
            NSLog(@"Info:%s", sqlite3_errmsg(buildAnywhereDb));
        }
    }
    sqlite3_finalize(statement);
    
    return -1;
}

-(Snippet*) loadSnippet:(NSString*)name language:(int)lang{
    NSString *querySQL = [NSString stringWithFormat: @"SELECT %@, %@ FROM %@ WHERE %@=? AND %@=%d", F_ID, F_CODE, T_SNIPPETS, F_NAME, F_LANG, lang];
    const char *query_stmt = [querySQL UTF8String];
    
    Snippet* snippet = nil;
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(buildAnywhereDb, query_stmt, -1, &statement, NULL) == SQLITE_OK){
        sqlite3_bind_text(statement, 1, [name cStringUsingEncoding:NSUTF8StringEncoding], -1, SQLITE_TRANSIENT);
        
        if (sqlite3_step(statement) == SQLITE_ROW){
            int iD = sqlite3_column_int(statement, 0);
            
            NSString *codeField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
            
            snippet = [[Snippet alloc] initWithLanguage:lang name:name code:codeField];
            [snippet setId:iD];
        } else {
            NSLog(@"Snippet not found in the database");
        }
    }
    sqlite3_finalize(statement);
    
    return snippet;
}

-(Project*) loadProject:(NSString*)name{
    NSString *querySQL = [NSString stringWithFormat: @"SELECT %@, %@, %@, %@ FROM %@ WHERE %@=?", F_ID, F_LANG, F_CODE, F_LINK, T_PROJECTS, F_NAME];
    const char *query_stmt = [querySQL UTF8String];
    
    Project* project = nil;
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(buildAnywhereDb, query_stmt, -1, &statement, NULL) == SQLITE_OK){
        sqlite3_bind_text(statement, 1, [name cStringUsingEncoding:NSUTF8StringEncoding], -1, SQLITE_TRANSIENT);
        
        if (sqlite3_step(statement) == SQLITE_ROW){
            int iD = sqlite3_column_int(statement, 0);
            
            int language = sqlite3_column_int(statement, 1);
            
            NSString *codeField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
            
            NSString *linkField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
            
            project = [[Project alloc] initWithLanguage:language name:name code:codeField];
            [project setId:iD];
            [project setLink:linkField];
        } else {
            NSLog(@"Project not found in the database");
        }
    }
    sqlite3_finalize(statement);
    
    return project;
}

-(void) deleteProject:(NSString*)name{
    NSString *deleteSQL = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = ?", T_PROJECTS, F_NAME];
    const char *delete_stmt = [deleteSQL UTF8String];
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(buildAnywhereDb, delete_stmt, -1, &statement, NULL) == SQLITE_OK){
        sqlite3_bind_text(statement, 1, [name cStringUsingEncoding:NSUTF8StringEncoding], -1, SQLITE_TRANSIENT);
        if (sqlite3_step(statement) == SQLITE_DONE){
        } else {
            NSLog(@"Error deleting project from database");
            NSLog(@"Info:%s", sqlite3_errmsg(buildAnywhereDb));
        }
    }
    sqlite3_finalize(statement);
}

-(void) deleteSnippet:(NSString*)name language:(int)lang{
    NSString *deleteSQL = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = ? AND %@=%d", T_PROJECTS, F_NAME, F_LANG, lang];
    const char *delete_stmt = [deleteSQL UTF8String];
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(buildAnywhereDb, delete_stmt, -1, &statement, NULL) == SQLITE_OK){
        sqlite3_bind_text(statement, 1, [name cStringUsingEncoding:NSUTF8StringEncoding], -1, SQLITE_TRANSIENT);
        if (sqlite3_step(statement) == SQLITE_DONE){
        } else {
            NSLog(@"Error deleting snippet from database");
            NSLog(@"Info:%s", sqlite3_errmsg(buildAnywhereDb));
        }
    }
    sqlite3_finalize(statement);
}
/*
-(void)updateOwnNick:(NSString*)nick{
    NSString* querySQL = [NSString stringWithFormat:@"UPDATE %@ SET %@ = ? WHERE %@ = \"%@\" AND %@ = \"%@\"", T_USERS, F_NICK, F_EMAIL, [UserSettings getEmail], F_AUTHOR, [UserSettings getEmail]];
    const char *query_stmt = [querySQL UTF8String];
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(buildAnywhereDb, query_stmt, -1, &statement, NULL) == SQLITE_OK)
    {
        sqlite3_bind_text(statement, 1, [nick cStringUsingEncoding:NSUTF8StringEncoding], -1, SQLITE_TRANSIENT);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
        } else {
            NSLog(@"Error updating nick");
            NSLog(@"Info:%s", sqlite3_errmsg(buildAnywhereDb));
        }
    }
    sqlite3_finalize(statement);
}*/

/*
-(NSArray*) loadMessagesWithCondition:(NSString*)condition{ // user specific method
    NSString* cond = condition.length > 0 ? [NSString stringWithFormat:@" AND %@", condition] : @"";
    NSString *querySQL = [NSString stringWithFormat: @"SELECT %@, %@, %@, %@, %@, %@, %@, %@, %@ FROM %@ WHERE %@=\"%@\" %@", F_FROM, F_TO, F_WHEN, F_TEXT, F_TYPE, F_LATD, F_LOND, F_ATTNAME, F_ATTDATA, T_MSGS, F_AUTHOR, [UserSettings getEmail], cond];
    const char *query_stmt = [querySQL UTF8String];
    
    NSMutableArray* msgs = [[NSMutableArray alloc] init];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(buildAnywhereDb, query_stmt, -1, &statement, NULL) == SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            Message* msg = [[Message alloc] init];
            
            NSString *fromField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
            msg.from = fromField;
            
            NSString *toField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
            msg.to = toField;
            
            msg.when = sqlite3_column_int(statement, 2);
            
            NSString *textField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
            msg.text = textField;
            
            NSString *typeField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
            msg.type = typeField.intValue;
            
            NSString *latitudeField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 5)];
            msg.latitude = latitudeField.doubleValue;
            
            NSString *longitudeField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 6)];
            msg.longitude = longitudeField.doubleValue;
            
            NSString *attachmentField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 7)];
            msg.attachmentName = attachmentField;
            
            int len = sqlite3_column_bytes(statement, 8);
            msg.attachmentData = [[NSData alloc] initWithBytes:sqlite3_column_blob(statement, 8) length:len];
            
            [msgs addObject:msg];
        }
    }
    sqlite3_finalize(statement);
    
    return [[NSArray alloc] initWithArray:msgs];
}*/
@end
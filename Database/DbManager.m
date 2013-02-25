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
        [self initLanguages];
        [self initQuickSymbols];
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

-(void) initLanguages{
    if ([self getLanguageName:1].length == 0){
        [self saveLanguage:7 withName:@"Ada"];
        [self saveLanguage:13 withName:@"Assembler (nasm-2.07)"];
        [self saveLanguage:45 withName:@"Assembler (gcc-4.7.2)"];
        [self saveLanguage:104 withName:@"AWK (gawk)"];
        [self saveLanguage:105 withName:@"AWK (mawk)"];
        [self saveLanguage:28 withName:@"Bash"];
        [self saveLanguage:110 withName:@"bc"];
        [self saveLanguage:12 withName:@"Brainf**k"];
        [self saveLanguage:11 withName:@"C"];
        [self saveLanguage:27 withName:@"C#"];
        [self saveLanguage:1 withName:@"C++"];
        [self saveLanguage:44 withName:@"C++ 11"];
        [self saveLanguage:34 withName:@"C99"];
        [self saveLanguage:14 withName:@"CLIPS"];
        [self saveLanguage:111 withName:@"Clojure"];
        [self saveLanguage:118 withName:@"COBOL"];
        [self saveLanguage:106 withName:@"COBOL 85"];
        [self saveLanguage:32 withName:@"Common Lisp (clisp)"];
        [self saveLanguage:102 withName:@"D (dmd)"];
        [self saveLanguage:36 withName:@"Erlang"];
        [self saveLanguage:124 withName:@"F#"];
        [self saveLanguage:123 withName:@"Factor"];
        [self saveLanguage:125 withName:@"Falcon"];
        [self saveLanguage:107 withName:@"Forth"];
        [self saveLanguage:5 withName:@"Fortran"];
        [self saveLanguage:114 withName:@"Go"];
        [self saveLanguage:121 withName:@"Groovy"];
        [self saveLanguage:21 withName:@"Haskell"];
        [self saveLanguage:16 withName:@"Icon"];
        [self saveLanguage:9 withName:@"Intercal"];
        [self saveLanguage:10 withName:@"Java"];
        [self saveLanguage:55 withName:@"Java 7"];
        [self saveLanguage:35 withName:@"JavaScript (rhino)"];
        [self saveLanguage:112 withName:@"JavaScript (spidermonkey)"];
        [self saveLanguage:26 withName:@"Lua"];
        [self saveLanguage:30 withName:@"Nemerle"];
        [self saveLanguage:25 withName:@"Nice"];
        [self saveLanguage:122 withName:@"Nimrod"];
        [self saveLanguage:56 withName:@"Node.js"];
        [self saveLanguage:43 withName:@"Objective-C"];
        [self saveLanguage:8 withName:@"Ocaml"];
        [self saveLanguage:127 withName:@"Octave"];
        [self saveLanguage:119 withName:@"Oz"];
        [self saveLanguage:57 withName:@"PARI/GP"];
        [self saveLanguage:22 withName:@"Pascal (fpc)"];
        [self saveLanguage:2 withName:@"Pascal (gpc)"];
        [self saveLanguage:3 withName:@"Perl"];
        [self saveLanguage:54 withName:@"Perl 6"];
        [self saveLanguage:29 withName:@"PHP"];
        [self saveLanguage:19 withName:@"Pike"];
        [self saveLanguage:108 withName:@"Prolog (gnu)"];
        [self saveLanguage:15 withName:@"Prolog (swi)"];
        [self saveLanguage:4 withName:@"Python"];
        [self saveLanguage:116 withName:@"Python 3"];
        [self saveLanguage:117 withName:@"R"];
        [self saveLanguage:17 withName:@"Ruby"];
        [self saveLanguage:39 withName:@"Scala"];
        [self saveLanguage:33 withName:@"Scheme (guile)"];
        [self saveLanguage:23 withName:@"Smalltalk"];
        [self saveLanguage:40 withName:@"SQL"];
        [self saveLanguage:38 withName:@"Tcl"];
        [self saveLanguage:62 withName:@"Text"];
        [self saveLanguage:115 withName:@"Unlambda"];
        [self saveLanguage:101 withName:@"VB.NET"];
        [self saveLanguage:6 withName:@"Whitespace"];
    }
}

-(void) saveLanguage:(int)language withName:(NSString*)name{
    NSString* sql = [NSString stringWithFormat: @"INSERT INTO %@ (%@, %@) VALUES (%d, ?)", T_LANGS, F_LANG, F_NAME, language];

    const char *insert_stmt = [sql UTF8String];
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(buildAnywhereDb, insert_stmt, -1, &statement, NULL) == SQLITE_OK){
        sqlite3_bind_text(statement, 1, [name cStringUsingEncoding:NSUTF8StringEncoding], -1, SQLITE_TRANSIENT);
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"Added language: %@", name);
        } else {
            NSLog(@"Failed to save language %@", name);
            NSLog(@"Info:%s", sqlite3_errmsg(buildAnywhereDb));
        }
    }
    sqlite3_finalize(statement);
}

-(void) initQuickSymbols{
    if ([self loadQuickSymbol:0]){
        return;
    }
    
    NSMutableDictionary* symbols = [[NSMutableDictionary alloc] init];
    [symbols setObject:@"{" forKey:@"{"];
    [symbols setObject:@"}" forKey:@"}"];
    [symbols setObject:@"(" forKey:@"("];
    [symbols setObject:@")" forKey:@")"];
    [symbols setObject:@"[" forKey:@"["];
    [symbols setObject:@"]" forKey:@"]"];
    [symbols setObject:@"<" forKey:@"<"];
    [symbols setObject:@">" forKey:@">"];
    [symbols setObject:@";" forKey:@";"];
    [symbols setObject:@"@" forKey:@" @"]; // workaround
    [symbols setObject:@"-" forKey:@"-"];
    [symbols setObject:@"=" forKey:@"="];
    [symbols setObject:@"$" forKey:@"$"];
    [symbols setObject:@"*" forKey:@"*"];
    [symbols setObject:@"_" forKey:@"_"];
    [symbols setObject:@":" forKey:@":"];
    //[symbols setObject:@"" forKey:@""];

    for (int i = 0; i < symbols.count; i++) {
        NSString* key = [symbols.allKeys objectAtIndex:i];
        [self saveQuickSymbol:[[QuickSymbol alloc] initWithId:i title:key content:[symbols valueForKey:key]]];
    }
}

-(void) saveQuickSymbol:(QuickSymbol*)symbol{
    if ([self loadQuickSymbol:symbol.symbId]){
        return;
    }
    
    NSString* sql = [NSString stringWithFormat: @"INSERT INTO %@ (%@, %@, %@) VALUES (%d, ?, ?)", T_SYMBOLS, F_SYMB_ID, F_NAME, F_CODE, symbol.symbId];
    const char *insert_stmt = [sql UTF8String];
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(buildAnywhereDb, insert_stmt, -1, &statement, NULL) == SQLITE_OK){
        sqlite3_bind_text(statement, 1, [symbol.symbTitle cStringUsingEncoding:NSUTF8StringEncoding], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 2, [symbol.symbContent cStringUsingEncoding:NSUTF8StringEncoding], -1, SQLITE_TRANSIENT);
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"Symbol inserted");
        } else {
            NSLog(@"Failed to save symbol");
            NSLog(@"Info:%s", sqlite3_errmsg(buildAnywhereDb));
        }
    }
    sqlite3_finalize(statement);
}

// public methods
-(NSDictionary*) getLanguages{ // key: name, value:language
    NSString *querySQL = [NSString stringWithFormat: @"SELECT %@, %@ FROM %@", F_NAME, F_LANG, T_LANGS];
    const char *query_stmt = [querySQL UTF8String];
    
    NSMutableDictionary* result = [[NSMutableDictionary alloc] init];
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(buildAnywhereDb, query_stmt, -1, &statement, NULL) == SQLITE_OK){
        while (sqlite3_step(statement) == SQLITE_ROW){
            NSString *nameField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
            int language = sqlite3_column_int(statement, 1);
            
            [result setObject:[NSNumber numberWithInt:language] forKey:nameField];
        }
    }
    sqlite3_finalize(statement);
    
    return [[NSDictionary alloc] initWithDictionary:result];
}

-(NSString*) getLanguageName:(int)language{
    NSString *querySQL = [NSString stringWithFormat: @"SELECT %@ FROM %@ WHERE %@=%d", F_NAME, T_LANGS, F_LANG, language];
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
        sql = [NSString stringWithFormat: @"UPDATE %@ SET %@ = ?, %@ = %d, %@ = ?, %@ = ?, %@ = ? WHERE %@ =%d", T_PROJECTS, F_NAME, F_LANG, project.projLanguage, F_CODE, F_LINK, F_INPUT, F_ID, exists.projId];
        logMsg = @"Project updated";
    } else { // doesnt exist so insert
        sql = [NSString stringWithFormat: @"INSERT INTO %@ (%@, %@, %@, %@, %@) VALUES (?, %d, ?, ?, ?)", T_PROJECTS, F_NAME, F_LANG, F_CODE, F_LINK, F_INPUT, project.projLanguage];
        logMsg = @"Project inserted";
    }
    const char *insert_stmt = [sql UTF8String];
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(buildAnywhereDb, insert_stmt, -1, &statement, NULL) == SQLITE_OK){
        sqlite3_bind_text(statement, 1, [project.projName cStringUsingEncoding:NSUTF8StringEncoding], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 2, [project.projCode cStringUsingEncoding:NSUTF8StringEncoding], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 3, [project.projLink cStringUsingEncoding:NSUTF8StringEncoding], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 4, [project.projInput cStringUsingEncoding:NSUTF8StringEncoding], -1, SQLITE_TRANSIENT);
        
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

-(QuickSymbol*) loadQuickSymbol:(int)iD{
    NSString *querySQL = [NSString stringWithFormat: @"SELECT %@, %@ FROM %@ WHERE %@=%d", F_NAME, F_CODE, T_SYMBOLS, F_SYMB_ID, iD];
    const char *query_stmt = [querySQL UTF8String];
    
    QuickSymbol* symbol = nil;
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(buildAnywhereDb, query_stmt, -1, &statement, NULL) == SQLITE_OK){
        if (sqlite3_step(statement) == SQLITE_ROW){
            NSString *titleField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
            
            NSString *contentField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
            
            symbol = [[QuickSymbol alloc] initWithId:iD title:titleField content:contentField];
        } else {
            NSLog(@"Quick symbol not found in the database");
        }
    }
    sqlite3_finalize(statement);
    
    return symbol;
}

-(Project*) loadProject:(NSString*)name{
    NSString *querySQL = [NSString stringWithFormat: @"SELECT %@, %@, %@, %@, %@ FROM %@ WHERE %@=?", F_ID, F_LANG, F_CODE, F_LINK, F_INPUT, T_PROJECTS, F_NAME];
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
            
            NSString *inputField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
            
            project = [[Project alloc] initWithLanguage:language name:name];
            [project setId:iD];
            [project setCode:codeField];
            [project setLink:linkField];
            [project setInput:inputField];
        } else {
            NSLog(@"Project not found in the database");
        }
    } else {
        NSLog(@"Failed to load project");
        NSLog(@"Info:%s", sqlite3_errmsg(buildAnywhereDb));
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

-(NSDictionary*) getProjectsBasicInfo{ // key: name, value:language
    NSString *querySQL = [NSString stringWithFormat: @"SELECT %@, %@ FROM %@", F_NAME, F_LANG, T_PROJECTS];
    const char *query_stmt = [querySQL UTF8String];
    
    NSMutableDictionary* result = [[NSMutableDictionary alloc] init];
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(buildAnywhereDb, query_stmt, -1, &statement, NULL) == SQLITE_OK){
        while (sqlite3_step(statement) == SQLITE_ROW){
            NSString *nameField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
            int language = sqlite3_column_int(statement, 1);
            
            [result setObject:[NSNumber numberWithInt:language] forKey:nameField];
        }
    }
    sqlite3_finalize(statement);
    
    return [[NSDictionary alloc] initWithDictionary:result];
}

-(NSArray*) getSnippetNamesForLanguage:(int)lang{
    NSString *querySQL = [NSString stringWithFormat: @"SELECT %@ FROM %@ WHERE %@=%d", F_NAME, T_SNIPPETS, F_LANG, lang];
    const char *query_stmt = [querySQL UTF8String];
    
    NSMutableArray* result = [[NSMutableArray alloc] init];
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(buildAnywhereDb, query_stmt, -1, &statement, NULL) == SQLITE_OK){
        while (sqlite3_step(statement) == SQLITE_ROW){
            NSString *nameField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
            [result addObject:nameField];
        }
    }
    sqlite3_finalize(statement);
    
    return [[NSArray alloc] initWithArray:result];
}

-(NSArray*) getQuickSymbols{
    NSString *querySQL = [NSString stringWithFormat: @"SELECT %@, %@, %@ FROM %@ ORDER BY %@", F_SYMB_ID, F_NAME, F_CODE, T_SYMBOLS, F_SYMB_ID];
    const char *query_stmt = [querySQL UTF8String];
    
    NSMutableArray* result = [[NSMutableArray alloc] init];
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(buildAnywhereDb, query_stmt, -1, &statement, NULL) == SQLITE_OK){
        while (sqlite3_step(statement) == SQLITE_ROW){
            int iD = sqlite3_column_int(statement, 0);
            
            NSString *titleField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
            
            NSString *contentField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
            
            [result addObject:[[QuickSymbol alloc] initWithId:iD title:titleField content:contentField]];
        }
    }
    sqlite3_finalize(statement);
    
    return [[NSArray alloc] initWithArray:result];

}

@end
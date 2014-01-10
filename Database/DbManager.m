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
#import "LangDefinition.h"
#import "SourceCodeDefinition.h"

@implementation DbManager{
    sqlite3 *buildAnywhereDb;
}

-(id) init{
    self = [super init];
    if (self){
        [self initDatabase];
        [self initLanguages];
        [self initCodeSamples];
        [self initBaseQuickSymbols];
    }
    return self;
}

-(void) open{
    [self initDatabase];
}

-(void) close{
    sqlite3_close(buildAnywhereDb);
}

-(BOOL)column:(NSString*)column existInTable:(NSString*)table{
    NSString *querySQL = [NSString stringWithFormat:@"PRAGMA table_info(%@)", table];
    const char *query_stmt = [querySQL UTF8String];
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(buildAnywhereDb, query_stmt, -1, &statement, NULL) == SQLITE_OK){
        if (sqlite3_step(statement) == SQLITE_ROW){
            int columnsCount = sqlite3_column_count(statement);
            for (int i = 0; i < columnsCount; i++){
                NSString *columnName = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_name(statement, i)];
                if ([column isEqualToString:columnName]){
                    return YES;
                }
            }
        }
    }
    sqlite3_finalize(statement);
    
    return NO;
}

-(BOOL)addColumn:(NSString*)column ofType:(NSString*)type toTable:(NSString*)table{
    if ([self column:column existInTable:table]){
        return NO;
    }
    
    BOOL result = YES;
    NSString *sql = [NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUMN %@ %@", table, column, type];
    const char *insert_stmt = [sql UTF8String];
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(buildAnywhereDb, insert_stmt, -1, &statement, NULL) == SQLITE_OK){
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"Column '%@ %@' added to table '%@'", type, column, table);
        } else {
            NSLog(@"Failed to add column to table");
            NSLog(@"Info:%s", sqlite3_errmsg(buildAnywhereDb));
            result = NO;
        }
    }
    sqlite3_finalize(statement);
    
    return result;
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
        if (sqlite3_exec(buildAnywhereDb, sql, NULL, NULL, &errMsg) == SQLITE_OK)
        {
        } else {
            NSLog(@"Error creating DB table(s)");
            NSLog(@"Info:%s", sqlite3_errmsg(buildAnywhereDb));
        }
    } else {
        NSLog(@"Failed to open database");
        NSLog(@"Info:%s", sqlite3_errmsg(buildAnywhereDb));
    }
}

-(void) initLanguages{
    if ([self getLanguageName:LANG_ADA].length == 0){
        [self saveLanguage:LANG_ADA withName:@"Ada"];
        [self saveLanguage:LANG_ASM_NASM207 withName:@"Assembler (nasm-2.07)"];
        [self saveLanguage:LANG_ASM_GCC472 withName:@"Assembler (gcc-4.7.2)"];
        [self saveLanguage:LANG_AWK_GAWK withName:@"AWK (gawk)"];
        [self saveLanguage:LANG_AWK_MAWK withName:@"AWK (mawk)"];
        [self saveLanguage:LANG_BASH withName:@"Bash"];
        [self saveLanguage:LANG_BC withName:@"bc"];
        [self saveLanguage:LANG_BRAINFUCK withName:@"Brainf**k"];
        [self saveLanguage:LANG_C withName:@"C"];
        [self saveLanguage:LANG_C_SHARP withName:@"C#"];
        [self saveLanguage:LANG_CPP_481 withName:@"C++ (gcc 4.8.1)"];
        [self saveLanguage:LANG_CPP11 withName:@"C++ 11"];
        [self saveLanguage:LANG_C99 withName:@"C99"];
        [self saveLanguage:LANG_CLIPS withName:@"CLIPS"];
        [self saveLanguage:LANG_CLOJURE withName:@"Clojure"];
        [self saveLanguage:LANG_COBOL withName:@"COBOL"];
        [self saveLanguage:LANG_COBOL85 withName:@"COBOL 85"];
        [self saveLanguage:LANG_CLISP withName:@"Common Lisp (clisp)"];
        [self saveLanguage:LANG_D_DMD withName:@"D (dmd)"];
        [self saveLanguage:LANG_ERLANG withName:@"Erlang"];
        [self saveLanguage:LANG_F_SHARP withName:@"F#"];
        [self saveLanguage:LANG_FACTOR withName:@"Factor"];
        [self saveLanguage:LANG_FALCON withName:@"Falcon"];
        [self saveLanguage:LANG_FORTH withName:@"Forth"];
        [self saveLanguage:LANG_FORTRAN withName:@"Fortran"];
        [self saveLanguage:LANG_GO withName:@"Go"];
        [self saveLanguage:LANG_GROOVY withName:@"Groovy"];
        [self saveLanguage:LANG_HASKELL withName:@"Haskell"];
        [self saveLanguage:LANG_ICON withName:@"Icon"];
        [self saveLanguage:LANG_INTERCAL withName:@"Intercal"];
        [self saveLanguage:LANG_JAVA withName:@"Java"];
        [self saveLanguage:LANG_JAVA7 withName:@"Java 7"];
        [self saveLanguage:LANG_JAVASCRIPT_RHINO withName:@"JavaScript (rhino)"];
        [self saveLanguage:LANG_JAVASCRIPT_SPIDER withName:@"JavaScript (spidermonkey)"];
        [self saveLanguage:LANG_LUA withName:@"Lua"];
        [self saveLanguage:LANG_NEMERLE withName:@"Nemerle"];
        [self saveLanguage:LANG_NICE withName:@"Nice"];
        [self saveLanguage:LANG_NIMROD withName:@"Nimrod"];
        [self saveLanguage:LANG_NODE_JS withName:@"Node.js"];
        [self saveLanguage:LANG_OBJ_C withName:@"Objective-C"];
        [self saveLanguage:LANG_OCAML withName:@"Ocaml"];
        [self saveLanguage:LANG_OCTAVE withName:@"Octave"];
        [self saveLanguage:LANG_OZ withName:@"Oz"];
        [self saveLanguage:LANG_PARI_GP withName:@"PARI/GP"];
        [self saveLanguage:LANG_PASCAL_FPC withName:@"Pascal (fpc)"];
        [self saveLanguage:LANG_PASCAL_GPC withName:@"Pascal (gpc)"];
        [self saveLanguage:LANG_PERL withName:@"Perl"];
        [self saveLanguage:LANG_PERL_6 withName:@"Perl 6"];
        [self saveLanguage:LANG_PHP withName:@"PHP"];
        [self saveLanguage:LANG_PIKE withName:@"Pike"];
        [self saveLanguage:LANG_PROLOG_GNU withName:@"Prolog (gnu)"];
        [self saveLanguage:LANG_PROlOG_SWI withName:@"Prolog (swi)"];
        [self saveLanguage:LANG_PYTHON withName:@"Python"];
        [self saveLanguage:LANG_PYTHON3 withName:@"Python 3"];
        [self saveLanguage:LANG_R withName:@"R"];
        [self saveLanguage:LANG_RUBY withName:@"Ruby"];
        [self saveLanguage:LANG_SCALA withName:@"Scala"];
        [self saveLanguage:LANG_SCHEME withName:@"Scheme (guile)"];
        [self saveLanguage:LANG_SMALLTALK withName:@"Smalltalk"];
        [self saveLanguage:LANG_SQL withName:@"SQL"];
        [self saveLanguage:LANG_TCL withName:@"Tcl"];
        [self saveLanguage:LANG_TEXT withName:@"Text"];
        [self saveLanguage:LANG_UNLAMBDA withName:@"Unlambda"];
        [self saveLanguage:LANG_VB_NET withName:@"VB.NET"];
        [self saveLanguage:LANG_WHITESPACE withName:@"Whitespace"];
    }
    
    // should be checked separately
    if ([self getLanguageName:LANG_CPP_432].length == 0){
        [self saveLanguage:LANG_CPP_432 withName:@"C++ (gcc 4.3.2)"];
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

-(void) initBaseQuickSymbols{
    if ([UserSettings getBaseSymbolsInitialized] || [self getSymbolsCount] > 0){
        [UserSettings setBaseSymbolsInitialized];
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
    [symbols setObject:@"#" forKey:@"#"];
    [symbols setObject:@"*" forKey:@"*"];
    [symbols setObject:@"_" forKey:@"_"];
    [symbols setObject:@":" forKey:@":"];
    [symbols setObject:@"&" forKey:@"&"];
    [symbols setObject:@"." forKey:@"."];
    //[symbols setObject:@"" forKey:@""];

    for (int i = 0; i < symbols.count; i++) {
        NSString* key = [symbols.allKeys objectAtIndex:i];
        [self saveQuickSymbol:[[QuickSymbol alloc] initWithId:i title:key content:[symbols valueForKey:key]]];
    }
    
    [UserSettings setBaseSymbolsInitialized];
}

-(int) createQuickSymbol:(NSString*)symbol{
    int newId = [self getMaxSymbolId] + 1;
    if (newId == 0){
        return -1;
    }
    QuickSymbol* newSymb = [[QuickSymbol alloc] initWithId:newId title:symbol content:symbol];
    return [self saveQuickSymbol:newSymb] ? newId : -1;
}

-(BOOL) saveQuickSymbol:(QuickSymbol*)symbol{
    if ([self loadQuickSymbol:symbol.symbId]){
        return NO;
    }
    
    NSString* sql = [NSString stringWithFormat: @"INSERT INTO %@ (%@, %@, %@) VALUES (%d, ?, ?)", T_SYMBOLS, F_SYMB_ID, F_NAME, F_CODE, symbol.symbId];
    const char *insert_stmt = [sql UTF8String];
    
    BOOL errCode = NO;
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(buildAnywhereDb, insert_stmt, -1, &statement, NULL) == SQLITE_OK){
        sqlite3_bind_text(statement, 1, [symbol.symbTitle cStringUsingEncoding:NSUTF8StringEncoding], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 2, [symbol.symbContent cStringUsingEncoding:NSUTF8StringEncoding], -1, SQLITE_TRANSIENT);
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"Symbol inserted");
            errCode = YES;
        } else {
            NSLog(@"Failed to save symbol");
            NSLog(@"Info:%s", sqlite3_errmsg(buildAnywhereDb));
        }
    }
    sqlite3_finalize(statement);
    
    return errCode;
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

-(void) deleteQuickSymbol:(int)iD{
    NSString *deleteSQL = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@=%d", T_SYMBOLS, F_SYMB_ID, iD];
    const char *delete_stmt = [deleteSQL UTF8String];
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(buildAnywhereDb, delete_stmt, -1, &statement, NULL) == SQLITE_OK){
        if (sqlite3_step(statement) == SQLITE_DONE){
        } else {
            NSLog(@"Error deleting symbol from database");
            NSLog(@"Info:%s", sqlite3_errmsg(buildAnywhereDb));
        }
    }
    sqlite3_finalize(statement);
}

-(void) deleteSnippet:(NSString*)name language:(int)lang{
    NSString *deleteSQL = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = ? AND %@=%d", T_SNIPPETS, F_NAME, F_LANG, lang];
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

-(NSDictionary*) getBasicInfosForEntity:(EntityType)entity{ // key: name, value:language
    NSString *table = entity == ENTITY_PROJECT ? T_PROJECTS : T_SNIPPETS;
    NSString *querySQL = [NSString stringWithFormat: @"SELECT %@, %@ FROM %@", F_NAME, F_LANG, table];
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

-(void) putQuickSymbol:(int)symbId toLanguageUsage:(int)lang atIndex:(int)index{
    int symbolsForLang = [self getSymbolsCountForLanguage:lang];
    int indexToPutAt = MAX(0, MIN(index, symbolsForLang));
    int currentOrder = [self getOrderIndexForSymbolId:symbId forLaguageUsage:lang];
    
    if (indexToPutAt == currentOrder){
        return;
    }
    
    NSMutableArray* queries = [[NSMutableArray alloc] initWithObjects:@"begin;", nil];
    
    if (currentOrder == -1){ // inserting new symbol to order
        if (symbolsForLang > indexToPutAt){
            [queries addObject: [NSString stringWithFormat:@"UPDATE %@ SET %@=%@+1 WHERE %@=%d AND %@>=%d;", T_SYMBOLS_ORDER, F_SYMB_ORDER, F_SYMB_ORDER, F_LANG, lang, F_SYMB_ORDER, indexToPutAt]];
        }
        [queries addObject:[NSString stringWithFormat:@"INSERT INTO %@ (%@, %@, %@) VALUES (%d, %d, %d);", T_SYMBOLS_ORDER, F_SYMB_ID, F_LANG, F_SYMB_ORDER, symbId, lang, indexToPutAt]];
    } else { // 'moving' symbol inside table
        if (indexToPutAt > currentOrder){ // moving symbol down
            [queries addObject: [NSString stringWithFormat:@"UPDATE %@ SET %@=%@-1 WHERE %@=%d AND %@>%d AND %@<=%d;", T_SYMBOLS_ORDER, F_SYMB_ORDER, F_SYMB_ORDER, F_LANG, lang, F_SYMB_ORDER, currentOrder, F_SYMB_ORDER, indexToPutAt]];
        } else { // moving symbol up
            [queries addObject: [NSString stringWithFormat:@"UPDATE %@ SET %@=%@+1 WHERE %@=%d AND %@>=%d AND %@<%d;", T_SYMBOLS_ORDER, F_SYMB_ORDER, F_SYMB_ORDER, F_LANG, lang, F_SYMB_ORDER, indexToPutAt, F_SYMB_ORDER, currentOrder]];
        }
        
        [queries addObject: [NSString stringWithFormat:@"UPDATE %@ SET %@=%d WHERE %@=%d AND %@=%d;", T_SYMBOLS_ORDER, F_SYMB_ORDER, indexToPutAt, F_LANG, lang, F_SYMB_ID, symbId]];
    }
    
    [queries addObject:@"commit;"];
    
    for (NSString* query in queries) {
        const char *query_stmt = [query UTF8String];
        sqlite3_exec(buildAnywhereDb, query_stmt, NULL, NULL, NULL);
    }
}

-(void)removeQuickSymbol:(int)iD fomLanguageUsage:(int)lang{
    int currentOrder = [self getOrderIndexForSymbolId:iD forLaguageUsage:lang];
    
    if (currentOrder < 0){
        return;
    }
    
    NSMutableArray* queries = [[NSMutableArray alloc] initWithObjects:@"begin;", nil];
    
    [queries addObject: [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@=%d AND %@=%d;", T_SYMBOLS_ORDER, F_SYMB_ID, iD, F_LANG, lang]];
    [queries addObject: [NSString stringWithFormat:@"UPDATE %@ SET %@=%@-1 WHERE %@=%d AND %@>%d;", T_SYMBOLS_ORDER, F_SYMB_ORDER, F_SYMB_ORDER, F_LANG, lang, F_SYMB_ORDER, currentOrder]];
    
    [queries addObject:@"commit;"];
    
    for (NSString* query in queries) {
        const char *query_stmt = [query UTF8String];
        sqlite3_exec(buildAnywhereDb, query_stmt, NULL, NULL, NULL);
    }
}

-(NSArray*) getQuickSymbols{
    NSString *querySQL = [NSString stringWithFormat: @"SELECT %@, %@, %@ FROM %@", F_SYMB_ID, F_NAME, F_CODE, T_SYMBOLS];
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

-(NSDictionary*) getQuickSymbolsDictionary{
    NSString *querySQL = [NSString stringWithFormat: @"SELECT %@, %@, %@ FROM %@", F_SYMB_ID, F_NAME, F_CODE, T_SYMBOLS];
    const char *query_stmt = [querySQL UTF8String];
    
    NSMutableDictionary* result = [[NSMutableDictionary alloc] init];
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(buildAnywhereDb, query_stmt, -1, &statement, NULL) == SQLITE_OK){
        while (sqlite3_step(statement) == SQLITE_ROW){
            int iD = sqlite3_column_int(statement, 0);
            
            NSString *titleField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
            
            NSString *contentField = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
            
            [result setObject:[[QuickSymbol alloc] initWithId:iD title:titleField content:contentField] forKey:[NSNumber numberWithInt:iD]];
        }
    }
    sqlite3_finalize(statement);
    
    return [[NSDictionary alloc] initWithDictionary:result];
}

-(NSDictionary*)getOrderedSymbolIDsForLanguage:(int)lang{
    NSString *querySQL = [NSString stringWithFormat: @"SELECT %@, %@ FROM %@ WHERE %@=%d ORDER BY %@ ASC", F_SYMB_ID, F_SYMB_ORDER, T_SYMBOLS_ORDER, F_LANG, lang, F_SYMB_ORDER];
    const char *query_stmt = [querySQL UTF8String];
    
    NSMutableDictionary* result = [[NSMutableDictionary alloc] init];
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(buildAnywhereDb, query_stmt, -1, &statement, NULL) == SQLITE_OK){
        while (sqlite3_step(statement) == SQLITE_ROW){
            NSNumber *iD = [NSNumber numberWithInt:sqlite3_column_int(statement, 0)];
            NSNumber *order = [NSNumber numberWithInt:sqlite3_column_int(statement, 1)];
            [result setObject:iD forKey:order];
        }
    }  else {
        NSLog(@"Failed to prepare query");
        NSLog(@"Info:%s", sqlite3_errmsg(buildAnywhereDb));
    }
    sqlite3_finalize(statement);
    
    return result;
}

-(int) getSymbolsCount{
    NSString *querySQL = [NSString stringWithFormat: @"SELECT COUNT(%@) FROM %@", F_ID, T_SYMBOLS];
    const char *query_stmt = [querySQL UTF8String];
    
    int result = 0;
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(buildAnywhereDb, query_stmt, -1, &statement, NULL) == SQLITE_OK){
        if (sqlite3_step(statement) == SQLITE_ROW){
            result = sqlite3_column_int(statement, 0);
        }
    }
    sqlite3_finalize(statement);
    
    return result;
}

-(NSArray*) getLanguagesSymbolUsedFor:(int)iD{
    NSString *querySQL = [NSString stringWithFormat: @"SELECT %@ FROM %@ WHERE %@=%d", F_LANG, T_SYMBOLS_ORDER, F_SYMB_ID, iD];
    const char *query_stmt = [querySQL UTF8String];
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(buildAnywhereDb, query_stmt, -1, &statement, NULL) == SQLITE_OK){
        while (sqlite3_step(statement) == SQLITE_ROW){
            [result addObject:[NSNumber numberWithInt:sqlite3_column_int(statement, 0)]];
        }
    }
    sqlite3_finalize(statement);
    
    return result;
}

// private methods
-(int) getOrderIndexForSymbolId:(int)iD forLaguageUsage:(int)lang{
    NSString *querySQL = [NSString stringWithFormat: @"SELECT %@ FROM %@ WHERE %@=%d AND %@=%d", F_SYMB_ORDER, T_SYMBOLS_ORDER, F_SYMB_ID, iD, F_LANG, lang];
    const char *query_stmt = [querySQL UTF8String];
    
    int result = -1;
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(buildAnywhereDb, query_stmt, -1, &statement, NULL) == SQLITE_OK){
        if (sqlite3_step(statement) == SQLITE_ROW){
            result = sqlite3_column_int(statement, 0);
        }
    }
    sqlite3_finalize(statement);
    
    return result;
}

-(int) getSymbolsCountForLanguage:(int)lang{
    NSString *querySQL = [NSString stringWithFormat: @"SELECT COUNT(%@) FROM %@ WHERE %@=%d", F_ID, T_SYMBOLS_ORDER, F_LANG, lang];
    const char *query_stmt = [querySQL UTF8String];
    
    int result = 0;
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(buildAnywhereDb, query_stmt, -1, &statement, NULL) == SQLITE_OK){
        if (sqlite3_step(statement) == SQLITE_ROW){
            result = sqlite3_column_int(statement, 0);
        }
    }
    sqlite3_finalize(statement);
    
    return result;
}

-(int) getMaxSymbolId{
    NSString *querySQL = [NSString stringWithFormat: @"SELECT MAX(%@) FROM %@", F_ID, T_SYMBOLS];
    const char *query_stmt = [querySQL UTF8String];
    
    int result = 0;
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(buildAnywhereDb, query_stmt, -1, &statement, NULL) == SQLITE_OK){
        if (sqlite3_step(statement) == SQLITE_ROW){
            result = sqlite3_column_int(statement, 0);
        }
    }
    sqlite3_finalize(statement);
    
    return result;
}

-(void)initCodeSamples{
    if (![UserSettings getCodeSamplesInitialized]){
        NSString *sampleName = @"code template";
        [self saveSnippet:[[Snippet alloc] initWithLanguage:LANG_ADA name:sampleName code:TEMPL_ADA]];
        [self saveSnippet:[[Snippet alloc] initWithLanguage:LANG_ASM_NASM207 name:sampleName code:TEMPL_ASM_NASM207]];
        [self saveSnippet:[[Snippet alloc] initWithLanguage:LANG_ASM_GCC472 name:sampleName code:TEMPL_ASM_GCC472]];
        [self saveSnippet:[[Snippet alloc] initWithLanguage:LANG_AWK_GAWK name:sampleName code:TEMPL_AWK_GAWK]];
        [self saveSnippet:[[Snippet alloc] initWithLanguage:LANG_AWK_MAWK name:sampleName code:TEMPL_AWK_MAWK]];
        [self saveSnippet:[[Snippet alloc] initWithLanguage:LANG_BASH name:sampleName code:TEMPL_BASH]];
        //[self saveSnippet:[[Snippet alloc] initWithLanguage:LANG_BC name:sampleName code:TEMPL_BC]];
        //[self saveSnippet:[[Snippet alloc] initWithLanguage:LANG_BRAINFUCK name:sampleName code:TEMPL_BRAINFUCK]];
        [self saveSnippet:[[Snippet alloc] initWithLanguage:LANG_C name:sampleName code:TEMPL_C]];
        [self saveSnippet:[[Snippet alloc] initWithLanguage:LANG_C_SHARP name:sampleName code:TEMPL_C_SHARP]];
        [self saveSnippet:[[Snippet alloc] initWithLanguage:LANG_CPP_432 name:sampleName code:TEMPL_CPP_432]];
        [self saveSnippet:[[Snippet alloc] initWithLanguage:LANG_CPP_481 name:sampleName code:TEMPL_CPP_481]];
        [self saveSnippet:[[Snippet alloc] initWithLanguage:LANG_CPP11 name:sampleName code:TEMPL_CPP11]];
        [self saveSnippet:[[Snippet alloc] initWithLanguage:LANG_CLIPS name:sampleName code:TEMPL_CLIPS]];
        //[self saveSnippet:[[Snippet alloc] initWithLanguage:LANG_CLOJURE name:sampleName code:TEMPL_CLOJURE]];
        [self saveSnippet:[[Snippet alloc] initWithLanguage:LANG_COBOL name:sampleName code:TEMPL_COBOL]];
        [self saveSnippet:[[Snippet alloc] initWithLanguage:LANG_COBOL85 name:sampleName code:TEMPL_COBOL85]];
        [self saveSnippet:[[Snippet alloc] initWithLanguage:LANG_CLISP name:sampleName code:TEMPL_CLISP]];
        //[self saveSnippet:[[Snippet alloc] initWithLanguage:LANG_D_DMD name:sampleName code:TEMPL_D_DMD]];
        [self saveSnippet:[[Snippet alloc] initWithLanguage:LANG_ERLANG name:sampleName code:TEMPL_ERLANG]];
        [self saveSnippet:[[Snippet alloc] initWithLanguage:LANG_F_SHARP name:sampleName code:TEMPL_F_SHARP]];
        [self saveSnippet:[[Snippet alloc] initWithLanguage:LANG_FACTOR name:sampleName code:TEMPL_FACTOR]];
        //[self saveSnippet:[[Snippet alloc] initWithLanguage:LANG_FALCON name:sampleName code:TEMPL_FALCON]];
        //[self saveSnippet:[[Snippet alloc] initWithLanguage:LANG_FORTH name:sampleName code:TEMPL_FORTH]];
        [self saveSnippet:[[Snippet alloc] initWithLanguage:LANG_FORTRAN name:sampleName code:TEMPL_FORTRAN]];
        [self saveSnippet:[[Snippet alloc] initWithLanguage:LANG_GO name:sampleName code:TEMPL_GO]];
        //[self saveSnippet:[[Snippet alloc] initWithLanguage:LANG_GROOVY name:sampleName code:TEMPL_GROOVY]];
        [self saveSnippet:[[Snippet alloc] initWithLanguage:LANG_HASKELL name:sampleName code:TEMPL_HASKELL]];
        [self saveSnippet:[[Snippet alloc] initWithLanguage:LANG_ICON name:sampleName code:TEMPL_ICON]];
        [self saveSnippet:[[Snippet alloc] initWithLanguage:LANG_INTERCAL name:sampleName code:TEMPL_INTERCAL]];
        [self saveSnippet:[[Snippet alloc] initWithLanguage:LANG_JAVA name:sampleName code:TEMPL_JAVA]];
        [self saveSnippet:[[Snippet alloc] initWithLanguage:LANG_JAVA7 name:sampleName code:TEMPL_JAVA7]];
        [self saveSnippet:[[Snippet alloc] initWithLanguage:LANG_JAVASCRIPT_RHINO name:sampleName code:TEMPL_JAVASCRIPT_RHINO]];
        //[self saveSnippet:[[Snippet alloc] initWithLanguage:LANG_JAVASCRIPT_SPIDER name:sampleName code:TEMPL_JAVASCRIPT_SPIDER]];
        //[self saveSnippet:[[Snippet alloc] initWithLanguage:LANG_LUA name:sampleName code:TEMPL_LUA]];
        [self saveSnippet:[[Snippet alloc] initWithLanguage:LANG_NEMERLE name:sampleName code:TEMPL_NEMERLE]];
        [self saveSnippet:[[Snippet alloc] initWithLanguage:LANG_NICE name:sampleName code:TEMPL_NICE]];
        //[self saveSnippet:[[Snippet alloc] initWithLanguage:LANG_NIMROD name:sampleName code:TEMPL_NIMROD]];
        [self saveSnippet:[[Snippet alloc] initWithLanguage:LANG_NODE_JS name:sampleName code:TEMPL_NODE_JS]];
        [self saveSnippet:[[Snippet alloc] initWithLanguage:LANG_OBJ_C name:sampleName code:TEMPL_OBJ_C]];
        //[self saveSnippet:[[Snippet alloc] initWithLanguage:LANG_OCAML name:sampleName code:TEMPL_OCAML]];
        //[self saveSnippet:[[Snippet alloc] initWithLanguage:LANG_OCTAVE name:sampleName code:TEMPL_OCTAVE]];
        [self saveSnippet:[[Snippet alloc] initWithLanguage:LANG_OZ name:sampleName code:TEMPL_OZ]];
        //[self saveSnippet:[[Snippet alloc] initWithLanguage:LANG_PARI_GP name:sampleName code:TEMPL_PARI_GP]];
        [self saveSnippet:[[Snippet alloc] initWithLanguage:LANG_PASCAL_FPC name:sampleName code:TEMPL_PASCAL_FPC]];
        [self saveSnippet:[[Snippet alloc] initWithLanguage:LANG_PASCAL_GPC name:sampleName code:TEMPL_PASCAL_GPC]];
        [self saveSnippet:[[Snippet alloc] initWithLanguage:LANG_PERL name:sampleName code:TEMPL_PERL]];
        [self saveSnippet:[[Snippet alloc] initWithLanguage:LANG_PERL_6 name:sampleName code:TEMPL_PERL_6]];
        [self saveSnippet:[[Snippet alloc] initWithLanguage:LANG_PHP name:sampleName code:TEMPL_PHP]];
        [self saveSnippet:[[Snippet alloc] initWithLanguage:LANG_PIKE name:sampleName code:TEMPL_PIKE]];
        [self saveSnippet:[[Snippet alloc] initWithLanguage:LANG_PROLOG_GNU name:sampleName code:TEMPL_PROLOG_GNU]];
        [self saveSnippet:[[Snippet alloc] initWithLanguage:LANG_PROlOG_SWI name:sampleName code:TEMPL_PROlOG_SWI]];
        //[self saveSnippet:[[Snippet alloc] initWithLanguage:LANG_PYTHON name:sampleName code:TEMPL_PYTHON]];
        //[self saveSnippet:[[Snippet alloc] initWithLanguage:LANG_PYTHON3 name:sampleName code:TEMPL_PYTHON3]];
        //[self saveSnippet:[[Snippet alloc] initWithLanguage:LANG_R name:sampleName code:TEMPL_R]];
        //[self saveSnippet:[[Snippet alloc] initWithLanguage:LANG_RUBY name:sampleName code:TEMPL_RUBY]];
        [self saveSnippet:[[Snippet alloc] initWithLanguage:LANG_SCALA name:sampleName code:TEMPL_SCALA]];
        //[self saveSnippet:[[Snippet alloc] initWithLanguage:LANG_SCHEME name:sampleName code:TEMPL_SCHEME]];
        //[self saveSnippet:[[Snippet alloc] initWithLanguage:LANG_SMALLTALK name:sampleName code:TEMPL_SMALLTALK]];
        //[self saveSnippet:[[Snippet alloc] initWithLanguage:LANG_SQL name:sampleName code:TEMPL_SQL]];
        //[self saveSnippet:[[Snippet alloc] initWithLanguage:LANG_TCL name:sampleName code:TEMPL_TCL]];
        //[self saveSnippet:[[Snippet alloc] initWithLanguage:LANG_TEXT name:sampleName code:TEMPL_TEXT]];
        //[self saveSnippet:[[Snippet alloc] initWithLanguage:LANG_UNLAMBDA name:sampleName code:TEMPL_UNLAMBDA]];
        [self saveSnippet:[[Snippet alloc] initWithLanguage:LANG_VB_NET name:sampleName code:TEMPL_VB_NET]];
        //[self saveSnippet:[[Snippet alloc] initWithLanguage:LANG_WHITESPACE name:sampleName code:TEMPL_WHITESPACE]];
        
        [UserSettings setCodeSamplesInitialized];
    }
}

@end
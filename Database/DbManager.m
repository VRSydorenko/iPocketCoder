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
        [self saveSnippet:[[Snippet alloc] initWithLanguage:7 name:@"sample" code:@"with Ada.Text_IO;\n\nprocedure Hello_World is\n  use Ada.Text_IO;\nbegin\n  Put_Line(\"Hello, world!\");\nend;"]];
         
        [self saveLanguage:13 withName:@"Assembler (nasm-2.07)"];
        [self saveSnippet:[[Snippet alloc] initWithLanguage:13 name:@"template" code:@"global _start\nsection .data\nsection .text\n\n_start:\n    je  exit\n\nexit:\n    mov    eax,  01h\n    xor    ebx,  ebx\n    int    80h"]];
        
        [self saveLanguage:45 withName:@"Assembler (gcc-4.7.2)"];
        [self saveSnippet:[[Snippet alloc] initWithLanguage:45 name:@"sample" code:@".data\nx:\n    .string \"Hello \"\ns:\n    .string \"world!\\n\\0\"\n.text\n.global main\nmain:\n    pushl  $x\n    call  printf\n    pushl  $s\n    call  printf\n    addl  $8,  %esp\n\nbreak:\n    xor  %eax,  %eax\n    ret"]];

        [self saveLanguage:104 withName:@"AWK (gawk)"];
        [self saveSnippet:[[Snippet alloc] initWithLanguage:104 name:@"template" code:@"BEGIN {\n}\n\n{\n\n}\n\nEND {\n}"]];
        [self saveSnippet:[[Snippet alloc] initWithLanguage:104 name:@"sample" code:@"BEGIN {\n\n    print \"Hello, world!\"\n\n}"]];

        
        [self saveLanguage:105 withName:@"AWK (mawk)"];
        [self saveSnippet:[[Snippet alloc] initWithLanguage:105 name:@"template" code:@"BEGIN {\n}\n\n{\n\n}\n\nEND {\n}"]];
        [self saveSnippet:[[Snippet alloc] initWithLanguage:105 name:@"sample" code:@"BEGIN {\n\n    print \"Hello, world!\"\n\n}"]];
        
        [self saveLanguage:28 withName:@"Bash"];
        [self saveSnippet:[[Snippet alloc] initWithLanguage:28 name:@"template" code:@"#!/bin/bash"]];
        [self saveSnippet:[[Snippet alloc] initWithLanguage:28 name:@"sample" code:@"#!/bin/bash\n\necho Hello, world!"]];
        
        [self saveLanguage:110 withName:@"bc"];
        [self saveSnippet:[[Snippet alloc] initWithLanguage:110 name:@"sample" code:@"x = 5;\n\n/* multiplication table */\nfor (i=1; i<=x; ++i) {\n    for (j=1; j<=x; ++j)\n        print i*j, \"\\t\"\n    print \"\\n\"\n}\n\n/* compute the pi number accurately to 5 decimal places */\nscale=x\nprint \"\\npi = \", 4*a(1), \"\\n\"\n\n/* factorial */\ndefine f(n) {\n    if (n <= 1)\n        return 1;\n    return n * f(n-1);\n}\n\nprint \"\\n\";\nprint \"1! = \", f(1), \"\\n\";\nprint \"5! = \", f(5), \"\\n\";\nprint x, \"! = \", f(x), \"\\n\";"]];
        
        [self saveLanguage:12 withName:@"Brainf**k"];
        [self saveSnippet:[[Snippet alloc] initWithLanguage:12 name:@"sample" code:@"+++++ +++++ [ > +++++ ++  > +++++ +++++ > +++ > + <<<< - ] > ++ . > + . +++++ ++ . . +++ . > ++ . << +++++ +++++ +++++ . > . +++ . ----- - . ----- --- . > + . > ."]];
        
        [self saveLanguage:11 withName:@"C"];
        [self saveSnippet:[[Snippet alloc] initWithLanguage:11 name:@"template" code:@"#include <stdio.h>\n\nint main(int argc, char *argv[]) {\n    return 0;\n}"]];
        [self saveSnippet:[[Snippet alloc] initWithLanguage:11 name:@"sample" code:@"#include <stdio.h>\n\nint main(int argc, char *argv[]) {\n    printf(\"Hello, world!\\n\");\n    return 0;\n}"]];
        
        [self saveLanguage:27 withName:@"C#"];
        [self saveSnippet:[[Snippet alloc] initWithLanguage:27 name:@"template" code:@"using System;\n\nclass Program {\n    public static void Main() {\n    }\n}"]];
        [self saveSnippet:[[Snippet alloc] initWithLanguage:27 name:@"sample" code:@"using System;\n\nclass Program {\n    public static void Main() {\n        Console.WriteLine(\"Hello, world!\");\n    }\n}"]];
        
        [self saveLanguage:1 withName:@"C++"];
        [self saveSnippet:[[Snippet alloc] initWithLanguage:1 name:@"template" code:@"#include <iostream>\n\nint main() {\n\n    return 0;\n\n}"]];
        [self saveSnippet:[[Snippet alloc] initWithLanguage:1 name:@"sample" code:@"#include <iostream>\n\nint main() {\n\n    std::cout << \"Hello, World.\";\n    return 0;\n\n}"]];
        
        
        [self saveLanguage:44 withName:@"C++ 11"];
        [self saveSnippet:[[Snippet alloc] initWithLanguage:44 name:@"template" code:@"#include <iostream>\n\nint main() {\n\n    return 0;\n\n}"]];
        [self saveSnippet:[[Snippet alloc] initWithLanguage:44 name:@"sample" code:@"#include <iostream>\nusing namespace std;\n\nint main() {\n  auto func = [] () {\n    cout << \"Hello world\";\n  };\n  func();\n}"]];
        
        [self saveLanguage:34 withName:@"C99"];
        [self saveSnippet:[[Snippet alloc] initWithLanguage:34 name:@"template" code:@"#include <stdio.h>\n\nint main(void) {\n\n}"]];
        [self saveSnippet:[[Snippet alloc] initWithLanguage:34 name:@"sample" code:@"#include <stdio.h>\n\nint main(void)\n{\n    puts(\"Hello World!\");\n}"]];
        
        [self saveLanguage:14 withName:@"CLIPS"];
        //[self saveSnippet:[[Snippet alloc] initWithLanguage: name:@"sample" code:@""]];
        
        [self saveLanguage:111 withName:@"Clojure"];
        [self saveSnippet:[[Snippet alloc] initWithLanguage:111 name:@"sample" code:@"(println \"Hello, world!\")"]];
        
        [self saveLanguage:118 withName:@"COBOL"];
        //[self saveSnippet:[[Snippet alloc] initWithLanguage: name:@"sample" code:@""]];
        
        [self saveLanguage:106 withName:@"COBOL 85"];
        [self saveSnippet:[[Snippet alloc] initWithLanguage:106 name:@"sample" code:@"identification division.\nprogram-id. SimpleHelloWorld.\n\nprocedure division.\n000-Main.\n    display 'Hello World'.\n    stop run.\n"]];
        
        [self saveLanguage:32 withName:@"Common Lisp (clisp)"];
        [self saveSnippet:[[Snippet alloc] initWithLanguage:32 name:@"sample" code:@"(format t \"Hello, world!~%\")"]];
        
        [self saveLanguage:102 withName:@"D (dmd)"];
        [self saveSnippet:[[Snippet alloc] initWithLanguage:102 name:@"template" code:@"import std.stdio;\n\nvoid main() {\n\n}"]];
        [self saveSnippet:[[Snippet alloc] initWithLanguage:102 name:@"sample" code:@"import std.stdio;\n\nvoid main()\n{\n    writeln(\"Hello, world!\");\n}"]];
        
        [self saveLanguage:36 withName:@"Erlang"];
        [self saveSnippet:[[Snippet alloc] initWithLanguage:36 name:@"sample" code:@"-module(prog).\n-export([main/0]).\n\nmain() ->\n    io:fwrite(\"Hello, world!\")."]];
        
        [self saveLanguage:124 withName:@"F#"];
        [self saveSnippet:[[Snippet alloc] initWithLanguage:124 name:@"sample" code:@"printfn \"Hello, world!\""]];
        
        [self saveLanguage:123 withName:@"Factor"];
        [self saveSnippet:[[Snippet alloc] initWithLanguage:123 name:@"sample" code:@"USE: io\n\n\"Hello, World!\" print"]];
        
        [self saveLanguage:125 withName:@"Falcon"];
        [self saveSnippet:[[Snippet alloc] initWithLanguage:125 name:@"sample" code:@"printl( \"Hello, world!\" )"]];
        
        [self saveLanguage:107 withName:@"Forth"];
        [self saveSnippet:[[Snippet alloc] initWithLanguage:107 name:@"sample" code:@".\" Hello, world! \""]];
        
        [self saveLanguage:5 withName:@"Fortran"];
        [self saveSnippet:[[Snippet alloc] initWithLanguage:5 name:@"sample" code:@"program hello\n    write (*,*) 'Hello, world!'\nend program hello"]];
        
        [self saveLanguage:114 withName:@"Go"];
        [self saveSnippet:[[Snippet alloc] initWithLanguage:114 name:@"sample" code:@"package main\nimport \"fmt\"\n\nfunc main() {\n    fmt.Printf(\"Hello, World\")\n}"]];
        
        [self saveLanguage:121 withName:@"Groovy"];
        [self saveSnippet:[[Snippet alloc] initWithLanguage:121 name:@"sample" code:@"println \"Hello, world!\""]];
        
        [self saveLanguage:21 withName:@"Haskell"];
        [self saveSnippet:[[Snippet alloc] initWithLanguage:21 name:@"sample" code:@"main = putStrLn \"Hello, world!\""]];
        
        [self saveLanguage:16 withName:@"Icon"];
        [self saveSnippet:[[Snippet alloc] initWithLanguage:16 name:@"sample" code:@"procedure main(args)\n    write(\"Hello, World!\");\nend"]];
        
        [self saveLanguage:9 withName:@"Intercal"];
        //[self saveSnippet:[[Snippet alloc] initWithLanguage: name:@"sample" code:@""]];
        [self saveLanguage:10 withName:@"Java"];
        //[self saveSnippet:[[Snippet alloc] initWithLanguage: name:@"sample" code:@""]];
        [self saveLanguage:55 withName:@"Java 7"];
        //[self saveSnippet:[[Snippet alloc] initWithLanguage: name:@"sample" code:@""]];
        [self saveLanguage:35 withName:@"JavaScript (rhino)"];
        //[self saveSnippet:[[Snippet alloc] initWithLanguage: name:@"sample" code:@""]];
        [self saveLanguage:112 withName:@"JavaScript (spidermonkey)"];
        //[self saveSnippet:[[Snippet alloc] initWithLanguage: name:@"sample" code:@""]];
        [self saveLanguage:26 withName:@"Lua"];
        //[self saveSnippet:[[Snippet alloc] initWithLanguage: name:@"sample" code:@""]];
        [self saveLanguage:30 withName:@"Nemerle"];
        //[self saveSnippet:[[Snippet alloc] initWithLanguage: name:@"sample" code:@""]];
        [self saveLanguage:25 withName:@"Nice"];
        //[self saveSnippet:[[Snippet alloc] initWithLanguage: name:@"sample" code:@""]];
        [self saveLanguage:122 withName:@"Nimrod"];
        //[self saveSnippet:[[Snippet alloc] initWithLanguage: name:@"sample" code:@""]];
        [self saveLanguage:56 withName:@"Node.js"];
        //[self saveSnippet:[[Snippet alloc] initWithLanguage: name:@"sample" code:@""]];
        [self saveLanguage:43 withName:@"Objective-C"];
        //[self saveSnippet:[[Snippet alloc] initWithLanguage: name:@"sample" code:@""]];
        [self saveLanguage:8 withName:@"Ocaml"];
        //[self saveSnippet:[[Snippet alloc] initWithLanguage: name:@"sample" code:@""]];
        [self saveLanguage:127 withName:@"Octave"];
        //[self saveSnippet:[[Snippet alloc] initWithLanguage: name:@"sample" code:@""]];
        [self saveLanguage:119 withName:@"Oz"];
        //[self saveSnippet:[[Snippet alloc] initWithLanguage: name:@"sample" code:@""]];
        [self saveLanguage:57 withName:@"PARI/GP"];
        //[self saveSnippet:[[Snippet alloc] initWithLanguage: name:@"sample" code:@""]];
        [self saveLanguage:22 withName:@"Pascal (fpc)"];
        //[self saveSnippet:[[Snippet alloc] initWithLanguage: name:@"sample" code:@""]];
        [self saveLanguage:2 withName:@"Pascal (gpc)"];
        //[self saveSnippet:[[Snippet alloc] initWithLanguage: name:@"sample" code:@""]];
        [self saveLanguage:3 withName:@"Perl"];
        //[self saveSnippet:[[Snippet alloc] initWithLanguage: name:@"sample" code:@""]];
        [self saveLanguage:54 withName:@"Perl 6"];
        //[self saveSnippet:[[Snippet alloc] initWithLanguage: name:@"sample" code:@""]];
        [self saveLanguage:29 withName:@"PHP"];
        //[self saveSnippet:[[Snippet alloc] initWithLanguage: name:@"sample" code:@""]];
        [self saveLanguage:19 withName:@"Pike"];
        //[self saveSnippet:[[Snippet alloc] initWithLanguage: name:@"sample" code:@""]];
        [self saveLanguage:108 withName:@"Prolog (gnu)"];
        //[self saveSnippet:[[Snippet alloc] initWithLanguage: name:@"sample" code:@""]];
        [self saveLanguage:15 withName:@"Prolog (swi)"];
        //[self saveSnippet:[[Snippet alloc] initWithLanguage: name:@"sample" code:@""]];
        [self saveLanguage:4 withName:@"Python"];
        //[self saveSnippet:[[Snippet alloc] initWithLanguage: name:@"sample" code:@""]];
        [self saveLanguage:116 withName:@"Python 3"];
        //[self saveSnippet:[[Snippet alloc] initWithLanguage: name:@"sample" code:@""]];
        [self saveLanguage:117 withName:@"R"];
        //[self saveSnippet:[[Snippet alloc] initWithLanguage: name:@"sample" code:@""]];
        [self saveLanguage:17 withName:@"Ruby"];
        //[self saveSnippet:[[Snippet alloc] initWithLanguage: name:@"sample" code:@""]];
        [self saveLanguage:39 withName:@"Scala"];
        //[self saveSnippet:[[Snippet alloc] initWithLanguage: name:@"sample" code:@""]];
        [self saveLanguage:33 withName:@"Scheme (guile)"];
        //[self saveSnippet:[[Snippet alloc] initWithLanguage: name:@"sample" code:@""]];
        [self saveLanguage:23 withName:@"Smalltalk"];
        //[self saveSnippet:[[Snippet alloc] initWithLanguage: name:@"sample" code:@""]];
        [self saveLanguage:40 withName:@"SQL"];
        //[self saveSnippet:[[Snippet alloc] initWithLanguage: name:@"sample" code:@""]];
        [self saveLanguage:38 withName:@"Tcl"];
        //[self saveSnippet:[[Snippet alloc] initWithLanguage: name:@"sample" code:@""]];
        [self saveLanguage:62 withName:@"Text"];
        //[self saveSnippet:[[Snippet alloc] initWithLanguage: name:@"sample" code:@""]];
        [self saveLanguage:115 withName:@"Unlambda"];
        //[self saveSnippet:[[Snippet alloc] initWithLanguage: name:@"sample" code:@""]];
        [self saveLanguage:101 withName:@"VB.NET"];
        //[self saveSnippet:[[Snippet alloc] initWithLanguage: name:@"sample" code:@""]];
        [self saveLanguage:6 withName:@"Whitespace"];
        //[self saveSnippet:[[Snippet alloc] initWithLanguage: name:@"sample" code:@""]];
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

-(void) initInitialSnippets{
    
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

-(void) putQuickSymbol:(QuickSymbol*)symbol toLanguageUsage:(int)lang atIndex:(int)index{
    int symbolsForLang = [self getSymbolsCountForLanguage:lang];
    int indexToPutAt = MAX(0, MIN(index, symbolsForLang));
    int currentOrder = [self getOrderIndexForSymbolId:symbol.symbId forLaguageUsage:lang];
    
    if (indexToPutAt == currentOrder){
        return;
    }
    
    NSMutableArray* queries = [[NSMutableArray alloc] initWithObjects:@"begin;", nil];
    
    if (currentOrder == -1){ // inserting new symbol to order
        if (symbolsForLang > indexToPutAt){
            [queries addObject: [NSString stringWithFormat:@"UPDATE %@ SET %@=%@+1 WHERE %@=%d AND %@>=%d;", T_SYMBOLS_ORDER, F_SYMB_ORDER, F_SYMB_ORDER, F_LANG, lang, F_SYMB_ORDER, indexToPutAt]];
        }
        [queries addObject:[NSString stringWithFormat:@"INSERT INTO %@ (%@, %@, %@) VALUES (%d, %d, %d)", T_SYMBOLS_ORDER, F_SYMB_ID, F_LANG, F_SYMB_ORDER, symbol.symbId, lang, indexToPutAt]];
    } else { // 'moving' symbol inside table
        if (indexToPutAt > currentOrder){ // moving symbol down
            [queries addObject: [NSString stringWithFormat:@"UPDATE %@ SET %@=%@-1 WHERE %@=%d AND %@>%d AND %@<=%d;", T_SYMBOLS_ORDER, F_SYMB_ORDER, F_SYMB_ORDER, F_LANG, lang, F_SYMB_ORDER, currentOrder, F_SYMB_ORDER, indexToPutAt]];
        } else { // moving symbol up
            [queries addObject: [NSString stringWithFormat:@"UPDATE %@ SET %@=%@+1 WHERE %@=%d AND %@>=%d AND %@<%d;", T_SYMBOLS_ORDER, F_SYMB_ORDER, F_SYMB_ORDER, F_LANG, lang, F_SYMB_ORDER, indexToPutAt, F_SYMB_ORDER, currentOrder]];
        }
        
        [queries addObject: [NSString stringWithFormat:@"UPDATE %@ SET %@=%d WHERE %@=%d AND %@=%d;", T_SYMBOLS_ORDER, F_SYMB_ORDER, indexToPutAt, F_LANG, lang, F_SYMB_ID, symbol.symbId]];
    }
    
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

@end
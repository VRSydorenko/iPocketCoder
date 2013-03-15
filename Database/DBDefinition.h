//
//  DBDefinition.h
//  SapidChat
//
//  Created by Viktor Sydorenko on 9/26/12.
//  Copyright (c) 2012 Viktor Sydorenko. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DATABASE_NAME @"buildanywhere.db"

#define DBTYPE_TEXT @"text"
#define DBTYPE_REAL @"real"
#define DBTYPE_BOOL @"boolean"
#define DBTYPE_BLOB @"blob"

#define F_ID @"_id"

#define T_LANGS @"t_langs"
#define F_LANG @"f_lang"
#define F_NAME @"f_name"

#define T_PROJECTS @"t_projects"
#define F_CODE @"f_code"
#define F_LINK @"f_link"
#define F_INPUT @"f_input"
// F_LANG
// F_NAME

#define T_SNIPPETS @"t_snippets"
// F_LANG
// F_NAME
// F_CODE

#define T_SYMBOLS @"t_symbols"
#define F_SYMB_ID @"f_symb_id"
// F_NAME
// F_CODE

#define T_SYMBOLS_ORDER @"t_symbols_order"
// F_SYMB_ID
// F_LANG
#define F_SYMB_ORDER @"f_order"

@interface DBDefinition : NSObject

-(NSString*) getTablesCreationSQL;

@end

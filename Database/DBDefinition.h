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

#define F_ID @"f_id"

#define T_LANGS @"t_langs"
#define F_NAME @"f_name"

#define T_PROJECTS @"t_projects"
#define F_LANG @"f_lang"
#define F_CODE @"f_code"
#define F_LINK @"f_link"
// F_NAME

#define T_SNIPPETS @"t_snippets"
// F_LANG
// F_NAME
// F_CODE

@interface DBDefinition : NSObject

-(NSString*) getTablesCreationSQL;

@end

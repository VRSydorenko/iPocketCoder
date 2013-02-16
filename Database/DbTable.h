//
//  DbTable.h
//  SapidChat
//
//  Created by Viktor Sydorenko on 9/26/12.
//  Copyright (c) 2012 Viktor Sydorenko. All rights reserved.
//

#import <Foundation/Foundation.h>

#define PRIMARY_KEY_AUTO_INCREMENT @"_id integer primary key autoincrement"

@protocol DbFieldProtocol <NSObject>

-(NSString*) getSignature;

@end

@interface DbTable : NSObject

-(id) initWithTableName:(NSString*)tableName;
-(void) addField:(NSString*)name type:(NSString*)type notNull:(BOOL)notNull;
-(void) addForeignKey:(NSString*)name refTable:(NSString*)refTable refField:(NSString*)refField;
-(NSString*) getTableCreationSQL;

@end

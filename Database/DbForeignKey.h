//
//  DbForeignKey.h
//  SapidChat
//
//  Created by Viktor Sydorenko on 9/26/12.
//  Copyright (c) 2012 Viktor Sydorenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DbTable.h"

@interface DbForeignKey : NSObject <DbFieldProtocol>

-(id) initWithName:(NSString*)name type:(NSString*)refTable notNull:(NSString*)refField;
-(NSString*) getSignature;

@end

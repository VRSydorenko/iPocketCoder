//
//  DbField.h
//  SapidChat
//
//  Created by Viktor Sydorenko on 9/26/12.
//  Copyright (c) 2012 Viktor Sydorenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DbTable.h"

@interface DbField : NSObject <DbFieldProtocol>

-(id) initWithName:(NSString*)name type:(NSString*)type notNull:(bool)notNull;
-(NSString*) getSignature;

@end

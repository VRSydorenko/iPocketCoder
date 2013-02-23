//
//  QuickSymbol.h
//  BuildAnywhere
//
//  Created by Viktor Sydorenko on 2/22/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuickSymbol : NSObject

@property int symbId;
@property NSString* symbTitle;
@property NSString* symbContent;

-(id) initWithId:(int)iD title:(NSString*)title content:(NSString*)content;

@end

//
//  Utils.h
//  BuildAnywhere
//
//  Created by Viktor Sydorenko on 2/16/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

+(NSString*) trimWhitespaces:(NSString*)string;
+(void)shareText:(NSString*)textToShare overViewController:(UIViewController*)viewController;

@end

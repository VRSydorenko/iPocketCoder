//
//  Utils.h
//  BuildAnywhere
//
//  Created by Viktor Sydorenko on 2/16/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RunManager.h"

@interface Utils : NSObject

+(NSString*) trimWhitespaces:(NSString*)string;
+(void)shareText:(NSString*)textToShare overViewController:(UIViewController*)viewController;
+(NSString*)getShortDescriptionOfResultCode:(ResultCodes)code;
+(NSString*)getSignalDescription:(int)signal;
+(NSString*)returnCaretIfNotEmpty:(NSString*)targetString returnNumbers:(int)returns;
+(NSString*)codeTemplateForLanguage:(int)langId;

@end

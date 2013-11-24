//
//  SourceCodeProvider.h
//  PocketCoder
//
//  Created by VRS on 24/11/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SourceCodeProvider : NSObject

+(NSString*)getCodeTemplateForLanguage:(int)langId;

@end

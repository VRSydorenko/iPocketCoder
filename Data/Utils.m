//
//  Utils.m
//  BuildAnywhere
//
//  Created by Viktor Sydorenko on 2/16/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+(BOOL) isOnIPad{
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}

@end

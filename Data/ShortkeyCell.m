//
//  ShortkeyCell.m
//  PocketCoder
//
//  Created by Viktor Sydorenko on 3/20/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "ShortkeyCell.h"

@implementation ShortkeyCell

- (void)setIsActive:(BOOL)isActive
{
    self.viewBg.backgroundColor = isActive ? [UIColor blackColor] : [UIColor lightGrayColor];
    self.labelShortkey.backgroundColor = isActive ? [UIColor lightGrayColor] : [UIColor lightTextColor];
    self.labelShortkey.textColor = isActive ? [UIColor blackColor] : [UIColor lightGrayColor];
}

@end

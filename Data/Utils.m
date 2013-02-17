//
//  Utils.m
//  BuildAnywhere
//
//  Created by Viktor Sydorenko on 2/16/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+(UIBarButtonItem*) createBackButtonWithSelectorBackPressedOnTarget:(UIViewController*)viewController{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backBtnImage = [UIImage imageNamed:@"backArrow.png"] ;
    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    [backBtn addTarget:viewController action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 24, 24);
    return [[UIBarButtonItem alloc] initWithCustomView:backBtn];
}

@end

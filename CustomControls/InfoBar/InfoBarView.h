//
//  SapidInfoBarView.h
//  SapidChat
//
//  Created by Viktor Sydorenko on 12/29/12.
//  Copyright (c) 2012 Viktor Sydorenko. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ANIMATION_DURATION 0.3

@interface InfoBarView : UIView

- (void)showPositiveMessage:(NSString *)message;
- (void)showNeutralMessage:(NSString *)message;
- (void)showNegativeMessage:(NSString *)message;
- (void)hideInfoBar;

@end
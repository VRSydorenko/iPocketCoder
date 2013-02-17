//
//  SapidInfoBarView.m
//  SapidChat
//
//  Created by Viktor Sydorenko on 12/29/12.
//  Copyright (c) 2012 Viktor Sydorenko. All rights reserved.
//

#import "InfoBarView.h"

@implementation InfoBarView {
    CGPoint hiddenCP;
    CGPoint showCP;
    
    BOOL isHidden;
    
    UILabel *infoLabel;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        isHidden = YES;
        CGFloat halfWidth = frame.size.width / 2.0;
        CGFloat halfHeight = frame.size.height / 2.0;
        hiddenCP = CGPointMake(frame.origin.x + halfWidth, frame.origin.y + halfHeight);
        showCP = CGPointMake(frame.origin.x + halfWidth, frame.origin.y + halfHeight + frame.size.height);
        
        //UIColor *bg = [UIColor colorWithRed:90.0 green:140.0 blue:0.0 alpha:0.9];
        self.backgroundColor = [UIColor colorWithRed:120.0/255.0 green:190.0/255.0 blue:95.0/255.0 alpha:0.9];
        
        
        infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        infoLabel.numberOfLines = 0;
        infoLabel.lineBreakMode = UILineBreakModeWordWrap;
        infoLabel.textAlignment = UITextAlignmentCenter;
        infoLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
        infoLabel.textColor = [UIColor whiteColor];
        infoLabel.backgroundColor = [UIColor clearColor];
        
        infoLabel.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.35];
        infoLabel.shadowOffset = CGSizeMake(0, 1.0);
        [self addSubview:infoLabel];
    }
    return self;
}

- (void)showPositiveMessage:(NSString *)message {
    self.backgroundColor = [UIColor colorWithRed:120.0/255.0 green:190.0/255.0 blue:95.0/255.0 alpha:0.9];
    [self showMessage:message];
}

- (void)showNeutralMessage:(NSString *)message {
    self.backgroundColor = [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:0.0/255.0 alpha:0.9];
    [self showMessage:message];
}

- (void)showNegativeMessage:(NSString *)message {
    self.backgroundColor = [UIColor colorWithRed:250.0/255.0 green:75.0/255.0 blue:65.0/255.0 alpha:0.9];
    [self showMessage:message];
}

- (void)showMessage:(NSString *)message {
    [self setMessageText:message];
    if (isHidden) {
        [UIView transitionWithView:self duration:0.5
                           options:UIViewAnimationOptionTransitionNone
                        animations:^ { self.center = showCP; }
                        completion:nil];
        isHidden = NO;
        [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(hideInfoBar) userInfo:nil repeats:NO];
    }
}

- (void)hideInfoBar{
    if (!isHidden) {
        [UIView transitionWithView:self duration:0.5
                           options:UIViewAnimationOptionTransitionNone
                        animations:^ { self.center = hiddenCP; }
                        completion:nil];
        isHidden = YES;
    }
}

- (void)setMessageText:(NSString *)message {
    if (message != nil) infoLabel.text = message;
}

- (void)dealloc
{
    infoLabel = nil;
}

@end
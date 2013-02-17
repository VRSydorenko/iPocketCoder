//
//  SapidInfoBarManager.h
//  SapidChat
//
//  Created by Viktor Sydorenko on 12/29/12.
//  Copyright (c) 2012 Viktor Sydorenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InfoBarView.h"

typedef enum MessageMoodTypes{
    POSITIVE,
    NEUTRAL,
    NEGATIVE
} MessageMoodTypes;

@interface InfoBarManager : NSObject

@property (strong, nonatomic) InfoBarView *infoBar;

- (void)initInfoBarWithTopViewFrame:(CGRect)frame andHeight:(CGFloat)height;
- (void)showInfoBarWithMessage:(NSString *)message withMood:(MessageMoodTypes)mood;
- (void) hideInfoBar;

@end
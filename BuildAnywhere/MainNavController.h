//
//  MainNavController.h
//  BuildAnywhere
//
//  Created by Viktor Sydorenko on 2/16/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoBarManager.h"

@interface MainNavController : UINavigationController

- (void)showInfoBarWithNegativeMessage:(NSString*)text;
- (void)showInfoBarWithNeutralMessage:(NSString*)text;
- (void)showInfoBarWithPositiveMessage:(NSString*)text;

@end

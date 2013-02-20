//
//  MainNavController.h
//  BuildAnywhere
//
//  Created by Viktor Sydorenko on 2/16/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoBarManager.h"

#define IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad

@interface MainNavController : UINavigationController

-(void)createMiniBackButtonWithBackPressedSelectorOnTarget:(UIViewController*)viewController;

-(void) hideToolBarAnimated:(BOOL)animated;
-(void) showToolbarAnimated:(BOOL)animated;

-(void)resetInfoBar;

- (void)showInfoBarWithNegativeMessage:(NSString*)text;
- (void)showInfoBarWithNeutralMessage:(NSString*)text;
- (void)showInfoBarWithPositiveMessage:(NSString*)text;
-(void) showMessageBox:(NSString*)title text:(NSString*)text;

@end

//
//  MainNavController.m
//  BuildAnywhere
//
//  Created by Viktor Sydorenko on 2/16/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "MainNavController.h"

@interface MainNavController (){
    InfoBarManager* infoManager;
}
@end

@implementation MainNavController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated{
    [self initInfoBar];
}

-(void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    if (!IPAD){
        // if it has already been created on iPad so do nothing here
        // because it has fixed size on iPad
        [self resetInfoBar];
    }
}

-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
     [self initInfoBar];
}

-(void)createMiniBackButtonWithBackPressedSelectorOnTarget:(UIViewController*)viewController{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backBtnImage = [UIImage imageNamed:@"backArrow.png"] ;
    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    [backBtn addTarget:viewController action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 24, 24);
    viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
}

-(void) hideToolBarAnimated:(BOOL)animated{
    [self resetInfoBar];
    [self setToolbarHidden:YES animated:animated];
}

-(void) showToolbarAnimated:(BOOL)animated{
    [self setToolbarHidden:NO animated:animated];
}

-(void)resetInfoBar{
    if (infoManager){
        [infoManager hideInfoBar];
        infoManager = nil;
    }
}

-(void) initInfoBar{
    if (infoManager){
        [self resetInfoBar];
    }
    infoManager = [[InfoBarManager alloc] init];
    if (infoManager){
        [infoManager initInfoBarWithTopViewFrame:self.toolbar.frame andHeight:self.toolbar.frame.size.height];
        [self.view insertSubview:infoManager.infoBar belowSubview:self.toolbar];
    }
}

- (void)showInfoBarWithNegativeMessage:(NSString*)text {
    if (!infoManager){
        [self initInfoBar];
    }
    [infoManager showInfoBarWithMessage:text withMood:NEGATIVE];
}

- (void)showInfoBarWithNeutralMessage:(NSString*)text {
    if (!infoManager){
        [self initInfoBar];
    }
    [infoManager showInfoBarWithMessage:text withMood:NEUTRAL];
}

- (void)showInfoBarWithPositiveMessage:(NSString*)text {
    if (!infoManager){
        [self initInfoBar];
    }
    [infoManager showInfoBarWithMessage:text withMood:POSITIVE];
}

@end

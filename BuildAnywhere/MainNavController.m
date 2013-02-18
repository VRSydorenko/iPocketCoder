//
//  MainNavController.m
//  BuildAnywhere
//
//  Created by Viktor Sydorenko on 2/16/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "MainNavController.h"

#define IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad

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

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)orientation duration:(NSTimeInterval)duration {
    [self initInfoBar];
}

-(void) initInfoBar{
    if (infoManager){
        if (IPAD){
            // if it has already been created on iPad so do nothing here
            // because it has fixed size on iPad
            return;
        }
        [infoManager hideInfoBar];
        infoManager = nil;
    }
    infoManager = [[InfoBarManager alloc] init];
    if (infoManager){
        [infoManager initInfoBarWithTopViewFrame:self.navigationBar.frame andHeight:40];
        [self.view insertSubview:infoManager.infoBar belowSubview:self.navigationBar];
    }
}

- (void)showInfoBarWithNegativeMessage:(NSString*)text {
    [infoManager showInfoBarWithMessage:text withMood:NEGATIVE];
}

- (void)showInfoBarWithNeutralMessage:(NSString*)text {
    [infoManager showInfoBarWithMessage:text withMood:NEUTRAL];
}

- (void)showInfoBarWithPositiveMessage:(NSString*)text {
    [infoManager showInfoBarWithMessage:text withMood:POSITIVE];
}

@end

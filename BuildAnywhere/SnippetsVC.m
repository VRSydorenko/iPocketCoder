//
//  SnippetsVC.m
//  BuildAnywhere
//
//  Created by Viktor Sydorenko on 2/17/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "SnippetsVC.h"

@interface SnippetsVC (){
    MainNavController* navCon;
}
@end

@implementation SnippetsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    navCon = (MainNavController*)self.navigationController;
    
    if (!IPAD){ // to save more space on navigation bar
        [navCon createMiniBackButtonWithBackPressedSelectorOnTarget:self];
    }
}

-(void) viewDidAppear:(BOOL)animated{
    [navCon hideToolBarAnimated:YES];
}

// iPhone
-(void)backPressed{
    [self.navigationController popViewControllerAnimated:YES];
}

@end

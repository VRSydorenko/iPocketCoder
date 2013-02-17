//
//  SnippetsVC.m
//  BuildAnywhere
//
//  Created by Viktor Sydorenko on 2/17/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "SnippetsVC.h"

#define IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad

@interface SnippetsVC ()

@end

@implementation SnippetsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!IPAD){
    self.navigationItem.leftBarButtonItem = [Utils createBackButtonWithSelectorBackPressedOnTarget:self];
    }
}

// iPhone
-(void)backPressed{
    [self.navigationController popViewControllerAnimated:YES];
}

@end

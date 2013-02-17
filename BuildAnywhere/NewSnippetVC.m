//
//  NewSnippetVC.m
//  BuildAnywhere
//
//  Created by Viktor Sydorenko on 2/18/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "NewSnippetVC.h"

@interface NewSnippetVC ()

@end

@implementation NewSnippetVC

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.navigationItem.leftBarButtonItem = [Utils createBackButtonWithSelectorBackPressedOnTarget:self];
}

-(void)backPressed{
    [self.navigationController popViewControllerAnimated:YES];
}

@end

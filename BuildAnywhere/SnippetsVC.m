//
//  SnippetsVC.m
//  BuildAnywhere
//
//  Created by Viktor Sydorenko on 2/17/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "SnippetsVC.h"

@interface SnippetsVC ()

@end

@implementation SnippetsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.labelTitle.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.labelTitle.shadowOffset = CGSizeMake(0, -1.0);
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload {
    [self setLabelTitle:nil];
    [super viewDidUnload];
}
@end

//
//  ResultsVC.m
//  BuildAnywhere
//
//  Created by Viktor Sydorenko on 2/24/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "ResultsVC.h"

@interface ResultsVC (){
    MainNavController* navCon;
}

@end

@implementation ResultsVC

@synthesize errorMode;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.errorMode ? @"Errors & Warnings" : @"Output";
	
    navCon = (MainNavController*)self.navigationController;
    
    if (!IPAD){
        [navCon createMiniBackButtonWithBackPressedSelectorOnTarget:self];
    }
}

@end

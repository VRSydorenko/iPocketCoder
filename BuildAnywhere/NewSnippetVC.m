//
//  NewSnippetVC.m
//  BuildAnywhere
//
//  Created by Viktor Sydorenko on 2/18/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "NewSnippetVC.h"

@interface NewSnippetVC (){
    MainNavController* navCon;
}
@end

@implementation NewSnippetVC

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    navCon = (MainNavController*)self.navigationController;
    
    if (!IPAD){ // to save more space on navigation bar
        [navCon createMiniBackButtonWithBackPressedSelectorOnTarget:self];
    }
}

-(void) viewDidAppear:(BOOL)animated{
    [navCon showToolbarAnimated:YES];
}

-(void)backPressed{
    [self.navigationController popViewControllerAnimated:YES];
}

@end

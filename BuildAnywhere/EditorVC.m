//
//  EditorVC.m
//  BuildAnywhere
//
//  Created by Viktor Sydorenko on 2/17/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "EditorVC.h"

#define IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad

@interface EditorVC (){
    Project* project;
}

@end

@implementation EditorVC

@synthesize projectName;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!IPAD){ // to save more space on navigation bar 
        self.navigationItem.leftBarButtonItem = [Utils createBackButtonWithSelectorBackPressedOnTarget:self];
    }
    
    project = self.projectName.length > 0 ? [DataManager loadProject:self.projectName] : nil;
    self.navigationItem.title = project.projName;
}

// iPhone
-(void)backPressed{
    [self.navigationController popViewControllerAnimated:YES];
}

@end

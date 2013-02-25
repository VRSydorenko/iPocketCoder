//
//  InputVC.m
//  BuildAnywhere
//
//  Created by Viktor Sydorenko on 2/25/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "InputVC.h"

@interface InputVC (){
    MainNavController* navCon;
}

@end

@implementation InputVC

@synthesize project = _project;
@synthesize delegate = _delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.textInput.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    navCon = (MainNavController*)self.navigationController;
    
    if (!IPAD){ // to save more space on navigation bar
        [navCon createMiniBackButtonWithBackPressedSelectorOnTarget:self];
    }
    
    self.textInput.text = self.project.projInput;
}

-(IBAction)clearPressed:(id)sender{
    self.textInput.text = @"";
}

// iPhone
-(void)backPressed{
    self.project.projInput = self.textInput.text;
    [self.project save];
    
    [self.delegate inputUpdatedFromController:self];
}

- (void)viewDidUnload {
    [self setTextInput:nil];
    [super viewDidUnload];
}
@end

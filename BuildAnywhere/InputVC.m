//
//  InputVC.m
//  BuildAnywhere
//
//  Created by Viktor Sydorenko on 2/25/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "InputVC.h"

@implementation InputVC

@synthesize delegate = _delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.textInput.text = self.textForInputInit;
    self.textInput.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    if (!IPAD){ // to save more space on navigation bar
        MainNavController *navCon = (MainNavController*)self.navigationController;
        [navCon createMiniBackButtonWithBackPressedSelectorOnTarget:self];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    if (IPAD){
        [self.delegate inputTextChangedTo:self.textInput.text];
    }
}

-(IBAction)clearPressed:(id)sender{
    self.textInput.text = @"";
}

// iPhone
-(void)backPressed{
    [self.delegate inputTextChangedTo:self.textInput.text];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload {
    [self setTextInput:nil];
    [super viewDidUnload];
}
@end

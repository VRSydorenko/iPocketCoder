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

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.textInput.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    navCon = (MainNavController*)self.navigationController;
    
    if (!IPAD){ // to save more space on navigation bar
        [navCon createMiniBackButtonWithBackPressedSelectorOnTarget:self];
    }
    
    self.textInput.delegate = self;
    self.textInput.text = self.project.projInput;
}

-(IBAction)clearPressed:(id)sender{
    self.textInput.text = @"";
}

//iPad
-(void)textViewDidChange:(UITextView *)textView{
    [self.project setInput:self.textInput.text];
    [DataManager saveProject:self.project];
}

// iPhone
-(void)backPressed{
    [self.project setInput:self.textInput.text];
    [DataManager saveProject:self.project];
    
    [navCon popViewControllerAnimated:YES];
}

- (void)viewDidUnload {
    [self setTextInput:nil];
    [super viewDidUnload];
}
@end

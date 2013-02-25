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

@synthesize cmpInfo = _cmpInfo;
@synthesize output = _output;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    navCon = (MainNavController*)self.navigationController;
    
    if (!IPAD){
        [navCon createMiniBackButtonWithBackPressedSelectorOnTarget:self];
    }
    
    if (self.cmpInfo.length > 0){
        [self cmpInfoPressed:nil];
    } else {
        [self outputPressed:nil];
    }
}

// iPhone
-(void)backPressed{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload {
    [self setTextInfo:nil];
    [super viewDidUnload];
}
- (IBAction)cmpInfoPressed:(id)sender {
    self.title = @"Compiler info";
    self.textInfo.text = self.cmpInfo;
}

- (IBAction)outputPressed:(id)sender {
    self.title = @"Program output";
    self.textInfo.text = self.output;
}
@end

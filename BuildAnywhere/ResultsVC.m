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
    UIPopoverController* popoverController;
}

@end

@implementation ResultsVC

@synthesize cmpInfo = _cmpInfo;
@synthesize output = _output;
@synthesize stdErr = _stdErr;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    navCon = (MainNavController*)self.navigationController;
    
    if (!IPAD){
        [navCon createMiniBackButtonWithBackPressedSelectorOnTarget:self];
    }
    
    if (self.cmpInfo.length > 0 || self.stdErr.length > 0){
        [self cmpInfoPressed:nil];
    } else {
        [self outputPressed:nil];
    }
}

// iPhone
-(void)backPressed{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) viewWillDisappear:(BOOL)animated{
    if ([navCon.viewControllers indexOfObject:self] == NSNotFound){ // back button
        if (popoverController){
            if ([popoverController isPopoverVisible]){
                [popoverController dismissPopoverAnimated:YES];
                return;
            }
            popoverController = nil;
        }
    }
}

- (void)viewDidUnload {
    [self setTextInfo:nil];
    [super viewDidUnload];
}

- (IBAction)cmpInfoPressed:(id)sender {
    if (self.cmpInfo.length > 0 && self.stdErr.length > 0){
        self.title = @"Info";
        self.textInfo = [NSString stringWithFormat:@"Compiler info:\n\n%@\n\n\nStdErr output:\n\n%@", self.cmpInfo, self.stdErr];
    } else if (self.cmpInfo.length > 0 && self.stdErr.length == 0){
        self.title = @"Compiler info";
        self.textInfo.text = self.cmpInfo;
    } else {
        self.title = @"StdErr output";
        self.textInfo.text = self.stdErr;
    }
}

- (IBAction)outputPressed:(id)sender {
    self.title = @"Program output";
    self.textInfo.text = self.output;
}

- (IBAction)sharePressed:(id)sender{
    if (IPAD){
        if (popoverController){
            if ([popoverController isPopoverVisible]){
                [popoverController dismissPopoverAnimated:YES];
            }
            popoverController = nil;
        }
        
        MainNavController *shareManagerNavVC = [[UIStoryboard storyboardWithName:@"iPhoneMain" bundle:nil] instantiateViewControllerWithIdentifier:@"screenShareManager"];
        if (!shareManagerNavVC){
            return;
        }
        
        ShareManagerVC* shareManagerVC = ((ShareManagerVC*)[shareManagerNavVC.viewControllers objectAtIndex:0]);
        shareManagerVC.delegate = self;
        
        shareManagerVC.availableContentTypes = [self prepareAvailableContentTypes];
        
        popoverController = [[UIPopoverController alloc] initWithContentViewController:shareManagerNavVC];
        [popoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    } else {
        [self performSegueWithIdentifier:@"segueResultsToShareManager" sender:self];
    }
}

-(NSArray*) prepareAvailableContentTypes{
    NSMutableArray *types = [[NSMutableArray alloc] init];
    if (self.projectName.length > 0){
        Project *project = [DataManager loadProject:self.projectName];
        if (project){
            if (project.projLink.length > 0){
                [types addObject:[NSNumber numberWithUnsignedInt:LINK]];
            }
            if (project.projCode.length > 0){
                [types addObject:[NSNumber numberWithUnsignedInt:SOURCE]];
            }
            if (project.projInput.length > 0){
                [types addObject:[NSNumber numberWithUnsignedInt:INPUT]];
            }
        }
    }
    if (self.output.length > 0){
        [types addObject:[NSNumber numberWithUnsignedInt:OUTPUT]];
    }
    if (self.cmpInfo.length > 0){
        [types addObject:[NSNumber numberWithUnsignedInt:CMPINFO]];
    }
    if (self.stdErr.length > 0){
        [types addObject:[NSNumber numberWithUnsignedInt:STDERRINFO]];
    }
    return [NSArray arrayWithArray:types];
}

// iPhone
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"segueResultsToShareManager"]){
        ShareManagerVC *shareManVC = (ShareManagerVC*)segue.destinationViewController;
        if (!shareManVC){
            return;
        }
        shareManVC.delegate = self;
        shareManVC.availableContentTypes = [self prepareAvailableContentTypes];
    }
}

-(void)shareManagerDidSelectContentToShare:(NSArray*)contentTypes{
    // close Share Manager
    if (IPAD){
        if (popoverController){
            if ([popoverController isPopoverVisible]){
                [popoverController dismissPopoverAnimated:YES];
            }
            popoverController = nil;
        }
    } else {
        [navCon popViewControllerAnimated:YES];
    }
    
    if (contentTypes.count == 0){
        return;
    }
    
    if (self.projectName.length == 0){
        return;
    }
    
    Project *project = [DataManager loadProject:self.projectName];
    
    if (!project){
        return;
    }
    
    NSString* textToShare = [NSString stringWithFormat:@"%@ project information from iPocketCoder.", [DataManager getLanguageName:project.projLanguage]];
    
    NSNumber* type;
    for (int i = 0; i < 6; i++) { // all content types
        type = [NSNumber numberWithUnsignedInt:i];
        if (![contentTypes containsObject:type]){
            continue;
        }
        switch (i) {
            case LINK:{
                textToShare = [textToShare stringByAppendingFormat:@"\n\nA link to the code: http://ideone.com/%@", project.projLink];
                break;
            }
            case SOURCE:{
                textToShare = [textToShare stringByAppendingFormat:@"\n\nSource code:\n%@", project.projCode];
                break;
            }
            case INPUT:{
                textToShare = [textToShare stringByAppendingFormat:@"\n\nInput:\n%@", project.projInput];
                break;
            }
            case OUTPUT:{
                textToShare = [textToShare stringByAppendingFormat:@"\n\nOutput:\n%@", self.output];
                break;
            }
            case CMPINFO:{
                textToShare = [textToShare stringByAppendingFormat:@"\n\nCompiler info:\n%@", self.cmpInfo];
                break;
            }
            case STDERRINFO:{
                textToShare = [textToShare stringByAppendingFormat:@"\n\nStderr output:\n%@", self.stdErr];
                break;
            }
        }
    }
    
    [Utils shareText:textToShare overViewController:self];
}
@end

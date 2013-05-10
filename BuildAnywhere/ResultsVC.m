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
@synthesize signal = _signal;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    navCon = (MainNavController*)self.navigationController;
    
    if (!IPAD){
        [navCon createMiniBackButtonWithBackPressedSelectorOnTarget:self];
    }
    
    if (self.cmpInfo.length > 0 || self.stdErr.length > 0 || self.signal > 0){
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
    NSString* content = @"";
    
    if (self.cmpInfo.length > 0 && self.stdErr.length > 0){
        self.title = @"info";
        content = [NSString stringWithFormat:@"Compiler info:\n\n%@\n\n\nStdErr output:\n\n%@", self.cmpInfo, self.stdErr];
    } else if (self.cmpInfo.length > 0 && self.stdErr.length == 0){
        self.title = @"compiler info";
        content = self.cmpInfo;
    } else {
        self.title = @"stderr";
        content = self.stdErr;
    }
    if (self.signal > 0){
        if (content.length > 0){
            content = [content stringByAppendingString:@"\n\n"];
        } else {
            self.title = @"runtime error info";
        }
        content = [content stringByAppendingString:[Utils getSignalDescription:self.signal]];
    }
    
    self.textInfo.text = content;
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
    if (self.signal > 0){
        [types addObject:[NSNumber numberWithUnsignedInt:RUNTIMEERRINFO]];
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
    for (int i = 0; i < 7; i++) { // all content types
        type = [NSNumber numberWithUnsignedInt:i];
        if (![contentTypes containsObject:type]){
            continue;
        }
        switch (i) {
            case LINK:{
                textToShare = [Utils returnCaretIfNotEmpty:textToShare returnNumbers:2];
                textToShare = [textToShare stringByAppendingFormat:@"A link to the code: http://ideone.com/%@", project.projLink];
                break;
            }
            case SOURCE:{
                textToShare = [Utils returnCaretIfNotEmpty:textToShare returnNumbers:2];
                textToShare = [textToShare stringByAppendingFormat:@"Source code:\n%@", project.projCode];
                break;
            }
            case INPUT:{
                textToShare = [Utils returnCaretIfNotEmpty:textToShare returnNumbers:2];
                textToShare = [textToShare stringByAppendingFormat:@"Input:\n%@", project.projInput];
                break;
            }
            case OUTPUT:{
                textToShare = [Utils returnCaretIfNotEmpty:textToShare returnNumbers:2];
                textToShare = [textToShare stringByAppendingFormat:@"Output:\n%@", self.output];
                break;
            }
            case CMPINFO:{
                textToShare = [Utils returnCaretIfNotEmpty:textToShare returnNumbers:2];
                textToShare = [textToShare stringByAppendingFormat:@"Compiler info:\n%@", self.cmpInfo];
                break;
            }
            case STDERRINFO:{
                textToShare = [Utils returnCaretIfNotEmpty:textToShare returnNumbers:2];
                textToShare = [textToShare stringByAppendingFormat:@"Stderr output:\n%@", self.stdErr];
                break;
            }
            case RUNTIMEERRINFO:{
                textToShare = [Utils returnCaretIfNotEmpty:textToShare returnNumbers:2];
                textToShare = [textToShare stringByAppendingFormat:@"Runtime error info:\n%@",[Utils getSignalDescription:self.signal]];
                break;
            }
        }
    }
    
    [Utils shareText:textToShare overViewController:self];
}
@end

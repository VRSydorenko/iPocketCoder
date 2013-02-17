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
    UIPopoverController* popoverController;
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

- (IBAction)snippetsPressed:(id)sender {
    if (IPAD){
        SnippetsVC *snippetsVC = [[UIStoryboard storyboardWithName:@"iPhoneMain" bundle:nil] instantiateViewControllerWithIdentifier:@"screenSnippets"];
        if (!snippetsVC){
            return;
        }
    
        if (popoverController){
            if ([popoverController isPopoverVisible]){
                [popoverController dismissPopoverAnimated:YES];
                return;
            }
            popoverController = nil;
        }
        popoverController = [[UIPopoverController alloc] initWithContentViewController:snippetsVC];
        [popoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}
@end

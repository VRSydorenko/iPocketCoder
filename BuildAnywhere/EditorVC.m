//
//  EditorVC.m
//  BuildAnywhere
//
//  Created by Viktor Sydorenko on 2/17/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "EditorVC.h"

@interface EditorVC (){
    Project* project;
    UIPopoverController* popoverController;
    MainNavController* navCon;
}
@end

@implementation EditorVC

@synthesize projectName;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    navCon = (MainNavController*)self.navigationController;
    
    if (!IPAD){ // to save more space on navigation bar 
        [navCon createMiniBackButtonWithBackPressedSelectorOnTarget:self];
    }
    
    project = self.projectName.length > 0 ? [DataManager loadProject:self.projectName] : nil;
    self.navigationItem.title = project.projName;
}

-(void) viewDidAppear:(BOOL)animated{
    [navCon showToolbarAnimated:YES];
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

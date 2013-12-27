//
//  ProjectCell.m
//  BuildAnywhere
//
//  Created by Viktor Sydorenko on 2/16/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "ProjectCell.h"
#import "iCloudHandler.h"

@interface ProjectCell(){
    NSString *labelProjectNameValue; // used as a temporary string variable when updating cell behaviour
    ProjectStates lastProjState;
}
@end

@implementation ProjectCell

- (IBAction)deletePressed:(id)sender {
    NSString* question = [NSString stringWithFormat:@"Delete '%@'?", self.labelProjectName.text];
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Confirm deleting" message:question delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1){
        if (self.isProjectLocal){
            [DataManager deleteProject:self.labelProjectName.text];
            [self.delegate projectDeleted];
        } else {
            [self.delegate projectWillBeDeleted:self.labelProjectName.text language:self.tag];
            [[iCloudHandler getInstance] deleteFromCloud:self.labelProjectName.text language:self.tag];
        }
    }
}

-(void)setBehaviour:(ProjectStates)projState{
    if (self.isProjectLocal){
        return; // activity indicator is currently only for iCloud projects
    }
    
    if (lastProjState == IDLE){
        labelProjectNameValue = self.labelProjectName.text;
    }
    switch (projState) {
        case IDLE:
            [self.activityIndicator stopAnimating];
            self.labelProjectName.text = labelProjectNameValue;
            break;
        case SAVING:
            [self.activityIndicator startAnimating];
            self.labelProjectName.text = @"Saving...";
            break;
        case OPENING:
            [self.activityIndicator startAnimating];
            self.labelProjectName.text = @"Opening...";
            break;
        case DELETING:
            [self.activityIndicator startAnimating];
            self.labelProjectName.text = @"Deleting...";
            break;
        case CLOSING:
            [self.activityIndicator startAnimating];
            self.labelProjectName.text = @"Closing...";
            break;
    }
    lastProjState = projState;
}

@end

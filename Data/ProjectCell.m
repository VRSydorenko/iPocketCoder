//
//  ProjectCell.m
//  BuildAnywhere
//
//  Created by Viktor Sydorenko on 2/16/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "ProjectCell.h"

@implementation ProjectCell

- (IBAction)deletePressed:(id)sender {
    NSString* question = [NSString stringWithFormat:@"Delete '%@'?", self.labelProjectName.text];
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Confirm deleting" message:question delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1){
        [DataManager deleteProject:self.labelProjectName.text];
        [self.delegate projectDeleted];
    }
}

@end

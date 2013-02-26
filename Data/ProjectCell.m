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
    [DataManager deleteProject:self.labelProjectName.text];
    [self.delegate projectDeleted];
}

@end

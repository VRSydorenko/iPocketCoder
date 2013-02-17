//
//  EditorVC.h
//  BuildAnywhere
//
//  Created by Viktor Sydorenko on 2/17/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Project.h"
#import "DataManager.h"
#import "SnippetsVC.h"

@interface EditorVC : UIViewController

@property (nonatomic) NSString* projectName;
- (IBAction)snippetsPressed:(id)sender;

@end

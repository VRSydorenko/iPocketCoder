//
//  InputVC.h
//  BuildAnywhere
//
//  Created by Viktor Sydorenko on 2/25/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Project.h"
#import "MainNavController.h"
#import "DataManager.h"

@class InputVC;

@protocol InputUpdateDelegate
-(void) inputUpdatedFromController:(InputVC*)controller;
@end

@interface InputVC : UIViewController

@property (nonatomic) id<InputUpdateDelegate> delegate;
@property (nonatomic) Project* project;
@property (strong, nonatomic) IBOutlet UITextView *textInput;
- (IBAction)clearPressed:(id)sender;
@end

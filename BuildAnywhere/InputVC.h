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

@interface InputVC : UIViewController<UITextViewDelegate>

@property (nonatomic) Project* project;
@property (strong, nonatomic) IBOutlet UITextView *textInput;
- (IBAction)clearPressed:(id)sender;
@end

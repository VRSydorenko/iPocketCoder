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
#import "ResultsVC.h"

@interface EditorVC : UIViewController<UITextViewDelegate>

@property (nonatomic, weak) IBOutlet UITextView *textCode;
@property (nonatomic, strong) IBOutlet UIView *accessoryView;

@property (nonatomic) NSString* projectName;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *flexItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *compileItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *runItem;
- (IBAction)snippetsPressed:(id)sender;
- (IBAction)hideKeyboardPressed:(id)sender;
- (IBAction)compilePressed:(id)sender;
- (IBAction)runPressed:(id)sender;

@end

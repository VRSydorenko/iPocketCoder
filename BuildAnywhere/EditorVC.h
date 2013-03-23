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
#import "ideoneIdeone_Service_v1Service.h"
#import "RunManager.h"
#import "InputVC.h"
#import "UserSettings.h"
#import "QuickSymbolManager.h"

@interface EditorVC : UIViewController<UITextViewDelegate,
                                       IdeoneResponseProtocol,
                                       SnippetSelectionDelegate,
                                       SymbolsEditorDelegate,
                                       RotationTrigger>

@property (nonatomic, weak) IBOutlet UITextView *textCode;
@property (nonatomic, weak) IBOutlet UIButton *btnShortkeysSettings;
@property (nonatomic, strong) IBOutlet UIView *accessoryView;

@property (nonatomic) NSString* projectName;
@property (strong, nonatomic) IBOutlet UIButton *btnHideKeyboard;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *flexItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *inputItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *runItem;
- (IBAction)snippetsPressed:(id)sender;
- (IBAction)hideKeyboardPressed:(id)sender;
- (IBAction)inputPressed:(id)sender;
- (IBAction)runPressed:(id)sender;
- (IBAction)accessorySmallSettingsButtonPressed;

@end

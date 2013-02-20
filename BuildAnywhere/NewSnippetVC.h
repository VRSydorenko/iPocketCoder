//
//  NewSnippetVC.h
//  BuildAnywhere
//
//  Created by Viktor Sydorenko on 2/18/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Utils.h"
#import "MainNavController.h"
#import "DataManager.h"

@class NewSnippetVC;

@protocol NewSnippetCreationDelegate
-(void) newSnippetCreationFinished:(BOOL)snippetCreated fromController:(NewSnippetVC*)controller;
@end

@interface NewSnippetVC : UIViewController

@property (nonatomic) int language;

@property (strong, nonatomic) IBOutlet UITextField *textName;
@property (strong, nonatomic) IBOutlet UITextView *textCode;
@property (strong, nonatomic) id<NewSnippetCreationDelegate> delegate;
- (IBAction)addPressed:(id)sender;
@end

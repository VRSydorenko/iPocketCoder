//
//  InputVC.h
//  BuildAnywhere
//
//  Created by Viktor Sydorenko on 2/25/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainNavController.h"

@protocol InputTextDelegate <NSObject>
-(void)inputTextChangedTo:(NSString*)input;
@end

@interface InputVC : UIViewController<UITextViewDelegate>

@property (nonatomic) id<InputTextDelegate> delegate;
@property NSString* textForInputInit;

@property (strong, nonatomic) IBOutlet UITextView *textInput;
- (IBAction)clearPressed:(id)sender;
@end

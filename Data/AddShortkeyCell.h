//
//  AddShortkeyCell.h
//  PocketCoder
//
//  Created by Viktor Sydorenko on 3/27/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utils.h"

@protocol NewShortkeyCreationDelegate <NSObject>
-(void)wishToCreateNewShortkeyWithSymbol:(NSString*)text;
@end

@interface AddShortkeyCell : UITableViewCell<UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UITextView *textShortkey;
@property (strong, nonatomic) IBOutlet UIButton *btnAdd;
@property (nonatomic) id<NewShortkeyCreationDelegate> shortkeyCreationDelegate;

-(IBAction)addSymbolPressed;

@end

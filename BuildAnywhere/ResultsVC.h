//
//  ResultsVC.h
//  BuildAnywhere
//
//  Created by Viktor Sydorenko on 2/24/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainNavController.h"

@interface ResultsVC : UIViewController

@property (nonatomic) NSString* cmpInfo;
@property (nonatomic) NSString* output;
@property (strong, nonatomic) IBOutlet UITextView *textInfo;

- (IBAction)cmpInfoPressed:(id)sender;
- (IBAction)outputPressed:(id)sender;

@end

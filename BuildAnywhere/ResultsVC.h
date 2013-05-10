//
//  ResultsVC.h
//  BuildAnywhere
//
//  Created by Viktor Sydorenko on 2/24/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainNavController.h"
#import "ShareManagerVC.h"
#import "Utils.h"
#import "Project.h"
#import "DataManager.h"

@interface ResultsVC : UIViewController<ShareManagerProtocol>

@property (nonatomic) NSString* projectName;
@property (nonatomic) NSString* cmpInfo;
@property (nonatomic) NSString* output;
@property (nonatomic) NSString* stdErr;
@property (nonatomic) int       signal;
@property (strong, nonatomic) IBOutlet UITextView *textInfo;

- (IBAction)cmpInfoPressed:(id)sender;
- (IBAction)outputPressed:(id)sender;
- (IBAction)sharePressed:(id)sender;

@end

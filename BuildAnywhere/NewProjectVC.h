//
//  NewProjectVC.h
//  BuildAnywhere
//
//  Created by Viktor Sydorenko on 2/17/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"

@protocol NewProjectCreationDelegate

-(void) newProjectCreated;

@end

@interface NewProjectVC : UIViewController<UITableViewDataSource,
                                           UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITextField *textName;
@property (strong, nonatomic) IBOutlet UITableView *tableLanguages;
@property (strong, nonatomic) id<NewProjectCreationDelegate> delegate;

- (IBAction)didEndOnExit:(UITextField *)sender;
- (IBAction)createPressed:(id)sender;
@end

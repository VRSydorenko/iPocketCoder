//
//  NewProjectVC.h
//  BuildAnywhere
//
//  Created by Viktor Sydorenko on 2/17/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"

@interface NewProjectVC : UIViewController<UITableViewDataSource,
                                           UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableLanguages;
- (IBAction)didEndOnExit:(UITextField *)sender;
@end

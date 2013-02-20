//
//  SnippetsVC.h
//  BuildAnywhere
//
//  Created by Viktor Sydorenko on 2/17/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utils.h"
#import "MainNavController.h"
#import "DataManager.h"
#import "NewSnippetVC.h"

@interface SnippetsVC : UIViewController<UITableViewDataSource,
                                         UITableViewDelegate,
                                         NewSnippetCreationDelegate>

@property (nonatomic) int language;
@property (strong, nonatomic) IBOutlet UITableView *tableSnippets;

@end

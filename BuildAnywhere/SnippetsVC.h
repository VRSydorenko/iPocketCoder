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

@class SnippetsVC;

@protocol SnippetSelectionDelegate <NSObject>
-(void)snippetSelected:(NSString*)code;
@end

@interface SnippetsVC : UIViewController<UITableViewDataSource,
                                         UITableViewDelegate,
                                         NewSnippetCreationDelegate>

@property (nonatomic) id<SnippetSelectionDelegate> delegate;
@property (nonatomic) int language;
@property (strong, nonatomic) IBOutlet UITableView *tableSnippets;

@end

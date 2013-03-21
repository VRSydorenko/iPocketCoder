//
//  QuickSymbolManager.h
//  PocketCoder
//
//  Created by Viktor Sydorenko on 3/15/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainNavController.h"
#import "DataManager.h"
#import "ShortkeyCell.h"
#import "Utils.h"

@protocol SymbolsEditorDelegate <NSObject>
-(void)symbolsLayoutChanged;
@end

@interface QuickSymbolManager : UIViewController<UITableViewDataSource,
                                                 UITableViewDelegate>

@property (nonatomic) int projectLanguge;
@property (nonatomic) id<SymbolsEditorDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITableView *tableSymbols;
@end

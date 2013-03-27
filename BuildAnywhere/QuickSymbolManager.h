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
#import "AddShortkeyCell.h"
#import "Utils.h"

typedef enum SymbolsLayoutChange {
    SYMBOL_ADDED = 0,
    SYMBOL_DELETED = 1,
    SYMBOL_MOVED = 2, // order changed
    SYMBOL_STATE_CHANGED = 3, // ticked on/off
    SCREEN_ROTATED = 4, // caused by screen orientation change
} SymbolsLayoutChange;

@protocol SymbolsEditorDelegate <NSObject>
-(void)symbolsLayoutChanged:(SymbolsLayoutChange)action;
@end

@interface QuickSymbolManager : UIViewController<UITableViewDataSource,
                                                 UITableViewDelegate,
                                                 NewShortkeyCreationDelegate>

@property (nonatomic) int projectLanguge;
@property (nonatomic) id<SymbolsEditorDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITableView *tableSymbols;
@end

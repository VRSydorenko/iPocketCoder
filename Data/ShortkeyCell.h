//
//  ShortkeyCell.h
//  PocketCoder
//
//  Created by Viktor Sydorenko on 3/20/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShortkeyCell : UITableViewCell

@property (nonatomic) BOOL isActive;
@property (strong, nonatomic) IBOutlet UIView *viewBg;
@property (strong, nonatomic) IBOutlet UILabel *labelShortkey;

@end

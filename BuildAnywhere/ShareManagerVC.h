//
//  ShareManagerVC.h
//  PocketCoder
//
//  Created by Viktor Sydorenko on 5/5/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShareManagerProtocol <NSObject>
-(void)shareManagerDidSelectContentToShare:(NSArray*)contentTypes;
@end

typedef NS_ENUM(NSUInteger, ShareContentType) {
    LINK = 0,
    SOURCE,
    INPUT,
    OUTPUT,
    CMPINFO,
    STDERRINFO,
};

@interface ShareManagerVC : UIViewController<UITableViewDataSource,
                                             UITableViewDelegate>

- (IBAction)sharePressed:(id)sender;

@property (nonatomic) NSArray *availableContentTypes; // array of items of type: ShareContrntType
@property (nonatomic) id<ShareManagerProtocol> delegate;

@property (strong, nonatomic) IBOutlet UITableView *tableContent;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *shareItem;

@end

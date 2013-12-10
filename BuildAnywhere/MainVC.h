//
//  MainVC.h
//  BuildAnywhere
//
//  Created by Viktor Sydorenko on 2/16/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "NewProjectVC.h"
#import "EditorVC.h"
#import "ProjectCell.h"
#import "iCloudHandler.h"

@interface MainVC : UIViewController<UICollectionViewDataSource,
                                     UICollectionViewDelegate,
                                     NewProjectCreationDelegate,
                                     ProjectDeletionProtocol,
                                     iCloudHandlerDelegate>


@property (strong, nonatomic) IBOutlet UICollectionView *collectionProjects;
@property (strong, nonatomic) IBOutlet UILabel *labelHeader;

- (IBAction)createNewProjectPressed:(id)sender;

@end

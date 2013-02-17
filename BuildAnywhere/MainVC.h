//
//  MainVC.h
//  BuildAnywhere
//
//  Created by Viktor Sydorenko on 2/16/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"

@interface MainVC : UIViewController<UICollectionViewDataSource,
                                     UICollectionViewDelegate>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionProjects;

- (IBAction)createNewProjectPressed:(id)sender;
@end

//
//  ProjectCell.h
//  BuildAnywhere
//
//  Created by Viktor Sydorenko on 2/16/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"

@protocol ProjectDeletionProtocol <NSObject>
-(void)projectDeleted;
@end

@interface ProjectCell : UICollectionViewCell<UIAlertViewDelegate>

@property (nonatomic) id<ProjectDeletionProtocol> delegate;
@property (strong, nonatomic) IBOutlet UILabel *labelProjectName;
@property (strong, nonatomic) IBOutlet UILabel *labelProjectLanguage;
@property (nonatomic) BOOL isProjectLocal;

- (IBAction)deletePressed:(id)sender;
@end

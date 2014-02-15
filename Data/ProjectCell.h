//
//  ProjectCell.h
//  BuildAnywhere
//
//  Created by Viktor Sydorenko on 2/16/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"

@protocol ProjectCellDelegate <NSObject>
-(void)projectDeleted;
-(void)projectWillBeDeleted:(NSString*)name language:(int)lang;
@end

@interface ProjectCell : UICollectionViewCell<UIAlertViewDelegate>

@property (nonatomic) id<ProjectCellDelegate> delegate;
@property (strong, nonatomic) IBOutlet UILabel *labelProjectName;
@property (strong, nonatomic) IBOutlet UILabel *labelProjectLanguage;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UIButton *buttonDelete;

@property (nonatomic) BOOL isProjectLocal;

- (IBAction)deletePressed:(id)sender;

-(void)setBehaviour:(ProjectStates)projState;

@end

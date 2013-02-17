//
//  ProjectCell.h
//  BuildAnywhere
//
//  Created by Viktor Sydorenko on 2/16/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UILabel *labelProjectName;
@property (strong, nonatomic) IBOutlet UILabel *labelProjectLanguage;

@end

//
//  AppDelegate.h
//  BuildAnywhere
//
//  Created by Viktor Sydorenko on 2/16/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DbManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,
                                      UIAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;

@property DbManager *dbManager;
@property (readonly) NSURL *ubiquityContainerUrl;

@end

//
//  DataManager.h
//  BuildAnywhere
//
//  Created by Viktor Sydorenko on 2/16/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "Utils.h"
#import "ProjectCell.h"

@interface DataManager : NSObject

+(int) saveProject:(Project*)project;

+(NSDictionary*) getLanguages;
+(NSString*) getLanguageName:(int)language;
+(NSDictionary*) getProjectsBasicInfo;

@end

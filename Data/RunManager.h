//
//  RunManager.h
//  BuildAnywhere
//
//  Created by Viktor Sydorenko on 2/24/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ideoneIdeone_Service_v1Service.h"
#import "Project.h"

#define USER @"ideonevrs"
#define PASS @"ideonevrsapi"

@interface RunManager : NSObject

-(void)createSubmission:(Project*)project run:(BOOL)run;
-(void)getLanguages;
-(void)getSubmissionDetails:(NSString*)link;
-(void)getSubmissionStatus:(NSString*)link;
-(void)testFunction;

@end

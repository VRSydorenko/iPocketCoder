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

typedef enum ErrorCodes{
    OK              = 0,
    AUTH_ERROR      = 1,
    PASTE_NOT_FOUND = 2,
    WRONG_LANG_ID   = 3,
    ACCESS_DENIED   = 4,
    CANNOT_SUBMIT_THIS_MONTH_ANYMORE = 5,
    UNDEFINED       = 6,
} ErrorCodes;

typedef enum ResultCodes{
    NOT_RUNNING     = 0,
    COMPILATION_ERROR   = 11,
    RUNTIME_ERROR   = 12,
    TIME_LIMIT_EXCEEDED = 13,
    SUCCESS         = 15,
    MEMORY_LIMIT_EXCEEDED = 17,
    ILLEGAL_SYSTEM_CALL = 19,
    INTERNAL_ERROR  = 20,
} ResultCodes;

@interface RunManager : NSObject

@property (nonatomic) id<IdeoneResponseProtocol> handler;

-(void)createSubmission:(Project*)project run:(BOOL)run;
-(void)getLanguages;
-(void)getSubmissionDetails:(NSString*)link;
-(void)getSubmissionStatus:(NSString*)link;
-(void)testFunction;

-(NSString*)getErrorDescription:(ErrorCodes)error;

@end

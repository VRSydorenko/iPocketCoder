//
//  RunManager.m
//  BuildAnywhere
//
//  Created by Viktor Sydorenko on 2/24/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "RunManager.h"

@implementation RunManager{
    ideoneIdeone_Service_v1Service *service;
}

-(id) init{
    self = [super init];
    if (self){
        service = [[ideoneIdeone_Service_v1Service alloc] initWithUsername:USER andPassword:PASS];
    }
    return self;
}

-(void) dealloc{
    service = nil;
}

-(void)createSubmission:(Project*)project run:(BOOL)run{
    [service createSubmission:self action:@selector(createSubmissionHandler:) sourceCode:[self wrapCode:project.projCode] language:project.projLanguage input:project.projInput run:run private:NO];
}

-(void)getLanguages{
    [service getLanguages:self action:@selector(getLanguagesHandler:)];
}

-(void)getSubmissionDetails:(NSString*)link{
    [service getSubmissionDetails:self action:@selector(getSubmissionDetailsHandler:) link:link withSource:NO withInput:NO withOutput:NO withStderr:NO withCmpinfo:NO];
}

-(void)getSubmissionStatus:(NSString*)link{
    [service getSubmissionStatus:self action:@selector(getSubmissionStatusHandler:) link:link];
}

-(void)testFunction{
    [service testFunction:self action:@selector(testFunctionHandler:)];
}

// handlers

- (void) createSubmissionHandler:(id)value {
	if ([self isError:value]){
        return;
    }
    
    NSLog(@"%@", value);
    
    NSString* valueString = [(NSDictionary*)value objectForKey:@"return"];
    
    NSRange rangeLink = [valueString rangeOfString:@"link"];
    NSString *link = [valueString substringFromIndex:NSMaxRange(rangeLink)];
    
    NSRange rangeRest = {0, rangeLink.location};
    valueString = [valueString substringWithRange:rangeRest];
    
    NSRange rangeError = [valueString rangeOfString:@"error"];
    NSString* error = [valueString substringFromIndex:NSMaxRange(rangeError)];
    ErrorCodes errorCode = [self stringToErrorCode:error];
    
    [self.handler submissionCreatedWithError:errorCode andLink:link];
}

- (void) getLanguagesHandler:(id)value {
    if ([self isError:value]){
        return;
    }
    NSLog(@"%@", value);
}

- (void) getSubmissionDetailsHandler:(id)value {
	if ([self isError:value]){
        return;
    }
    NSLog(@"%@", value);
}

- (void) getSubmissionStatusHandler:(id)value {
    if ([self isError:value]){
        return;
    }
    
    NSString* valueString = [(NSDictionary*)value objectForKey:@"return"];
    
    NSRange rangeResult = [valueString rangeOfString:@"result"];
    int result = [valueString substringFromIndex:NSMaxRange(rangeResult)].intValue;
    
    NSRange rangeRest = {0, rangeResult.location};
    valueString = [valueString substringWithRange:rangeRest];
    
    NSRange rangeStatus = [valueString rangeOfString:@"status"];
    int status = [valueString substringFromIndex:NSMaxRange(rangeStatus)].intValue;
    
    NSRange rangeRest2 = {0, rangeStatus.location};
    valueString = [valueString substringWithRange:rangeRest2];
    
    NSRange rangeError = [valueString rangeOfString:@"error"];
    NSString* error = [valueString substringFromIndex:NSMaxRange(rangeError)];
    ErrorCodes errorCode = [self stringToErrorCode:error];
    
    [self.handler submissionStatusReceived:status error:errorCode result:result];
}


- (void) testFunctionHandler:(id)value {
    if ([self isError:value]){
        return;
    }
    NSLog(@"%@", value);
}

-(BOOL)isError:(id)value{
    // Handle errors
	if([value isKindOfClass:[NSError class]]) {
		NSLog(@"%@", value);
		return YES;
	}
    
	// Handle faults
	if([value isKindOfClass:[SoapFault class]]) {
		NSLog(@"%@", value);
		return YES;
	}
    return NO;
}

-(NSString*)wrapCode:(NSString*)code{
    return [NSString stringWithFormat:@"<![CDATA[%@]]>", code];
}

-(NSString*)getErrorDescription:(ErrorCodes)error{
    switch (error) {
        case OK:
            return @"OK";
        case AUTH_ERROR:
            return @"User name or user's password are invalid";
        case PASTE_NOT_FOUND:
            return @"Paste with specified link could not be found";
        case WRONG_LANG_ID:
            return @"Language with specified id does not exist";
        case ACCESS_DENIED:
            return @"Access to the resource id denied for the specified user";
        case CANNOT_SUBMIT_THIS_MONTH_ANYMORE:
            return @"You have reached a monthly limit";
        case UNDEFINED:
            return @"Unknown error";
    }
    return @"";
}
-(ErrorCodes)stringToErrorCode:(NSString*)string{
    if ([string isEqualToString:@"OK"]){
        return OK;
    } else if ([string isEqualToString:@"AUTH_ERROR"]){
        return AUTH_ERROR;
    } else if ([string isEqualToString:@"PASTE_NOT_FOUND"]){
        return PASTE_NOT_FOUND;
    } else if ([string isEqualToString:@"WRONG_LANG_ID"]){
        return WRONG_LANG_ID;
    } else if ([string isEqualToString:@"ACCESS_DENIED"]){
        return ACCESS_DENIED;
    } else if ([string isEqualToString:@"CANNOT_SUBMIT_THIS_MONTH_ANYMORE"]){
        return CANNOT_SUBMIT_THIS_MONTH_ANYMORE;
    }
    return UNDEFINED;
}

@end

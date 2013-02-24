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
    [service createSubmission:self action:@selector(createSubmissionHandler:) sourceCode:project.projCode language:project.projLanguage input:@"" run:run private:NO];
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
	// Handle errors
	if([value isKindOfClass:[NSError class]]) {
		NSLog(@"%@", value);
		return;
	}
    
	// Handle faults
	if([value isKindOfClass:[SoapFault class]]) {
		NSLog(@"%@", value);
		return;
	}
    
	// Do something with the ideoneArray* result
	//	ideoneArray* result = (ideoneArray*)value;
	//NSLog(@"createSubmission returned the value: %@", result);
}

- (void) getLanguagesHandler:(id)value {
    
	// Handle errors
	if([value isKindOfClass:[NSError class]]) {
		NSLog(@"%@", value);
		return;
	}
    
	// Handle faults
	if([value isKindOfClass:[SoapFault class]]) {
		NSLog(@"%@", value);
		return;
	}
    
	// Do something with the ideoneArray* result
	//	ideoneArray* result = (ideoneArray*)value;
	NSLog(@"getLanguages returned the value: %@", value);
}

- (void) getSubmissionDetailsHandler:(id)value {
	// Handle errors
	if([value isKindOfClass:[NSError class]]) {
		NSLog(@"%@", value);
		return;
	}
    
	// Handle faults
	if([value isKindOfClass:[SoapFault class]]) {
		NSLog(@"%@", value);
		return;
	}

	// Do something with the ideoneArray* result
	//	ideoneArray* result = (ideoneArray*)value;
	NSLog(@"getSubmissionDetails returned the value: %@", value);
}

- (void) getSubmissionStatusHandler:(id)value {
    
	// Handle errors
	if([value isKindOfClass:[NSError class]]) {
		NSLog(@"%@", value);
		return;
	}
    
	// Handle faults
	if([value isKindOfClass:[SoapFault class]]) {
		NSLog(@"%@", value);
		return;
	}
    
	// Do something with the ideoneArray* result
	//	ideoneArray* result = (ideoneArray*)value;
	NSLog(@"getSubmissionStatus returned the value: %@", value);
}


- (void) testFunctionHandler: (id) value {
    // Handle errors
	if([value isKindOfClass:[NSError class]]) {
		NSLog(@"%@", value);
		return;
	}
    
	// Handle faults
	if([value isKindOfClass:[SoapFault class]]) {
		NSLog(@"%@", value);
		return;
	}
        
	// Do something with the ideoneArray* result
	//	ideoneArray* result = (ideoneArray*)value;
	NSLog(@"testFunction returned the value: %@", value);
}

@end

/*
	ideoneIdeone_Service_v1Service.m
	The implementation classes and methods for the Ideone_Service_v1Service web service.
	Generated by SudzC.com
*/

#import "ideoneIdeone_Service_v1Service.h"
				
#import "Soap.h"
	

/* Implementation of the service */
				
@implementation ideoneIdeone_Service_v1Service

	- (id) init
	{
		if(self = [super init])
		{
			self.serviceUrl = @"http://ideone.com/api/1/service";
			self.namespace = @"http://ideone.com/api/1/service";
			self.headers = nil;
			self.logging = NO;
		}
		return self;
	}
	
	- (id) initWithUsername: (NSString*) username andPassword: (NSString*) password {
		if(self = [super initWithUsername:username andPassword:password]) {
		}
		return self;
	}
	
	+ (ideoneIdeone_Service_v1Service*) service {
		return [ideoneIdeone_Service_v1Service serviceWithUsername:nil andPassword:nil];
	}
	
	+ (ideoneIdeone_Service_v1Service*) serviceWithUsername: (NSString*) username andPassword: (NSString*) password {
		return [[ideoneIdeone_Service_v1Service alloc] initWithUsername:username andPassword:password];
	}

		
	// Returns ideoneArray*
	/* Creates a new submission. */
	- (SoapRequest*) createSubmission: (id <SoapDelegate>) handler user: (NSString*) user pass: (NSString*) pass sourceCode: (NSString*) sourceCode language: (int) language input: (NSString*) input run: (BOOL) run private: (BOOL) private
	{
		return [self createSubmission: handler action: nil user: user pass: pass sourceCode: sourceCode language: language input: input run: run private: private];
	}

	- (SoapRequest*) createSubmission: (id) _target action: (SEL) _action user: (NSString*) user pass: (NSString*) pass sourceCode: (NSString*) sourceCode language: (int) language input: (NSString*) input run: (BOOL) run private: (BOOL) private
		{
		NSMutableArray* _params = [NSMutableArray array];
		
		[_params addObject: [[SoapParameter alloc] initWithValue: user forName: @"user"]];
		[_params addObject: [[SoapParameter alloc] initWithValue: pass forName: @"pass"]];
		[_params addObject: [[SoapParameter alloc] initWithValue: sourceCode forName: @"sourceCode"]];
		[_params addObject: [[SoapParameter alloc] initWithValue: [NSNumber numberWithInt: language] forName: @"language"]];
		[_params addObject: [[SoapParameter alloc] initWithValue: input forName: @"input"]];
		[_params addObject: [[SoapParameter alloc] initWithValue: [NSNumber numberWithBool: run] forName: @"run"]];
		[_params addObject: [[SoapParameter alloc] initWithValue: [NSNumber numberWithBool: private] forName: @"private"]];
		NSString* _envelope = [Soap createEnvelope: @"createSubmission" forNamespace: self.namespace withParameters: _params withHeaders: self.headers];
		SoapRequest* _request = [SoapRequest create: _target action: _action service: self soapAction: @"http://ideone.com/api/1/service#createSubmission" postData: _envelope deserializeTo: /*[ideoneArray alloc]*/nil];
		[_request send];
		return _request;
	}

	// Returns ideoneArray*
	/* Returns status and result of a submission in an associative array. */
	- (SoapRequest*) getSubmissionStatus: (id <SoapDelegate>) handler user: (NSString*) user pass: (NSString*) pass link: (NSString*) link
	{
		return [self getSubmissionStatus: handler action: nil user: user pass: pass link: link];
	}

	- (SoapRequest*) getSubmissionStatus: (id) _target action: (SEL) _action user: (NSString*) user pass: (NSString*) pass link: (NSString*) link
		{
		NSMutableArray* _params = [NSMutableArray array];
		
		[_params addObject: [[SoapParameter alloc] initWithValue: user forName: @"user"]];
		[_params addObject: [[SoapParameter alloc] initWithValue: pass forName: @"pass"]];
		[_params addObject: [[SoapParameter alloc] initWithValue: link forName: @"link"]];
		NSString* _envelope = [Soap createEnvelope: @"getSubmissionStatus" forNamespace: self.namespace withParameters: _params withHeaders: self.headers];
		SoapRequest* _request = [SoapRequest create: _target action: _action service: self soapAction: @"http://ideone.com/api/1/service#getSubmissionStatus" postData: _envelope deserializeTo: /*[ideoneArray alloc]*/nil];
		[_request send];
		return _request;
	}

	// Returns ideoneArray*
	/* Returns information about the submission in an associative array. */
	- (SoapRequest*) getSubmissionDetails: (id <SoapDelegate>) handler user: (NSString*) user pass: (NSString*) pass link: (NSString*) link withSource: (BOOL) withSource withInput: (BOOL) withInput withOutput: (BOOL) withOutput withStderr: (BOOL) withStderr withCmpinfo: (BOOL) withCmpinfo
	{
		return [self getSubmissionDetails: handler action: nil user: user pass: pass link: link withSource: withSource withInput: withInput withOutput: withOutput withStderr: withStderr withCmpinfo: withCmpinfo];
	}

	- (SoapRequest*) getSubmissionDetails: (id) _target action: (SEL) _action user: (NSString*) user pass: (NSString*) pass link: (NSString*) link withSource: (BOOL) withSource withInput: (BOOL) withInput withOutput: (BOOL) withOutput withStderr: (BOOL) withStderr withCmpinfo: (BOOL) withCmpinfo
		{
		NSMutableArray* _params = [NSMutableArray array];
		
		[_params addObject: [[SoapParameter alloc] initWithValue: user forName: @"user"]];
		[_params addObject: [[SoapParameter alloc] initWithValue: pass forName: @"pass"]];
		[_params addObject: [[SoapParameter alloc] initWithValue: link forName: @"link"]];
		[_params addObject: [[SoapParameter alloc] initWithValue: [NSNumber numberWithBool: withSource] forName: @"withSource"]];
		[_params addObject: [[SoapParameter alloc] initWithValue: [NSNumber numberWithBool: withInput] forName: @"withInput"]];
		[_params addObject: [[SoapParameter alloc] initWithValue: [NSNumber numberWithBool: withOutput] forName: @"withOutput"]];
		[_params addObject: [[SoapParameter alloc] initWithValue: [NSNumber numberWithBool: withStderr] forName: @"withStderr"]];
		[_params addObject: [[SoapParameter alloc] initWithValue: [NSNumber numberWithBool: withCmpinfo] forName: @"withCmpinfo"]];
		NSString* _envelope = [Soap createEnvelope: @"getSubmissionDetails" forNamespace: self.namespace withParameters: _params withHeaders: self.headers];
		SoapRequest* _request = [SoapRequest create: _target action: _action service: self soapAction: @"http://ideone.com/api/1/service#getSubmissionDetails" postData: _envelope deserializeTo: /*[ideoneArray alloc]*/nil];
		[_request send];
		return _request;
	}

	// Returns ideoneArray*
	/* Returns list of supported languages. */
	- (SoapRequest*) getLanguages: (id <SoapDelegate>) handler user: (NSString*) user pass: (NSString*) pass
	{
		return [self getLanguages: handler action: nil user: user pass: pass];
	}

	- (SoapRequest*) getLanguages: (id) _target action: (SEL) _action user: (NSString*) user pass: (NSString*) pass
		{
		NSMutableArray* _params = [NSMutableArray array];
		
		[_params addObject: [[SoapParameter alloc] initWithValue: user forName: @"user"]];
		[_params addObject: [[SoapParameter alloc] initWithValue: pass forName: @"pass"]];
		NSString* _envelope = [Soap createEnvelope: @"getLanguages" forNamespace: self.namespace withParameters: _params withHeaders: self.headers];
		SoapRequest* _request = [SoapRequest create: _target action: _action service: self soapAction: @"http://ideone.com/api/1/service#getLanguages" postData: _envelope deserializeTo: /*[ideoneArray alloc]*/nil];
		[_request send];
		return _request;
	}

	// Returns ideoneArray*
	/* This is a test function. If you can call it successfully, 
then you will also be able to call the other functions. */
	- (SoapRequest*) testFunction: (id <SoapDelegate>) handler user: (NSString*) user pass: (NSString*) pass
	{
		return [self testFunction: handler action: nil user: user pass: pass];
	}

	- (SoapRequest*) testFunction: (id) _target action: (SEL) _action user: (NSString*) user pass: (NSString*) pass
		{
		NSMutableArray* _params = [NSMutableArray array];
		
		[_params addObject: [[SoapParameter alloc] initWithValue: user forName: @"user"]];
		[_params addObject: [[SoapParameter alloc] initWithValue: pass forName: @"pass"]];
		NSString* _envelope = [Soap createEnvelope: @"testFunction" forNamespace: self.namespace withParameters: _params withHeaders: self.headers];
		SoapRequest* _request = [SoapRequest create: _target action: _action service: self soapAction: @"http://ideone.com/api/1/service#testFunction" postData: _envelope deserializeTo: /*[ideoneArray alloc]*/nil];
		[_request send];
		return _request;
	}


@end
	
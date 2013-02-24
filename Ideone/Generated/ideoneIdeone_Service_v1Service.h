/*
	ideoneIdeone_Service_v1Service.h
	The interface definition of classes and methods for the Ideone_Service_v1Service web service.
	Generated by SudzC.com
*/
				
#import "Soap.h"
	
/* Interface for the service */
				
@interface ideoneIdeone_Service_v1Service : SoapService
// Creates a new submission.
- (SoapRequest*) createSubmission:(id<SoapDelegate>)handler sourceCode:(NSString*)sourceCode language:(int)language input:(NSString*)input run:(BOOL)run private:(BOOL)private;
- (SoapRequest*) createSubmission:(id)target action:(SEL)action sourceCode:(NSString*)sourceCode language:(int)language input:(NSString*)input run:(BOOL)run private:(BOOL) private;

// Returns status and result of a submission in an associative array.
- (SoapRequest*) getSubmissionStatus:(id<SoapDelegate>)handler link:(NSString*)link;
- (SoapRequest*) getSubmissionStatus:(id)target action:(SEL)action link:(NSString*)link;

// Returns information about the submission in an associative array.
- (SoapRequest*) getSubmissionDetails:(id<SoapDelegate>)handler link:(NSString*)link withSource:(BOOL)withSource withInput:(BOOL)withInput withOutput:(BOOL)withOutput withStderr:(BOOL)withStderr withCmpinfo:(BOOL)withCmpinfo;
- (SoapRequest*) getSubmissionDetails:(id)target action:(SEL)action link:(NSString*)link withSource:(BOOL)withSource withInput:(BOOL)withInput withOutput:(BOOL)withOutput withStderr:(BOOL)withStderr withCmpinfo:(BOOL)withCmpinfo;

// Returns list of supported languages.
- (SoapRequest*) getLanguages:(id<SoapDelegate>)handler;
- (SoapRequest*) getLanguages:(id)target action:(SEL)action;

// This is a test function. If you can call it successfully, then you will also be able to call the other functions.
- (SoapRequest*) testFunction:(id<SoapDelegate>)handler;
- (SoapRequest*) testFunction:(id)target action:(SEL)action;
    
@end
	
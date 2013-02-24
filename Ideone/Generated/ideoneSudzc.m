/*
	ideoneSudzc.m
	Creates a list of the services available with the ideone prefix.
	Generated by SudzC.com
*/
#import "ideoneSudzc.h"

@implementation ideoneSudzC

@synthesize logging, server, defaultServer;

@synthesize ideone_Service_v1Service;


#pragma mark Initialization

-(id)initWithServer:(NSString*)serverName{
	if(self = [self init]) {
		self.server = serverName;
	}
	return self;
}

+(ideoneSudzC*)sudzc{
	return (ideoneSudzC*)[[ideoneSudzC alloc] init];
}

+(ideoneSudzC*)sudzcWithServer:(NSString*)serverName{
	return (ideoneSudzC*)[[ideoneSudzC alloc] initWithServer:serverName];
}

#pragma mark Methods

-(void)setLogging:(BOOL)value{
	logging = value;
	[self updateServices];
}

-(void)setServer:(NSString*)value{
	server = value;
	[self updateServices];
}

-(void)updateServices{

	[self updateService: self.ideone_Service_v1Service];
}

-(void)updateService:(SoapService*)service{
	service.logging = self.logging;
	if(self.server == nil || self.server.length < 1) { return; }
	service.serviceUrl = [service.serviceUrl stringByReplacingOccurrencesOfString:defaultServer withString:self.server];
}

#pragma mark Getter Overrides


-(ideoneIdeone_Service_v1Service*)ideone_Service_v1Service{
	if(ideone_Service_v1Service == nil) {
		ideone_Service_v1Service = [[ideoneIdeone_Service_v1Service alloc] init];
	}
	return ideone_Service_v1Service;
}


@end
			
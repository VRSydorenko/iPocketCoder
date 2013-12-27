//
//  Project.m
//  BuildAnywhere
//
//  Created by Viktor Sydorenko on 2/16/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "Project.h"
#import "DataManager.h"
#import "iCloudHandler.h"

#define KEY_SEP_DATA @"§k$sep:"

@implementation Project

-(id) initInCloudWithLanguage:(int)language name:(NSString*)name{
    NSURL *url = [[iCloudHandler getInstance] makeDocURLForProject:name language:language];
    
    self = [super initWithFileURL:url];
    if (self){
        [self baseInitWithLanguage:language name:name];
        _isInCloud = YES;
    }
    return self;
}

-(id) initWithLanguage:(int)language name:(NSString*)name{
    NSURL *url = [[iCloudHandler getInstance] makeDocURLForProject:name language:language];
    
    self = [super initWithFileURL:url];
    if (self){
        [self baseInitWithLanguage:language name:name];
        _isInCloud = NO;
    }
    return self;
}

-(void)baseInitWithLanguage:(int)language name:(NSString*)name{
    _projLanguage = language;
    _projName = name;
    [self setCode:[Utils codeTemplateForLanguage:language]];
    [self setLink:@""];
    [self setId:-1];
    [self setInput:@""];
}

-(void) setId:(int)iD{
    _projId = iD;
}

-(void) setCode:(NSString*)code{
    _projCode = code;
}

-(void) setLink:(NSString*)link{
    _projLink = link;
}

-(void) setInput:(NSString*)input{
    _projInput = input;
}

-(void)save{
    if (self.isInCloud){
        DLog(@"Project will be saved in cloud");
        [[iCloudHandler getInstance] updateInCloud:self];
    } else {
        DLog(@"Project will be saved locally");
        [DataManager saveProject:self];
    }
}

-(void)remove{
    if (self.isInCloud){
        [[iCloudHandler getInstance] deleteFromCloud:self.projName language:self.projLanguage];
    } else {
        [DataManager deleteProject:self.projName];
    }
}

-(void)close{
    if (self.isInCloud){
        [[iCloudHandler getInstance] closeDocument:self];
    } else {
        [self save];
    }
}

#pragma mark UIDocument methods

- (void) handleError:(NSError *)error userInteractionPermitted:(BOOL)userInteractionPermitted{
    NSLog(@"error: %@", [error description]);
    NSLog(@"permitted: %d", userInteractionPermitted);
}

-(id)contentsForType:(NSString *)typeName error:(NSError *__autoreleasing *)outError{
    NSString *content = [self serializeProject];
    DLog(@"Serialization: %@", content);
    
    return [NSData dataWithBytes:content.UTF8String length:[content length]];
}

-(BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError *__autoreleasing *)outError{
    if ([contents length] > 0){
        NSString *content = [[NSString alloc] initWithBytes:[contents bytes] length:[contents length] encoding:NSUTF8StringEncoding];
        DLog(@"Deserialization: %@", content);
    
        [self deserializeProject:content];
        _isInCloud = YES;
    }
    return YES;
}

-(NSString*)localizedName{
    return self.projName;
}

#pragma mark private nethods

-(NSString*)serializeProject{
    NSMutableString *content = [[NSMutableString alloc] init];
    
    [content appendFormat:@"%d%@", self.projLanguage, KEY_SEP_DATA];
    [content appendFormat:@"%@%@", self.projName, KEY_SEP_DATA];
    [content appendFormat:@"%@%@", self.projCode, KEY_SEP_DATA];
    [content appendFormat:@"%@%@", self.projInput, KEY_SEP_DATA];
    [content appendFormat:@"%@%@", self.projLink, KEY_SEP_DATA];
    
    return content;
}

-(void)deserializeProject:(NSString*)projectString{
    NSArray *parts = [projectString componentsSeparatedByString:KEY_SEP_DATA];
    
    NSAssert(parts.count == 5, @"Project deserialization: wrong number of data parts (%d)", parts.count);
    _projLanguage = ((NSString*)[parts objectAtIndex:0]).intValue;
    _projName = [parts objectAtIndex:1];
    _projCode = [parts objectAtIndex:2];
    _projInput = [parts objectAtIndex:3];
    _projLink = [parts objectAtIndex:4];
}

@end

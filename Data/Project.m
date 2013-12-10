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
    self = [super init];
    if (self){
        [self baseInitWithLanguage:language name:name];
        _isInCloud = YES;
    }
    return self;
}

-(id) initWithLanguage:(int)language name:(NSString*)name{
    self = [super init];
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
        [[iCloudHandler getInstance] updateInCloud:self];
    } else {
        [DataManager saveProject:self];
    }
}

-(void)remove{
    if (self.isInCloud){
        [[iCloudHandler getInstance] deleteFromCloud:self.projName];
    } else {
        [DataManager deleteProject:self.projName];
    }
}

#pragma mark UIDocument methods

-(id)contentsForType:(NSString *)typeName error:(NSError *__autoreleasing *)outError{
    NSString *content = [self serializeProject];
    DLog(@"Serialization: %@", content);
    
    return [NSData dataWithBytes:content.UTF8String length:[content length]];
}

-(BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError *__autoreleasing *)outError{
    NSString *content = [[NSString alloc] initWithBytes:[contents bytes] length:[contents length] encoding:NSUTF8StringEncoding];
    DLog(@"Deserialization: %@", content);
    
    [self deserializeProject:content];
    _isInCloud = YES;
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
    
    _projLanguage = ((NSString*)[parts objectAtIndex:0]).intValue;
    _projName = [parts objectAtIndex:1];
    _projCode = [parts objectAtIndex:2];
    _projInput = [parts objectAtIndex:3];
    _projLink = [parts objectAtIndex:4];
}

@end

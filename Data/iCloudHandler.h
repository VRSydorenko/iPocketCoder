//
//  iCloudHandler.h
//  iPocketCoder
//
//  Created by VRS on 10/12/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataManager.h"

@protocol iCloudHandlerDelegate <NSObject>
-(void)availableProjectsChanged:(NSDictionary*)cloudDocs; // key: NSString name; value: NSURL dor URL
-(void)projectUpdated:(BOOL)success;
-(void)projectDeleted:(BOOL)success;
-(void)projectOpened:(Project*)opened;
-(void)projectClosed:(Project*)closed;
@end

@interface iCloudHandler : NSObject

+(iCloudHandler*)getInstance;

@property id<iCloudHandlerDelegate> delegate;
@property (readonly) NSDictionary *cloudDocs;
@property (readonly) BOOL iCloudAccessible;

@property NSMetadataQuery *query;

-(void)openDocument:(NSURL*)fileUrl;
-(void)closeDocument:(Project*)project;
-(void)updateInCloud:(Project*)project;
-(void)deleteFromCloud:(NSString*)projName language:(int)language;
-(NSURL*)makeDocURLForProject:(NSString*)name language:(int)lang;

@end

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
@end

@interface iCloudHandler : NSObject

+(iCloudHandler*)getInstance;

@property id<iCloudHandlerDelegate> delegate;
@property (readonly) NSDictionary *cloudDocs;

@property NSMetadataQuery *query;

-(void)updateInCloud:(Project*)project;
-(void)deleteFromCloud:(NSString*)projName;

@end

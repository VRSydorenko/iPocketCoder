//
//  iCloudHandler.m
//  InstaCar
//
//  Created by VRS on 10/12/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "iCloudHandler.h"

#define DOCS_DIR @"iPocketCoder"

@implementation iCloudHandler

+(iCloudHandler*)getInstance
{
    static iCloudHandler *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[iCloudHandler alloc] init];
    });
    return sharedInstance;
}

-(void)updateInCloud:(Project *)project{
    NSURL *ubiq = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
    if (!ubiq){
        DLog(@"Ubiquity container is inaccessible");
        return;
    }
    NSURL *fileURL = [[ubiq URLByAppendingPathComponent:DOCS_DIR] URLByAppendingPathComponent:project.projName];
    
    DLog(@"iCloud project save requested for project: %@", project.projName);
    
    UIDocumentSaveOperation operation = [self.cloudDocs.allKeys containsObject:project.localizedName] ? UIDocumentSaveForOverwriting : UIDocumentSaveForCreating;
    
    BOOL deleteAfterSave = operation == UIDocumentSaveForCreating && !project.isInCloud;
    
    [project saveToURL:fileURL forSaveOperation:operation
     completionHandler:^(BOOL success){
         if (success){
             if (deleteAfterSave){
                 [DataManager deleteProject:project.projName];
             }
         }
         [self.delegate projectUpdated:success];
     }
     ];
}

-(void)deleteFromCloud:(NSString*)projName{
    NSURL *ubiq = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
    if (!ubiq){
        DLog(@"Ubiquity container is inaccessible");
        return;
    }
    NSURL *fileURL = [[ubiq URLByAppendingPathComponent:DOCS_DIR] URLByAppendingPathComponent:projName];
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    NSError *error = nil;
    [fileMgr removeItemAtURL:fileURL error:&error];
    [self.delegate projectDeleted:error == nil];
}

- (void)queryDidFinishGathering:(NSNotification *)notification {
    NSMetadataQuery *query = [notification object];
    //[query disableUpdates];
    //[query stopQuery];
    
    [self processQuery:query];
    
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:NSMetadataQueryDidFinishGatheringNotification object:query];
    //_query = nil;
}

-(void)processQuery:(NSMetadataQuery*)query{
    NSMutableDictionary *docs = [[NSMutableDictionary alloc] init]; // key: NSString, value: NSURL
    
    DLog(@"processQuery, count = %d", query.resultCount);
    if (query.resultCount > 0) {
        for (NSMetadataItem *item in query.results) {
            NSURL *url = [item valueForAttribute:NSMetadataItemURLKey];
            NSString *name = [item valueForAttribute:NSMetadataItemFSNameKey];
            [docs setValue:url forKey:name];
        }
    }
    
    if (_cloudDocs){
        _cloudDocs = nil;
    }
    _cloudDocs = [[NSDictionary alloc] initWithDictionary:docs];

    [self.delegate availableProjectsChanged:self.cloudDocs];
}

@end

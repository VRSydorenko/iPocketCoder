//
//  iCloudHandler.m
//  InstaCar
//
//  Created by VRS on 10/12/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "iCloudHandler.h"

#define DOCS_DIR @"Documents"

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

-(void)openDocument:(NSURL*)fileUrl{
    DLog(@"Requested opening file: %@", fileUrl.description);
    
    Project *proj = [[Project alloc] initWithFileURL:fileUrl];
    [proj openWithCompletionHandler:^(BOOL success){
        if (success){
            DLog(@"Cloud open succeeded");
            [self.delegate projectOpened:proj];
        } else {
            DLog(@"Cloud open failed");
            [self.delegate projectOpened:nil];
        }
    }];
}

-(void)closeDocument:(Project*)proj{
    DLog(@"Requested closing file: %@", proj.fileURL);
    
    [proj saveToURL:proj.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success){
        if (success){
            DLog(@"Cloud save succeeded");
            [proj closeWithCompletionHandler:^(BOOL success){
                if (success){
                    DLog(@"Cloud close succeeded");
                    [self.delegate projectClosed:proj];
                } else {
                    DLog(@"Cloud close failed");
                    [self.delegate projectClosed:nil];
                }
            }];
        } else {
            DLog(@"Cloud close failed");
            [self.delegate projectClosed:nil];
        }
    }];
    
    
}

-(void)updateInCloud:(Project *)project{
    if (![self iCloudAccessible]){
        return;
    }
    
    DLog(@"iCloud project save requested for project: %@", project.projName);
    DLog(@"File URL: %@", project.fileURL);
    
    UIDocumentSaveOperation operation = [self.cloudDocs.allKeys containsObject:project.projName] ? UIDocumentSaveForOverwriting : UIDocumentSaveForCreating;
    
    BOOL deleteAfterSave = operation == UIDocumentSaveForCreating && !project.isInCloud;
    
    [project saveToURL:project.fileURL forSaveOperation:operation
     completionHandler:^(BOOL success){
         if (success){
             DLog(@"Cloud save succeeded");
             if (deleteAfterSave){
                 [DataManager deleteProject:project.projName];
             }
             if (operation == UIDocumentSaveForCreating){
                 NSMutableDictionary *tmp = [[NSMutableDictionary alloc] initWithDictionary:self.cloudDocs];
                 [tmp setValue:project.fileURL forKey:project.projName];
                 _cloudDocs = nil;
                 _cloudDocs = [[NSDictionary alloc] initWithDictionary:tmp];
             }
         } else {
             DLog(@"Cloud save failed");
         }
         [self.delegate projectUpdated:success];
     }
     ];
}

-(void)deleteFromCloud:(NSString*)projName{
    if (![self iCloudAccessible]){
        return;
    }
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    NSError *error = nil;
    [fileMgr removeItemAtURL:[self makeDocURLForProject:projName] error:&error];
    
    if (!error){
        NSMutableDictionary *tmp = [[NSMutableDictionary alloc] initWithDictionary:self.cloudDocs];
        [tmp removeObjectForKey:projName];
        _cloudDocs = nil;
        _cloudDocs = [[NSDictionary alloc] initWithDictionary:tmp];
    } else {
        DLog(@"%@", error.localizedDescription);
    }
                      
    [self.delegate projectDeleted:error == nil];
}

- (void)queryDidFinishGathering:(NSNotification *)notification {
    DLog(@"queryDidFinishGathering");
    NSMetadataQuery *query = [notification object];
    
    [self processQuery:query];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSMetadataQueryDidFinishGatheringNotification object:query];
}

- (void)queryDidFinishUpdating:(NSNotification*)notification{
    DLog(@"Cloud updated");
    NSMetadataQuery *q = [notification object];
    [self processQuery:q];
}

-(void)processQuery:(NSMetadataQuery*)query{
    NSMutableDictionary *docs = [[NSMutableDictionary alloc] init]; // key: NSString, value: NSURL
    
    DLog(@"processQuery, count = %d", query.resultCount);
    if (query.resultCount > 0) {
        for (NSMetadataItem *item in query.results) {
            NSURL *url = [item valueForAttribute:NSMetadataItemURLKey];
            NSString *name = [[item valueForAttribute:NSMetadataItemFSNameKey] stringByDeletingPathExtension];
            DLog(@"File %@ found in cloud", name);
            [docs setValue:url forKey:name];
        }
    }
    
    if (_cloudDocs){
        _cloudDocs = nil;
    }
    _cloudDocs = [[NSDictionary alloc] initWithDictionary:docs];

    [self.delegate availableProjectsChanged:self.cloudDocs];
}

-(NSURL*)makeDocURLForProject:(NSString*)name{
    NSURL *ubiq = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).ubiquityContainerUrl;
    if (ubiq){
        return [[ubiq URLByAppendingPathComponent:DOCS_DIR] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.proj", name]];
        //return [ubiq URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.proj", name]];
    }
    DLog(@"Ubiquity container is inaccessible");
    return nil;
}

-(BOOL)iCloudAccessible{
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).ubiquityContainerUrl != nil;
}

@end

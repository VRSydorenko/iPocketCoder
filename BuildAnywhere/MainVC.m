//
//  MainVC.m
//  BuildAnywhere
//
//  Created by Viktor Sydorenko on 2/16/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "MainVC.h"

#define IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad

@interface MainVC (){
    NSDictionary* projectBasicData;
    UIPopoverController* popoverController;
}

@end

@implementation MainVC

@synthesize collectionProjects;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.collectionProjects.dataSource = self;
    self.collectionProjects.delegate = self;
    
    [self updateData];
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section{
    return MAX(1, projectBasicData.count); // min 1 for "No data" message
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellReuseId = IPAD ? @"cellProjectiPad" : @"cellProjectiPhone";
    
    ProjectCell* cell = [cv dequeueReusableCellWithReuseIdentifier:cellReuseId forIndexPath:indexPath];
    cell.labelProjectName.text = projectBasicData.count == 0 ? @"No data" : [projectBasicData.allKeys objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
}

-(void) updateData{
    projectBasicData = [DataManager getProjectsBasicInfo];
    [self.collectionProjects reloadData];
}

- (IBAction)createNewProjectPressed:(id)sender {
    if (IPAD){
        NewProjectVC *newProjectVC = [[UIStoryboard storyboardWithName:@"iPhoneMain" bundle:nil] instantiateViewControllerWithIdentifier:@"screenNewProject"];
        if (popoverController){
            if ([popoverController isPopoverVisible]){
                [popoverController dismissPopoverAnimated:YES];
                return;
            }
            popoverController = nil;
        }
        popoverController = [[UIPopoverController alloc] initWithContentViewController:newProjectVC];
        [popoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

@end

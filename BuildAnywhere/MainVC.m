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
    return projectBasicData.count;
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
    self.labelHeader.text = projectBasicData.count == 0 ? @"No projects yet" : @"Projects";
    [self.collectionProjects reloadData];
}

- (IBAction)createNewProjectPressed:(id)sender {
    if (IPAD){
        NewProjectVC *newProjectVC = [[UIStoryboard storyboardWithName:@"iPhoneMain" bundle:nil] instantiateViewControllerWithIdentifier:@"screenNewProject"];
        newProjectVC.delegate = self;
        
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

// iPhone
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"SegueMainToNewProject"]){
        NewProjectVC* newProjectVC = (NewProjectVC*)segue.destinationViewController;
        newProjectVC.delegate = self;
    }
}

-(void) newProjectCreationFinished:(BOOL)projectCreated fromController:(NewProjectVC*)controller{
    if (IPAD){
        if (popoverController){
            if ([popoverController isPopoverVisible]){
                [popoverController dismissPopoverAnimated:YES];
            }
            popoverController = nil;
        }
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if (projectCreated){
        [self updateData];
    }
}

- (void)viewDidUnload {
    [self setLabelHeader:nil];
    [super viewDidUnload];
}
@end

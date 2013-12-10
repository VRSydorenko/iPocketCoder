//
//  MainVC.m
//  BuildAnywhere
//
//  Created by Viktor Sydorenko on 2/16/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "MainVC.h"

@interface MainVC (){
    NSDictionary* projectBasicData;
    UIPopoverController* popoverController;
    NSIndexPath *selectedIndexPath;
    MainNavController* navCon;
}

@end

@implementation MainVC

@synthesize collectionProjects;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    selectedIndexPath = nil;
    
    navCon = (MainNavController*)self.navigationController;
    [navCon hideToolBarAnimated:NO];
    
    
    self.collectionProjects.dataSource = self;
    self.collectionProjects.delegate = self;
    
    self.title = @"Pocket Coder";
    
    [self updateData];
}

-(void)viewDidAppear:(BOOL)animated{
    [navCon hideToolBarAnimated:YES];
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section{
    return projectBasicData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProjectCell* cell = [cv dequeueReusableCellWithReuseIdentifier:@"cellProject" forIndexPath:indexPath];
    NSString *projectName = [projectBasicData.allKeys objectAtIndex:indexPath.row];
    int projectLanguage = ((NSNumber*)[projectBasicData objectForKey:projectName]).intValue;

    cell.delegate = self;
    cell.labelProjectName.text = projectName;
    cell.labelProjectLanguage.text =  [DataManager getLanguageName:projectLanguage];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    selectedIndexPath = indexPath;
    [self performSegueWithIdentifier:@"segueMainToEditor" sender:self];
}

-(void) updateData{
    projectBasicData = [DataManager getBasicInfosForEntity:ENTITY_PROJECT];
    self.labelHeader.text = projectBasicData.count == 0 ? @"No projects yet" : @"Projects";
    [self.collectionProjects performBatchUpdates:^{
        [self.collectionProjects reloadSections:[NSIndexSet indexSetWithIndex:0]];
    } completion:nil];
//    [self.collectionProjects reloadData];
}

- (IBAction)createNewProjectPressed:(id)sender {
    if (IPAD){
        if (popoverController){
            if ([popoverController isPopoverVisible]){
                [popoverController dismissPopoverAnimated:YES];
                return;
            }
            popoverController = nil;
        }
        
        MainNavController *newProjectMainVC = [[UIStoryboard storyboardWithName:@"iPhoneMain" bundle:nil] instantiateViewControllerWithIdentifier:@"screenNewProject"];
        if (!newProjectMainVC){
            return;
        }
        ((NewProjectVC*)[newProjectMainVC.viewControllers objectAtIndex:0]).delegate = self;
        
        popoverController = [[UIPopoverController alloc] initWithContentViewController:newProjectMainVC];
        [popoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

// iPhone
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"segueMainToNewProject"]){
        NewProjectVC* newProjectVC = (NewProjectVC*)segue.destinationViewController;
        newProjectVC.delegate = self;
    } else if ([segue.identifier isEqualToString:@"segueMainToEditor"]){
        if (!selectedIndexPath){
            return;
        }
        EditorVC* editorVC = (EditorVC*)segue.destinationViewController;
        editorVC.projectName = [projectBasicData.allKeys objectAtIndex:selectedIndexPath.row];
    }
}

-(void) newProjectCreationFinished:(BOOL)projectCreated{
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

-(void)projectDeleted{
    [self updateData];
}

- (void)dealloc {
    [self setLabelHeader:nil];
    selectedIndexPath = nil;
}

#pragma mark iCloudHandler delegate methods

-(void)availableProjectsChanged:(NSDictionary*)cloudDocs{ // key: NSString name; value: NSURL dor URL
}

-(void)projectUpdated:(BOOL)success{
}

-(void)projectDeleted:(BOOL)success{
}

@end

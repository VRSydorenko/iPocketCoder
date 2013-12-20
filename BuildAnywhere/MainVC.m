//
//  MainVC.m
//  BuildAnywhere
//
//  Created by Viktor Sydorenko on 2/16/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "MainVC.h"

#define SECTION_LOCAL 0
#define SECTION_CLOUD 1

@interface MainVC (){
    NSDictionary* projectBasicData;
    NSDictionary *cloudProjects;
    
    UIPopoverController* popoverController;
    MainNavController* navCon;
    
    Project *bufferProj;
}

@end

@implementation MainVC

@synthesize collectionProjects;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    navCon = (MainNavController*)self.navigationController;
    [navCon hideToolBarAnimated:NO];
    
    bufferProj = nil;
    
    self.collectionProjects.dataSource = self;
    self.collectionProjects.delegate = self;
    
    self.title = @"Pocket Coder";
    
    [iCloudHandler getInstance].delegate = self;
    
    [self updateData];
}

-(void)viewDidAppear:(BOOL)animated{
    [navCon hideToolBarAnimated:YES];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
    //return cloudProjects.count > 0 ? 2 : 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section{
    switch (section) {
        case SECTION_LOCAL:
            return projectBasicData.count;
        case SECTION_CLOUD:
            return cloudProjects.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProjectCell* cell = [cv dequeueReusableCellWithReuseIdentifier:@"cellProject" forIndexPath:indexPath];
    NSString *projectName = @"";
    int projectLanguage = -1;
    
    if (indexPath.section == SECTION_LOCAL){
        cell.isProjectLocal = YES;
        
        projectName = [projectBasicData.allKeys objectAtIndex:indexPath.row];
        projectLanguage = ((NSNumber*)[projectBasicData objectForKey:projectName]).intValue;
    } else if (indexPath.section == SECTION_CLOUD){
        cell.isProjectLocal = NO;
        
        NSString *fromCloud = [cloudProjects.allKeys objectAtIndex:indexPath.row];
        projectName = [fromCloud substringFromIndex:4]; // here the actual name begins
        projectLanguage = [fromCloud substringToIndex:3].intValue; // language is stored within first 3 symbols
    }

    cell.delegate = self;
    cell.labelProjectName.text = projectName;
    cell.labelProjectLanguage.text =  [DataManager getLanguageName:projectLanguage];
    cell.tag = projectLanguage;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == SECTION_LOCAL){
        NSString *projectName = [projectBasicData.allKeys objectAtIndex:indexPath.row];
        bufferProj = [DataManager loadProject:projectName];
        [self performSegueWithIdentifier:@"segueMainToEditor" sender:self];
    } else if (indexPath.section == SECTION_CLOUD){
        [[iCloudHandler getInstance] openDocument:[cloudProjects.allValues objectAtIndex:indexPath.row]];
    }
}

-(UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5.0, 0.0, 5.0, 0.0);
}

-(void) updateData{
    projectBasicData = [DataManager getBasicInfosForEntity:ENTITY_PROJECT];
    cloudProjects = [iCloudHandler getInstance].cloudDocs;
    
    self.labelHeader.text = (projectBasicData.count == 0 && cloudProjects.count == 0) ? @"No projects yet" : @"Projects";
    [self.collectionProjects performBatchUpdates:^{
        NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
        for (int i = 0; i < [self numberOfSectionsInCollectionView:self.collectionProjects]; i++) {
            [indexSet addIndex:i];
        }
        [self.collectionProjects reloadSections:indexSet];
    } completion:nil];
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
        EditorVC* editorVC = (EditorVC*)segue.destinationViewController;
        editorVC.project = bufferProj;
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
}

#pragma mark iCloudHandler delegate methods

-(void)availableProjectsChanged:(NSDictionary*)cloudDocs{ // key: NSString name; value: NSURL dor URL
    [self updateData];
}

-(void)projectUpdated:(BOOL)success{
    [self updateData];
}

-(void)projectDeleted:(BOOL)success{
    [self updateData];
}

-(void)projectOpened:(Project*)opened{
    bufferProj = opened;
    [self performSegueWithIdentifier:@"segueMainToEditor" sender:self];
}

-(void)projectClosed:(Project*)closed{
}

@end

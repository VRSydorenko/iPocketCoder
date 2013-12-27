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
    NSMutableDictionary *projectStates;
}

@end

@implementation MainVC

@synthesize collectionProjects;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    projectStates = [[NSMutableDictionary alloc] init];
    
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
    NSString *cellId = indexPath.section == SECTION_LOCAL ? @"cellProject" : @"cellCloudProject";
    ProjectCell* cell = [cv dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
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
    
    NSString *fullProjName = [NSString stringWithFormat:@"%@_%@", [Utils make3digitsStringFromNumber:projectLanguage], projectName];
    NSNumber *state = [projectStates objectForKey:fullProjName];
    DLog(@"Setting %@ for the cell for project: %@", state, fullProjName);
    [cell setBehaviour:state.intValue];
    
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
    
    [self syncStates];
    
    self.labelHeader.text = (projectBasicData.count == 0 && cloudProjects.count == 0) ? @"No projects yet" : @"Projects";
    [self.collectionProjects performBatchUpdates:^{
        NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
        for (int i = 0; i < [self numberOfSectionsInCollectionView:self.collectionProjects]; i++) {
            [indexSet addIndex:i];
        }
        [self.collectionProjects reloadSections:indexSet];
    } completion:nil];
}

-(void)syncStates{ // in terms of IDLE and DELETING states
    for (NSString *projName in cloudProjects) {
        DLog(@"Syncing states...");
        if (![projectStates.allKeys containsObject:projName]){
            DLog(@"projectStates miss %@ project so adding %@ for it", projName, [NSNumber numberWithInt:IDLE]);
            [projectStates setObject:[NSNumber numberWithInt:IDLE] forKey:projName];
        } else {
            DLog(@"projectStates already has project %@ (with value %@)", projName, [projectStates objectForKey:projName]);
        }
    }
    for (NSString *projName in projectStates.allKeys) {
        DLog(@"Syncing removed states...");
        if (![cloudProjects.allKeys containsObject:projName]){
            DLog(@"%@ does not exist in cloudProjects so delete it from projectStates", projName);
            [projectStates removeObjectForKey:projName];
        } else {
            DLog(@"%@ exists in cloudDocs", projName);
        }
    }
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

- (void)dealloc {
    [self setLabelHeader:nil];
}

#pragma mark ProjectCellDelegate

-(void)projectWillBeDeleted:(NSString *)name language:(int)lang{
    NSString *fullProjName = [NSString stringWithFormat:@"%@_%@", [Utils make3digitsStringFromNumber:lang], name];
    NSNumber *stateDeleting = [NSNumber numberWithInt:DELETING];
    DLog(@"Updating state with value %@ for project %@", stateDeleting, fullProjName);
    [projectStates setObject:stateDeleting forKey:fullProjName];
}

-(void)projectDeleted{
    [self updateData];
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
    NSString *fullProjName = [NSString stringWithFormat:@"%@_%@", [Utils make3digitsStringFromNumber:closed.projLanguage], closed.projName];
    NSNumber *stateIdle = [NSNumber numberWithInt:IDLE];
    DLog(@"Updating state with value %@ for project %@", stateIdle, fullProjName);
    [projectStates setObject:stateIdle forKey:fullProjName];
}

-(void)projectWillBeClosed:(Project*)closing{
    NSString *fullProjName = [NSString stringWithFormat:@"%@_%@", [Utils make3digitsStringFromNumber:closing.projLanguage], closing.projName];
    NSNumber *stateClosing = [NSNumber numberWithInt:CLOSING];
    DLog(@"Updating state with value %@ for project %@", stateClosing, fullProjName);
    [projectStates setObject:stateClosing forKey:fullProjName];
}

@end

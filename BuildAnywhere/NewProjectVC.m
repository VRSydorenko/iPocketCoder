//
//  NewProjectVC.m
//  BuildAnywhere
//
//  Created by Viktor Sydorenko on 2/17/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "NewProjectVC.h"
#import "iCloudHandler.h"

#define SEGMENT_CLOUD 0
#define SEGMENT_LOCAL 1

@interface NewProjectVC (){
    NSDictionary *languages;
    NSArray *sortedKeys;
    NSIndexPath *selectedPath;
    NSDictionary* projectBasicData;
    MainNavController* navCon;
}
@end

@implementation NewProjectVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    navCon = (MainNavController*)self.navigationController;
    
    if (!IPAD){
        [navCon createMiniBackButtonWithBackPressedSelectorOnTarget:self];
    }
    
    projectBasicData = [DataManager getBasicInfosForEntity:ENTITY_PROJECT];
    [self generateProjectName];
    
    selectedPath = nil;
    languages = [DataManager getLanguages];
    sortedKeys = [languages.allKeys sortedArrayUsingSelector:@selector(compare:)];
    self.segmentStorage.selectedSegmentIndex = SEGMENT_LOCAL;
    [self.segmentStorage setEnabled:[iCloudHandler getInstance].iCloudAccessible forSegmentAtIndex:SEGMENT_CLOUD];
    self.tableLanguages.dataSource = self;
    self.tableLanguages.delegate = self;
}

- (void)dealloc {
    [self setTableLanguages:nil];
    [self setTextName:nil];
}

-(void) viewDidAppear:(BOOL)animated{
    [navCon showToolbarAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return languages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cellLanguage"];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellLanguage"];
    }
    cell.textLabel.text = [sortedKeys objectAtIndex:indexPath.row];
    cell.accessoryType = indexPath == selectedPath ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryNone){
        if (selectedPath){
            UITableViewCell* selectedCell = [tableView cellForRowAtIndexPath:selectedPath];
            selectedCell.accessoryType = UITableViewCellAccessoryNone;
        }
        selectedPath = indexPath;
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
}

- (IBAction)didEndOnExit:(UITextField *)sender {
    [sender resignFirstResponder];
}

- (IBAction)createPressed:(id)sender {
    self.textName.text = [self.textName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (self.textName.text.length == 0){
        if (IPAD){
            [navCon showMessageBox:@"Enter project title" text:@""];
        } else {
            [navCon showInfoBarWithNeutralMessage:@"Enter project title"];
        }
        return;
    }
    if ([self isProjectExist:self.textName.text]){
        if (IPAD){
            [navCon showMessageBox:@"Project exists" text:@""];
        } else {
            [navCon showInfoBarWithNeutralMessage:@"Project exists"];
        }
        return;
    }
    if (!selectedPath){
        if (IPAD){
            [navCon showMessageBox:@"Select programming language" text:@""];
        } else {
            [navCon showInfoBarWithNeutralMessage:@"Select programming language"];
        }
        return;
    }
    
    int language = ((NSNumber*)[languages objectForKey:[sortedKeys objectAtIndex:selectedPath.row]]).intValue;
    Project* newProject = nil;
    if (self.segmentStorage.selectedSegmentIndex == SEGMENT_LOCAL){
        newProject = [[Project alloc] initWithLanguage:language name:self.textName.text];
    } else {
        newProject = [[Project alloc] initInCloudWithLanguage:language name:self.textName.text];
    }
    [newProject save];
    
    [self.delegate newProjectCreationFinished:YES];
}

-(BOOL)isProjectExist:(NSString*)name{
    if ([projectBasicData.allKeys containsObject:name]){
        return YES;
    }
    for (NSString *cloudName in [iCloudHandler getInstance].cloudDocs.allKeys) {
        NSString *nameOnly = [cloudName substringFromIndex:4];
        if ([name isEqualToString:nameOnly]){
            return YES;
        }
    }
    return NO;
}

-(void)backPressed{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)generateProjectName{
    NSString* result;
    int i = 1;
    do {
        result = [NSString stringWithFormat:@"Project %d", i++];
    } while ([self isProjectExist:result]);
    
    self.textName.text = result;
}

@end

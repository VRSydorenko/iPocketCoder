//
//  NewProjectVC.m
//  BuildAnywhere
//
//  Created by Viktor Sydorenko on 2/17/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "NewProjectVC.h"

#define IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad

@interface NewProjectVC (){
    NSDictionary *languages;
    NSIndexPath *selectedPath;
    NSDictionary* projectBasicData;
    MainNavController* navController;
}

@end

@implementation NewProjectVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    navController = (MainNavController*)self.navigationController;
    
    if (!IPAD){
        self.navigationItem.leftBarButtonItem = [Utils createBackButtonWithSelectorBackPressedOnTarget:self];
    }
    
    projectBasicData = [DataManager getProjectsBasicInfo];
    
    selectedPath = nil;
    languages = [DataManager getLanguages];
    self.tableLanguages.dataSource = self;
    self.tableLanguages.delegate = self;
}

- (void)dealloc {
    [self setTableLanguages:nil];
    [self setTextName:nil];
    [super viewDidUnload];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return languages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cellLanguage"];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellLanguage"];
    }
    cell.textLabel.text = [languages.allKeys objectAtIndex:indexPath.row];
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
        [navController showInfoBarWithNeutralMessage:@"Enter project name"];
        return;
    }
    if ([projectBasicData.allKeys containsObject:self.textName.text]){
        [navController showInfoBarWithNeutralMessage:@"Project exists"];
        return;
    }
    if (!selectedPath){
        [navController showInfoBarWithNeutralMessage:@"Select programmingn language"];
        return;
    }
    
    int language = ((NSNumber*)[languages.allValues objectAtIndex:selectedPath.row]).intValue;
    Project* newProject = [[Project alloc] initWithLanguage:language name:self.textName.text];
    [DataManager saveProject:newProject];
    [self.delegate newProjectCreationFinished:YES fromController:self];
}

-(void)backPressed{
    [self.navigationController popViewControllerAnimated:YES];
}

@end

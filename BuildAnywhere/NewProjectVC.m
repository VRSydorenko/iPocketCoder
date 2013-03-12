//
//  NewProjectVC.m
//  BuildAnywhere
//
//  Created by Viktor Sydorenko on 2/17/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "NewProjectVC.h"

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
    
    [self generateProjectName];
    
    navCon = (MainNavController*)self.navigationController;
    
    if (!IPAD){
        [navCon createMiniBackButtonWithBackPressedSelectorOnTarget:self];
    }
    
    projectBasicData = [DataManager getProjectsBasicInfo];
    
    selectedPath = nil;
    languages = [DataManager getLanguages];
    sortedKeys = [languages.allKeys sortedArrayUsingSelector:@selector(compare:)];
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
    if ([projectBasicData.allKeys containsObject:self.textName.text]){
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
    Project* newProject = [[Project alloc] initWithLanguage:language name:self.textName.text];
    [DataManager saveProject:newProject];
    [self.delegate newProjectCreationFinished:YES];
}

-(void)backPressed{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)generateProjectName{    
    NSString* template = @"New project";
    
    if (![DataManager loadProject:template]){
        self.textName.text = template;
        return;
    }
    
    NSString* result;
    int i = 2;
    do {
        result = [NSString stringWithFormat:@"%@ %d", template, i++];
    } while ([DataManager loadProject:result]);
    
    self.textName.text = result;
}

@end

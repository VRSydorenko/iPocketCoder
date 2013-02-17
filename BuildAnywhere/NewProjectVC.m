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
    InfoBarManager *infoManager;
    NSDictionary* projectBasicData;
}

@end

@implementation NewProjectVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initInfoBar];
    
    self.labelTitle.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.labelTitle.shadowOffset = CGSizeMake(0, -1.0);
    
    projectBasicData = [DataManager getProjectsBasicInfo];
    
    selectedPath = nil;
    languages = [DataManager getLanguages];
    self.tableLanguages.dataSource = self;
    self.tableLanguages.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (void)dealloc {
    [self setTableLanguages:nil];
    [self setTextName:nil];
    [self setLabelTitle:nil];
    [self setFakeNavBar:nil];
    [super viewDidUnload];
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)orientation duration:(NSTimeInterval)duration {
    [self initInfoBar];
}

-(void) initInfoBar{
    if (infoManager){
        if (IPAD){
            // if it has already been created on iPad so do nothing here
            // because it has fixed size on iPad 
            return;
        }
        [infoManager hideInfoBar];
        infoManager = nil;
    }
    
    float width = IPAD ? 320.0 : self.view.frame.size.width;
    infoManager = [[InfoBarManager alloc] init];
    CGRect frame = CGRectMake(0.0, 0.0, width, 44.0);
    [infoManager initInfoBarWithTopViewFrame:frame andHeight:40];
    [self.view insertSubview:infoManager.infoBar belowSubview:self.fakeNavBar];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  languages.count;
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
        [infoManager showInfoBarWithMessage:@"Enter project name" withMood:NEUTRAL];
        return;
    }
    if ([projectBasicData.allKeys containsObject:self.textName.text]){
        [infoManager showInfoBarWithMessage:@"Project exists" withMood:NEUTRAL];
        return;
    }
    if (!selectedPath){
        [infoManager showInfoBarWithMessage:@"Select programming language" withMood:NEUTRAL];
        return;
    }
    
    int language = ((NSNumber*)[languages.allValues objectAtIndex:selectedPath.row]).intValue;
    Project* newProject = [[Project alloc] initWithLanguage:language name:self.textName.text];
    [DataManager saveProject:newProject];
    [self.delegate newProjectCreationFinished:YES fromController:self];
}

- (IBAction)closePressed:(id)sender {
    [self.delegate newProjectCreationFinished:NO fromController:self];
}

@end

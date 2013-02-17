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
    NSIndexPath *selectedPath;
}

@end

@implementation NewProjectVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    selectedPath = nil;
    languages = [DataManager getLanguages];
    self.tableLanguages.dataSource = self;
    self.tableLanguages.delegate = self;
}

- (void)dealloc {
    [self setTableLanguages:nil];
    [super viewDidUnload];
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
@end

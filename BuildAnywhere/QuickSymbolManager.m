//
//  QuickSymbolManager.m
//  PocketCoder
//
//  Created by Viktor Sydorenko on 3/15/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "QuickSymbolManager.h"

@interface QuickSymbolManager (){
    MainNavController* navCon;
    NSDictionary* allSymbols;
    NSDictionary* selectedSymbols;
    NSMutableDictionary* tableData;
}

@end

@implementation QuickSymbolManager

@synthesize projectLanguge = _projectLanguge;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    navCon = (MainNavController*)self.navigationController;
    
    if (!IPAD){ // to save more space on navigation bar
        [navCon createMiniBackButtonWithBackPressedSelectorOnTarget:self];
    }
        
    self.tableSymbols.delegate = self;
    self.tableSymbols.dataSource = self;
    
    [self updateData];
    [self updateEditButton];
}

- (void)viewDidUnload {
    [self setTableSymbols:nil];
    [super viewDidUnload];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return allSymbols.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"symbolCell"];
    
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"symbolCell"];
    }
    
    NSNumber* row = [NSNumber numberWithInt:indexPath.row];
    if ([selectedSymbols.allKeys containsObject:row]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    QuickSymbol* symbolForCurrentCell = (QuickSymbol*)[tableData objectForKey:row];
    cell.textLabel.text = symbolForCurrentCell.symbTitle;
    cell.tag = symbolForCurrentCell.symbId;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSNumber* row = [NSNumber numberWithInt:indexPath.row];
    QuickSymbol* checkedSymbol = [tableData objectForKey:row];
    if ([selectedSymbols.allValues containsObject:[NSNumber numberWithInt:checkedSymbol.symbId]]){
        [DataManager removeQuickSymbol:checkedSymbol.symbId fomLanguageUsage:self.projectLanguge];
    } else {
        [DataManager putQuickSymbol:checkedSymbol toLanguageUsage:self.projectLanguge atIndex:selectedSymbols.count];
    }
    [self updateData];
    [self.delegate symbolsLayoutChanged];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row < selectedSymbols.count;
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath{
    return proposedDestinationIndexPath.row < selectedSymbols.count ? proposedDestinationIndexPath : [NSIndexPath indexPathForRow:selectedSymbols.count-1 inSection:0];
}

- (void)tableView:(UITableView*)tableView moveRowAtIndexPath:(NSIndexPath*)fromIndexPath toIndexPath:(NSIndexPath*)toIndexPath {
    NSNumber* row = [NSNumber numberWithInt:fromIndexPath.row];
    QuickSymbol* symbolFromCell = (QuickSymbol*)[tableData objectForKey:row];
    [DataManager putQuickSymbol:symbolFromCell toLanguageUsage:self.projectLanguge atIndex:toIndexPath.row];
    [self updateData];
    [self.delegate symbolsLayoutChanged];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        NSArray* langs = [DataManager getLanguagesSymbolUsedFor:cell.tag];
        int usage = langs.count;
        if (usage == 0){
            [DataManager deleteQuickSymbol:cell.tag];
            [self updateData];
            [self.delegate symbolsLayoutChanged];
        } else if ([langs containsObject:[NSNumber numberWithInt:self.projectLanguge]]){
            if (usage > 1){
                NSString* title = [NSString stringWithFormat:@"The shortcut is also used for %d  more %@", usage - 1, usage>2?@"languages":@"language"];
                UIActionSheet* deleteActionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete for all languages" otherButtonTitles:@"Delete for current language", nil];
                deleteActionSheet.tag = cell.tag;
                [deleteActionSheet showInView:self.view];
            } else {
                [DataManager removeQuickSymbol:cell.tag fomLanguageUsage:self.projectLanguge];
                [DataManager deleteQuickSymbol:cell.tag];
                [self updateData];
                [self.delegate symbolsLayoutChanged];
            }
        } else { // symbol is used for other languages
            NSString* title = [NSString stringWithFormat:@"The shortcut is used for %d other %@", usage, usage>1?@"languages":@"language"];
            UIActionSheet* deleteActionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete anyway" otherButtonTitles:nil];
            deleteActionSheet.tag = cell.tag;
            [deleteActionSheet showInView:self.view];
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.editing;
}

- (IBAction)editTablePressed:(id)sender{
    self.editing = !self.editing;
    
    [self.tableSymbols setEditing:self.editing animated:YES];
    [self updateEditButton];
}

-(void)updateEditButton{
    UIBarButtonItem *btnEdit = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:self.editing?UIBarButtonSystemItemDone:UIBarButtonSystemItemEdit target:self action:@selector(editTablePressed:)];
    self.navigationItem.rightBarButtonItem = btnEdit;
}

-(void)updateData{
    tableData = nil;
    tableData = [[NSMutableDictionary alloc] init]; // key:order value:QuickSymbol
    
    allSymbols = [DataManager getQuickSymbolsDictionary]; // key:symbId value:QuickSymbol
    selectedSymbols = [DataManager getOrderedSymbolIDsForLanguage:self.projectLanguge]; // key:order value:symbId
    
    for (int i=0; i<selectedSymbols.count; i++){ // first come selected
        NSNumber* order = [NSNumber numberWithInt:i];
        NSNumber* selectedSymbId = (NSNumber*)[selectedSymbols objectForKey:order];
        QuickSymbol* found = [allSymbols objectForKey:selectedSymbId];
        [tableData setObject:found forKey:order];
    }
    
    for (int i=0; i<allSymbols.count; i++){
        NSNumber* key = [allSymbols.allKeys objectAtIndex:i];
        if ([selectedSymbols.allValues containsObject:key]){
            continue;
        }
        QuickSymbol* symbol = [allSymbols objectForKey:key];
        [tableData setObject:symbol forKey:[NSNumber numberWithInt:tableData.count]];
    }
    [self.tableSymbols reloadData];
}

-(void) actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    int symbId = actionSheet.tag;
    
    if (buttonIndex == 2){ // 'cancel'
        return;
    } else if (buttonIndex == 1){ // 'cancel' or 'delete for current'
        NSArray* langs = [DataManager getLanguagesSymbolUsedFor:symbId];
        if (![langs containsObject:[NSNumber numberWithInt:self.projectLanguge]]){ // 'cancel'
            return;
        }
    }
    
    switch (buttonIndex) {
        case 0:{ // delete for all
            for (NSNumber* lang in [DataManager getLanguagesSymbolUsedFor:symbId]) {
                [DataManager removeQuickSymbol:symbId fomLanguageUsage:lang.intValue];
            }
            [DataManager deleteQuickSymbol:symbId];
            break;
        }
        case 1:{ // delete for current
            [DataManager removeQuickSymbol:symbId fomLanguageUsage:self.projectLanguge];
            break;
        }
    }
    
    [self updateData];
    [self.delegate symbolsLayoutChanged];
}

// iPhone
-(void)backPressed{
    [self.navigationController popViewControllerAnimated:YES];
}



@end

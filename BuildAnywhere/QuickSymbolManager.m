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
        // TODO: deleting
        [self updateData];
        [self.delegate symbolsLayoutChanged];
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

/*-(QuickSymbol*)findSymbolById:(int)iD{
    for (QuickSymbol* symbol in allSymbols) {
        if (symbol.symbId == iD){
            return symbol;
        }
    }
    return nil;
}*/

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

// iPhone
-(void)backPressed{
    [self.navigationController popViewControllerAnimated:YES];
}

@end

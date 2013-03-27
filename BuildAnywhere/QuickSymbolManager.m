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
    
    if (!IPAD){ // causes wrong behaviour on iPad
        [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    }

    
    navCon = (MainNavController*)self.navigationController;
    
    if (!IPAD){ // to save more space on navigation bar
        [navCon createMiniBackButtonWithBackPressedSelectorOnTarget:self];
    }
        
    self.tableSymbols.delegate = self;
    self.tableSymbols.dataSource = self;
    
   // [self.tableSymbols registerClass:[AddShortkeyCell class] forCellReuseIdentifier:@"addSymbolCell"];
    
    [self updateData];
    [self updateEditButton];
}

- (void)viewDidUnload {
    [self setTableSymbols:nil];
    [super viewDidUnload];
}

-(void)viewDidAppear:(BOOL)animated{
    [navCon hideToolBarAnimated:YES];
}

-(BOOL)shouldAutorotate{
    return NO;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int n = tableData.count + /*row for new symbols in editing mode*/ (self.editing?1:0);
    return n;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.editing && indexPath.row == tableData.count){ // extra row for new symbols
        AddShortkeyCell* addKeyCell = [tableView dequeueReusableCellWithIdentifier:@"addSymbolCell" forIndexPath:indexPath];
        if (!addKeyCell){
            addKeyCell = [[AddShortkeyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"addSymbolCell"];
        }
        addKeyCell.shortkeyCreationDelegate = self;
        
        return addKeyCell;
    }
    
    ShortkeyCell* cell = [tableView dequeueReusableCellWithIdentifier:@"symbolCell" forIndexPath:indexPath];
    
    if (!cell){
        cell = [[ShortkeyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"symbolCell"];
    }
    
    NSNumber* row = [NSNumber numberWithInt:indexPath.row];
    cell.isActive = [selectedSymbols.allKeys containsObject:row];
    
    QuickSymbol* symbolForCurrentCell = (QuickSymbol*)[tableData objectForKey:row];
    cell.labelShortkey.text = [Utils trimWhitespaces:symbolForCurrentCell.symbTitle];
    cell.tag = symbolForCurrentCell.symbId;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == tableData.count){ // extra row (add new symbol)
        return;
    }
    
    NSNumber* row = [NSNumber numberWithInt:indexPath.row];
    QuickSymbol* checkedSymbol = [tableData objectForKey:row];
    if ([selectedSymbols.allValues containsObject:[NSNumber numberWithInt:checkedSymbol.symbId]]){
        [DataManager removeQuickSymbol:checkedSymbol.symbId fomLanguageUsage:self.projectLanguge];
    } else {
        [DataManager putQuickSymbol:checkedSymbol.symbId toLanguageUsage:self.projectLanguge atIndex:selectedSymbols.count];
    }
    [self updateData];
    [self.delegate symbolsLayoutChanged:SYMBOL_STATE_CHANGED];
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
    [DataManager putQuickSymbol:symbolFromCell.symbId toLanguageUsage:self.projectLanguge atIndex:toIndexPath.row];
    [self updateData];
    [self.delegate symbolsLayoutChanged:SYMBOL_MOVED];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        int symbId = cell.tag;
        
        for (NSNumber* lang in [DataManager getLanguagesSymbolUsedFor:symbId]) {
            [DataManager removeQuickSymbol:symbId fomLanguageUsage:lang.intValue];
        }
        [DataManager deleteQuickSymbol:symbId];
        [self updateData];
        [self.delegate symbolsLayoutChanged:SYMBOL_DELETED];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.editing && indexPath.row < tableData.count;
}

- (IBAction)editTablePressed:(id)sender{
    self.editing = !self.editing;
    
    [self.tableSymbols setEditing:self.editing animated:YES];
    [self updateEditButton];
    [self.tableSymbols reloadData];
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

-(void)wishToCreateNewShortkeyWithSymbol:(NSString *)text{
    NSString* toAdd = [text substringToIndex:1];
    int newSymbolId = [DataManager createQuickSymbol:toAdd];
    if (newSymbolId != -1){
        [DataManager putQuickSymbol:newSymbolId toLanguageUsage:self.projectLanguge atIndex:selectedSymbols.count];
        [self updateData];
        [self.delegate symbolsLayoutChanged:SYMBOL_ADDED];
    }
}

// iPhone
-(void)backPressed{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    if (IPAD){
        return;
    }
    
    NSValue *aValue = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    CGFloat keyboardTop = keyboardRect.origin.y;
    CGRect newTextViewFrame = CGRectMake(0.0, 0.0, self.tableSymbols.frame.size.width, self.tableSymbols.frame.size.width);// self.textCode.bounds;
    newTextViewFrame.size.height = keyboardTop - self.view.bounds.origin.y;
    
    NSValue *animationDurationValue = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    self.tableSymbols.frame = newTextViewFrame;
    
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    if (IPAD){
        return;
    }
    
    NSValue *animationDurationValue = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    self.tableSymbols.frame = self.view.bounds;
    
    [UIView commitAnimations];
}

@end

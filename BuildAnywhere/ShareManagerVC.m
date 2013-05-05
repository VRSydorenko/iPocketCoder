//
//  ShareManagerVC.m
//  PocketCoder
//
//  Created by Viktor Sydorenko on 5/5/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "ShareManagerVC.h"
#import "MainNavController.h"

@interface ShareManagerVC (){
    MainNavController *navCon;
    NSMutableArray* contentTypesToShare;
}
@end

@implementation ShareManagerVC

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    contentTypesToShare = [[NSMutableArray alloc] init];
    navCon = (MainNavController*)self.navigationController;
    
    if (!IPAD){ // to save more space on navigation bar
        [navCon createMiniBackButtonWithBackPressedSelectorOnTarget:self];
    }
    
    self.tableContent.delegate = self;
    self.tableContent.dataSource = self;
    
    [self updateShareButtonState];
}

- (void)viewDidUnload {
    [self setTableContent:nil];
    [self setShareItem:nil];
    [super viewDidUnload];
}

- (IBAction)sharePressed:(id)sender {
    [self.delegate shareManagerDidSelectContentToShare:contentTypesToShare];
}

-(void)dealloc{
    contentTypesToShare = nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6; // all content types
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cellContentType"];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellContentType"];
    }
    
    switch (indexPath.row) {
        case 0:{
            [self setupCell:cell ofType:LINK withText:@"URL"];
            break;
        }
        case 1:{
            [self setupCell:cell ofType:SOURCE withText:@"Source code"];
            break;
        }
        case 2:{
            [self setupCell:cell ofType:INPUT withText:@"Input (stdin)"];
            break;
        }
        case 3:{
            [self setupCell:cell ofType:OUTPUT withText:@"Output (stdout)"];
            break;
        }
        case 4:{
            [self setupCell:cell ofType:CMPINFO withText:@"Compiler info"];
            break;
        }
        case 5:{
            [self setupCell:cell ofType:STDERRINFO withText:@"Stderr info"];
            break;
        }
    }
    return cell;
}

-(void)setupCell:(UITableViewCell*)cell ofType:(ShareContentType)type withText:(NSString*)text{
    NSNumber *typeItem;
    BOOL typeAvailable;
    BOOL typeSelected;
    typeItem = [NSNumber numberWithUnsignedInt:type];
    typeAvailable = [self.availableContentTypes containsObject:typeItem];
    cell.textLabel.text = text;
    cell.textLabel.enabled = typeAvailable;
    cell.detailTextLabel.text = typeAvailable ? @"" : @"not available";
    cell.detailTextLabel.enabled = typeAvailable;
    typeSelected = [contentTypesToShare containsObject:typeItem];
    cell.accessoryType = typeSelected ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    cell.tag = type; // type is saved within the cell
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSNumber *type = [NSNumber numberWithUnsignedInt:cell.tag];
    
    if (![self.availableContentTypes containsObject:type]){
        return;
    }
    
    if ([contentTypesToShare containsObject:type]){
        [contentTypesToShare removeObject:type];
    } else {
        [contentTypesToShare addObject:type];
    }
    [self.tableContent reloadData];
    [self updateShareButtonState];
}

// iPhone
-(void)backPressed{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) updateShareButtonState{
    self.shareItem.enabled = contentTypesToShare.count > 0;
}

@end

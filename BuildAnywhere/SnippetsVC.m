//
//  SnippetsVC.m
//  BuildAnywhere
//
//  Created by Viktor Sydorenko on 2/17/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "SnippetsVC.h"

@interface SnippetsVC (){
    MainNavController* navCon;
    NSArray* snippets;
}
@end

@implementation SnippetsVC

@synthesize language;

-(id) initWithLanguage:(int)lang{
    self = [super init];
    if (self){
        self.language = lang;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    navCon = (MainNavController*)self.navigationController;
    
    if (!IPAD){ // to save more space on navigation bar
        [navCon createMiniBackButtonWithBackPressedSelectorOnTarget:self];
    }
    
    [navCon hideToolBarAnimated:NO];
    
    snippets = [DataManager getSnippetNamesForLanguage:self.language];
    
    self.tableSnippets.dataSource = self;
    self.tableSnippets.delegate = self;
    
    [self updateData];
}

-(void) viewDidAppear:(BOOL)animated{
    [navCon hideToolBarAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return MAX(1, snippets.count);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cellSnippet"];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellSnippet"];
    }
    if (snippets.count > 0){
        cell.textLabel.text = [snippets objectAtIndex:indexPath.row];
    } else {
        cell.textLabel.text = @"No snippets";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (snippets.count >= indexPath.row+1){
        [self.delegate snippetSelected:[snippets objectAtIndex:indexPath.row]];
    }
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"segueSnippetsToNewSnippet"]){
        NewSnippetVC* newSnippetVC = (NewSnippetVC*)segue.destinationViewController;
        newSnippetVC.language = self.language;
        newSnippetVC.delegate = self;
    }
}

-(void) newSnippetCreationFinished:(BOOL)snippetCreated fromController:(NewSnippetVC*)controller{
    if (snippetCreated){
        [self updateData];
    }
}

-(void) updateData{
    snippets = [DataManager getSnippetNamesForLanguage:self.language];
    [self.tableSnippets reloadData];
}

// iPhone
-(void)backPressed{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload {
    [self setTableSnippets:nil];
    [super viewDidUnload];
}
@end

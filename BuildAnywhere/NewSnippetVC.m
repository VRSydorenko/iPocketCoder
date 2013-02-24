//
//  NewSnippetVC.m
//  BuildAnywhere
//
//  Created by Viktor Sydorenko on 2/18/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "NewSnippetVC.h"

@interface NewSnippetVC (){
    MainNavController* navCon;
    NSArray* snippets;
}
@end

@implementation NewSnippetVC

@synthesize language;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    navCon = (MainNavController*)self.navigationController;
    
    if (!IPAD){ // to save more space on navigation bar
        [navCon createMiniBackButtonWithBackPressedSelectorOnTarget:self];
        [navCon hideToolBarAnimated:NO];
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    snippets = [DataManager getSnippetNamesForLanguage:self.language];
    
    [self.textCode.layer setBorderColor: [[UIColor grayColor] CGColor]];
    [self.textCode.layer setBorderWidth: 1.0];
    [self.textCode.layer setCornerRadius:8.0f];
}

-(void) viewDidAppear:(BOOL)animated{
    if (IPAD){
        [navCon showToolbarAnimated:YES];
    }
}

-(void)backPressed{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload {
    [self setTextCode:nil];
    [self setTextName:nil];
    [super viewDidUnload];
}

- (IBAction)addPressed:(id)sender {
    if (!IPAD){
        [self.textName resignFirstResponder];
        [self.textCode resignFirstResponder];
    }
    self.textName.text = [self.textName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (self.textName.text.length == 0){
        if (IPAD){
            [navCon showMessageBox:@"Enter snippet title" text:@""];
        } else {
            [navCon showInfoBarWithNeutralMessage:@"Enter snippet title"];
        }
        return;
    }
    if ([snippets containsObject:self.textName.text]){
        if (IPAD){
            [navCon showMessageBox:@"Snippet with such name for current programming language already exists" text:@""];
        } else {
            [navCon showInfoBarWithNeutralMessage:@"Snippet with such name for current programming language already exists"];
        }
        return;
    }
    if (self.textCode.text.length == 0){
        if (IPAD){
            [navCon showMessageBox:@"The snippet is empty" text:@""];
        } else {
            [navCon showInfoBarWithNeutralMessage:@"The snippet is empty"];
        }
        return;
    }
    Snippet* newSnippet = [[Snippet alloc] initWithLanguage:self.language name:self.textName.text code:self.textCode.text];
    [DataManager saveSnippet:newSnippet];
    [self.delegate newSnippetCreationFinished:YES fromController:self];
    [navCon popViewControllerAnimated:YES];
}

@end

//
//  AddShortkeyCell.m
//  PocketCoder
//
//  Created by Viktor Sydorenko on 3/27/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "AddShortkeyCell.h"

@implementation AddShortkeyCell

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@" "]){
        return NO;
    }
    
    text = [Utils trimWhitespaces:text];
    
    if ([text isEqualToString:@"\n"]){
        [self.textShortkey resignFirstResponder];
        return NO;
    }
    
    if (text.length > 1){
        text = [text substringToIndex:1];
    }
    self.textShortkey.text = @"";
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView{
    self.btnAdd.enabled = self.textShortkey.text.length > 0;
}

-(IBAction)addSymbolPressed{
    NSString* text = self.textShortkey.text;
    [self.shortkeyCreationDelegate wishToCreateNewShortkeyWithSymbol:text];
    self.textShortkey.text = @"";
}

@end

//
//  EditorVC.m
//  BuildAnywhere
//
//  Created by Viktor Sydorenko on 2/17/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "EditorVC.h"

@interface EditorVC (){
    Project* project;
    UIPopoverController* popoverController;
    MainNavController* navCon;
    NSDictionary* quickSymbols;
}
@end

@implementation EditorVC

@synthesize projectName;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                          selector:@selector(keyboardWillShow:)
                                          name:UIKeyboardWillShowNotification
                                          object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                          selector:@selector(keyboardWillHide:)
                                          name:UIKeyboardWillHideNotification
                                          object:nil];
    self.textCode.delegate = self;
    self.textCode.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    [self setupAccessoryView];
    
    navCon = (MainNavController*)self.navigationController;
    
    if (!IPAD){ // to save more space on navigation bar 
        [navCon createMiniBackButtonWithBackPressedSelectorOnTarget:self];
    }
    
    project = self.projectName.length > 0 ? [DataManager loadProject:self.projectName] : nil;
    self.navigationItem.title = project.projName;
}

-(void) viewDidAppear:(BOOL)animated{
    [navCon showToolbarAnimated:YES];
}

// iPhone
-(void)backPressed{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) viewWillDisappear:(BOOL)animated{
    if ([navCon.viewControllers indexOfObject:self] == NSNotFound){ // back button
        if (popoverController){
            if ([popoverController isPopoverVisible]){
                [popoverController dismissPopoverAnimated:YES];
                return;
            }
            popoverController = nil;
        }
    }
}

- (IBAction)snippetsPressed:(id)sender {
    if (IPAD){
        if (popoverController){
            if ([popoverController isPopoverVisible]){
                [popoverController dismissPopoverAnimated:YES];
                return;
            }
            popoverController = nil;
        }
        
        MainNavController *snippetsMainVC = [[UIStoryboard storyboardWithName:@"iPhoneMain" bundle:nil] instantiateViewControllerWithIdentifier:@"screenSnippets"];
        if (!snippetsMainVC){
            return;
        }
        ((SnippetsVC*)[snippetsMainVC.viewControllers objectAtIndex:0]).language = project.projLanguage;
        
        popoverController = [[UIPopoverController alloc] initWithContentViewController:snippetsMainVC];
        [popoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)aTextView {
    if (self.textCode.inputAccessoryView == nil) {
        self.textCode.inputAccessoryView = self.accessoryView;
    }
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)aTextView {
    [self.textCode resignFirstResponder];
    return YES;
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSValue *aValue = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    CGFloat keyboardTop = keyboardRect.origin.y;
    CGRect newTextViewFrame = self.view.bounds;
    newTextViewFrame.size.height = keyboardTop - self.view.bounds.origin.y;
    
    NSValue *animationDurationValue = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    self.textCode.frame = newTextViewFrame;
    
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSValue *animationDurationValue = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    self.textCode.frame = self.view.bounds;
    
    [UIView commitAnimations];
}

- (void)setupAccessoryView
{
    if (self.accessoryView){
        return;
    }
    
    float buttonWidth = IPAD ? 50.0 : 25.0;
    float buttonPadding = IPAD ? 10.0 : 5.0; // left & right
    float barHeight = IPAD ? 60.0 : 40.0;
    float buttonFontSize = IPAD ? 25.0 : 15.0;
    
    float barWidth = self.view.frame.size.width;
    float barPadding = 5.0; // top & bottom
    CGRect barRect = CGRectMake(0.0, self.view.frame.size.height - barHeight, barWidth, barHeight);
    
	UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:barRect];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    [scrollView setShowsVerticalScrollIndicator:NO];
    scrollView.backgroundColor = [UIColor lightGrayColor];
    
    UIFont *accessoryButtonFont = [UIFont fontWithName:@"Helvetica" size:buttonFontSize];
    
    NSMutableDictionary* symbolsMap = [[NSMutableDictionary alloc] init];
    NSArray *symbols = [DataManager getQuickSymbols];
    for (QuickSymbol* symbol in symbols) {
        float btnX = symbol.symbId*buttonWidth + (symbol.symbId+1.0)*buttonPadding;
        float btnHeight = barHeight - 2.0*barPadding;
        float btnWidth = buttonWidth;
		CGRect btnRect = CGRectMake(btnX, 0.0, btnWidth, btnHeight);
        
        UILabel *button = [[UILabel alloc] initWithFrame:btnRect];
        button.layer.cornerRadius = 5.0;
        button.layer.borderColor = [UIColor blackColor].CGColor;
        button.layer.borderWidth = 0.5f;
        button.backgroundColor = [UIColor whiteColor];
        button.text = [symbol.symbTitle stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
;
        button.textAlignment = NSTextAlignmentCenter;
        button.font = accessoryButtonFont;
        
        button.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(accessoryButtonPressed:)];
        [button addGestureRecognizer:tapGesture];
        
        button.tag = symbol.symbId;
        
        [scrollView addSubview:button];
        button.center = CGPointMake(btnRect.origin.x+btnWidth/2.0, barRect.size.height/2.0);
        
        [symbolsMap setObject:symbol.symbContent forKey:[NSNumber numberWithInt:symbol.symbId]];
	}
	
	[scrollView setContentSize:CGSizeMake(symbols.count*(buttonPadding+buttonWidth)+buttonPadding, barHeight)];
    
    quickSymbols = [[NSDictionary alloc] initWithDictionary:symbolsMap];
    
    self.accessoryView = scrollView;
                                          
}

- (IBAction)accessoryButtonPressed:(UIGestureRecognizer*)gestureRecognizer {
    UILabel* accessoryButton = (UILabel*)gestureRecognizer.view;
    if (!accessoryButton){
        return;
    }
    
    NSString* content = (NSString*)[quickSymbols objectForKey:[NSNumber numberWithInt:accessoryButton.tag]];
        
    NSMutableString *text = [self.textCode.text mutableCopy];
    NSRange selectedRange = self.textCode.selectedRange;
    
    [text replaceCharactersInRange:selectedRange withString:content];
    self.textCode.text = text;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:nil object:nil];
}

@end

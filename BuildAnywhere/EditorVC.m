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
    RunManager* runManager;
    BOOL detailsRequested;
    BOOL showResultsOnArrive;
    
    NSString* lastCmpInfo;
    NSString* lastOutput;
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
    
    runManager = [[RunManager alloc] init];
    runManager.handler = self;
   
    detailsRequested = NO;
    showResultsOnArrive = NO;
    
    if (!IPAD){ // to save more space on navigation bar 
        [navCon createMiniBackButtonWithBackPressedSelectorOnTarget:self];
    }
    
    project = self.projectName.length > 0 ? [DataManager loadProject:self.projectName] : nil;
    if (project){
        self.textCode.text = project.projCode;
        self.navigationItem.title = project.projName;
    }
}

-(void) viewDidAppear:(BOOL)animated{
    [navCon showToolbarAnimated:YES];
}

// iPhone
-(void)backPressed{
    project.projCode = self.textCode.text;
    [project save];
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
        
        project.projCode = self.textCode.text;
        [project save];
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
        SnippetsVC* snippetsVC = ((SnippetsVC*)[snippetsMainVC.viewControllers objectAtIndex:0]);
        snippetsVC.language = project.projLanguage;
        snippetsVC.delegate = self;
        
        popoverController = [[UIPopoverController alloc] initWithContentViewController:snippetsMainVC];
        [popoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

-(void) updateToolbarWithSpinner:(BOOL)needed statusText:(NSString*)text{
    NSMutableArray *items = [[NSMutableArray alloc] init];
    if (needed){
        UIActivityIndicatorView* act = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:IPAD?UIActivityIndicatorViewStyleGray:UIActivityIndicatorViewStyleWhite];
        [act startAnimating];
        [items addObject:[[UIBarButtonItem alloc] initWithCustomView:act]];
    }
    if (text.length > 0){
        UIBarButtonItem *textItem = [[UIBarButtonItem alloc] initWithTitle:text style:UIBarButtonItemStylePlain target:nil action:nil];
        textItem.title = text;
        [items addObject:textItem];
    }
    [items addObject:self.flexItem];
    self.inputItem.enabled = !needed;
    [items addObject:self.inputItem];
    self.runItem.enabled = !needed;
    [items addObject:self.runItem];
    
    [self setToolbarItems:items animated:YES];
}

-(void) updateToolbarWithViewResultsButton{
    NSMutableArray *items = [[NSMutableArray alloc] init];
    
    [items addObject:[[UIBarButtonItem alloc] initWithTitle:@"View results" style:UIBarButtonItemStyleBordered target:self action:@selector(viewOutput)]];
     
    [items addObject:self.flexItem];
    self.inputItem.enabled = YES;
    [items addObject:self.inputItem];
    self.runItem.enabled = YES;
    [items addObject:self.runItem];
    
    [self setToolbarItems:[[NSArray alloc] initWithArray:items] animated:YES];
}

// iPhone
- (IBAction)hideKeyboardPressed:(id)sender {
    [self textViewShouldEndEditing:self.textCode];
}

- (IBAction)inputPressed:(id)sender {
    if (IPAD){
        if (popoverController){
            if ([popoverController isPopoverVisible]){
                [popoverController dismissPopoverAnimated:YES];
                return;
            }
            popoverController = nil;
        }
        
        MainNavController *inputVC = [[UIStoryboard storyboardWithName:@"iPhoneMain" bundle:nil] instantiateViewControllerWithIdentifier:@"screenInput"];
        if (!inputVC){
            return;
        }
        ((InputVC*)[inputVC.viewControllers objectAtIndex:0]).project = project;
        
        popoverController = [[UIPopoverController alloc] initWithContentViewController:inputVC];
        [popoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    } else {
        [self performSegueWithIdentifier:@"segueEditorToInput" sender:self];
    }
}

- (IBAction)runPressed:(id)sender {
    project.projCode = self.textCode.text;
    [project save];
    
    [runManager createSubmission:project run:YES];
    
    [self updateToolbarWithSpinner:YES statusText:@"Processing..."];
}

-(void)viewOutput{
    if (detailsRequested){
        [self updateToolbarWithSpinner:YES statusText:@"Working..."];
        showResultsOnArrive = YES;
    } else {
        [self performSegueWithIdentifier:@"segueEditorToOutput" sender:self];
        showResultsOnArrive = NO;
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"segueEditorToOutput"]){
        ResultsVC* outputVC = (ResultsVC*)segue.destinationViewController;
        int maxOutputLength = 3000;
        outputVC.output = lastOutput.length > maxOutputLength ? [lastOutput substringToIndex:maxOutputLength] : lastOutput;
        outputVC.cmpInfo = lastCmpInfo;
    } else if ([segue.identifier isEqualToString:@"segueEditorToInput"]){
        InputVC* inputVC = (InputVC*)segue.destinationViewController;
        inputVC.project = project;
    } else if ([segue.identifier isEqualToString:@"segueEditorToSnippets"]){
        SnippetsVC* snippetsVC = (SnippetsVC*)segue.destinationViewController;
        snippetsVC.language = project.projLanguage;
        snippetsVC.delegate = self;
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
    CGRect newTextViewFrame = self.textCode.bounds;
    newTextViewFrame.size.height = keyboardTop - self.view.bounds.origin.y;
    
    NSValue *animationDurationValue = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    self.textCode.frame = newTextViewFrame;
    self.btnHideKeyboard.hidden = NO;
    
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSValue *animationDurationValue = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    self.textCode.frame = self.view.bounds;
    self.btnHideKeyboard.hidden = YES;
    
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

-(void)snippetSelected:(NSString*)code{
    if (IPAD){
        if (popoverController){
            if ([popoverController isPopoverVisible]){
                [popoverController dismissPopoverAnimated:YES];
            }
            popoverController = nil;
        }
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    [self insertTextInEditor:code];
}

- (IBAction)accessoryButtonPressed:(UIGestureRecognizer*)gestureRecognizer {
    UILabel* accessoryButton = (UILabel*)gestureRecognizer.view;
    if (!accessoryButton){
        return;
    }
    
    NSString* content = (NSString*)[quickSymbols objectForKey:[NSNumber numberWithInt:accessoryButton.tag]];
    [self insertTextInEditor:content];
}

-(void)insertTextInEditor:(NSString*)content{
    NSMutableString *text = [self.textCode.text mutableCopy];
    
    @try {
        NSRange selectedRange = self.textCode.selectedRange;
        [text replaceCharactersInRange:selectedRange withString:content];
        self.textCode.text = text;
        NSRange newSelectedRange = {selectedRange.location + content.length, 0};
        self.textCode.selectedRange = newSelectedRange;
    }
    @catch (NSException *exception) {
        self.textCode.text = [self.textCode.text stringByAppendingString:content];
    }
}

-(void)submissionCreatedWithError:(int)errorCode andLink:(NSString*)link{
    if (errorCode == OK){
        [project setLink:link];
        [project save];
    
        //check result in 2 sec
        [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(checkSubmissionState) userInfo:nil repeats:NO];
    } else {
        [self updateToolbarWithViewResultsButton];
        [navCon showInfoBarWithNegativeMessage:@"Error occurred!"];
    }
}
-(void)checkSubmissionState{
    [runManager getSubmissionStatus:project.projLink];
    NSLog(@"check submission status called");
}

-(void)submissionStatusReceived:(int)status error:(int)error result:(int)result{
    if (error == OK){
        if (status < 0){
            [self updateToolbarWithSpinner:YES statusText:@"Awaiting processing..."];
            //check result in 2 sec
            [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(checkSubmissionState) userInfo:nil repeats:NO];
        } else {
            switch (status) {
                case 0:{
                    if (result == SUCCESS || result == NOT_RUNNING){
                        [navCon showInfoBarWithPositiveMessage:@"Success!"];
                    } else {
                        [navCon showInfoBarWithNegativeMessage:@"Failure!"];
                    }
                    [runManager getSubmissionDetails:project.projLink];
                    [self updateToolbarWithViewResultsButton];
                    detailsRequested = YES;
                    break;
                }
                case 1:{
                    [self updateToolbarWithSpinner:YES statusText:@"Compiling..."];
                    //check result in 2 sec
                    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(checkSubmissionState) userInfo:nil repeats:NO];
                    break;
                }
                case 3:{
                    [self updateToolbarWithSpinner:YES statusText:@"Running..."];
                    //check result in 2 sec
                    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(checkSubmissionState) userInfo:nil repeats:NO];
                    break;
                }
            }
        }
    }
}
-(void)submissionDetailsReceived:(NSString*)output cmpinfo:(NSString*)cmpinfo{
    lastCmpInfo = cmpinfo;
    lastOutput = output;
    
    detailsRequested = NO;
    
    [self updateToolbarWithViewResultsButton];
    if (showResultsOnArrive){
        [self viewOutput];
    }
}
-(void)testResponseReceived{
    
}
-(void)errorOccurred{
    [self updateToolbarWithSpinner:NO statusText:@""];
    [navCon showInfoBarWithNegativeMessage:@"Service error"];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:nil object:nil];
    [self setFlexItem:nil];
    [self setInputItem:nil];
    [self setRunItem:nil];
}

- (void)viewDidUnload {
    [self setBtnHideKeyboard:nil];
    [super viewDidUnload];
}
@end

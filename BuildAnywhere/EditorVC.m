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
    BOOL keyboardActive;
    
    NSString* lastCmpInfo;
    NSString* lastOutput;
    NSString* lastStdErr;
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
    
    navCon = (MainNavController*)self.navigationController;
    navCon.rotationTrigger = self;
    
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
        
        if (![UserSettings getSymbolsInitializedForLang:project.projLanguage]){
            int i = 0;
            for (QuickSymbol* symbol in [DataManager getQuickSymbols]) {
                [DataManager putQuickSymbol:symbol.symbId toLanguageUsage:project.projLanguage atIndex:i];
                i++;
            }
            [UserSettings setSymbolsInitializedForLang:project.projLanguage];
        }
    }
    
    keyboardActive = NO;
    self.btnShortkeysSettings.hidden = YES;
    [self textViewDidEndEditing:self.textCode]; // updating Share button state
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
    } else {
        [items addObject:self.shareItem];
        self.shareItem.enabled = !needed;
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

    [items addObject:self.shareItem];
    self.shareItem.enabled = YES;
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
        outputVC.projectName = project.projName;
        outputVC.output = lastOutput.length > maxOutputLength ? [lastOutput substringToIndex:maxOutputLength] : lastOutput;
        outputVC.cmpInfo = lastCmpInfo;
        outputVC.stdErr = lastStdErr;
    } else if ([segue.identifier isEqualToString:@"segueEditorToInput"]){
        InputVC* inputVC = (InputVC*)segue.destinationViewController;
        inputVC.project = project;
    } else if ([segue.identifier isEqualToString:@"segueEditorToSnippets"]){
        SnippetsVC* snippetsVC = (SnippetsVC*)segue.destinationViewController;
        snippetsVC.language = project.projLanguage;
        snippetsVC.delegate = self;
    } else if ([segue.identifier isEqualToString:@"segueEditorToSymbolsManager"]){
        QuickSymbolManager* symbolsManagerVC = (QuickSymbolManager*)segue.destinationViewController;
        symbolsManagerVC.projectLanguge = project.projLanguage;
        symbolsManagerVC.delegate = self;
    }
}

-(void)screenOrientationChanged{
    [self symbolsLayoutChanged:SCREEN_ROTATED];
    if (IPAD){
        // TODO: moving popover to look nice after orientation change
        if (popoverController){
            if ([popoverController isPopoverVisible]){
                [popoverController dismissPopoverAnimated:YES];
                return;
            }
            popoverController = nil;
        }
    }
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)aTextView {
    if (self.textCode.inputAccessoryView == nil) {
        if (!self.accessoryView){
            [self setupAccessoryView];
        }
        self.textCode.inputAccessoryView = self.accessoryView;
    }
    return YES;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)aTextView {
    [self.textCode resignFirstResponder];
    self.textCode.inputAccessoryView = nil;
    return YES;
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    NSString *trimmedCode = [Utils trimWhitespaces:self.textCode.text];
    self.shareItem.enabled = trimmedCode.length > 0 // code is not whitespaces only
                             || (project.projLanguage == 6 && self.textCode.text.length > 0) // it's OK for Whitespace lang (code 6)
                             || project.projLink.length > 0;
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSValue *aValue = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    CGFloat keyboardTop = keyboardRect.origin.y;
    CGRect newTextViewFrame = CGRectMake(0.0, 0.0, self.textCode.frame.size.width, self.textCode.frame.size.width);// self.textCode.bounds;
    newTextViewFrame.size.height = keyboardTop - self.view.bounds.origin.y;
    
    CGPoint smallBtnSettingCenterPoint = self.btnShortkeysSettings.center;
    smallBtnSettingCenterPoint.y = keyboardTop - self.btnShortkeysSettings.frame.size.height/2;
    
    int symbolsCountForCurrLang = [DataManager getOrderedSymbolIDsForLanguage:project.projLanguage].count;
    
    NSValue *animationDurationValue = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    self.textCode.frame = newTextViewFrame;
    self.btnHideKeyboard.hidden = NO;
    self.btnShortkeysSettings.hidden = symbolsCountForCurrLang > 0;
    self.btnShortkeysSettings.center = smallBtnSettingCenterPoint;
    keyboardActive = YES;
    
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    CGPoint smallBtnSettingCenterPoint = self.btnShortkeysSettings.center;
    smallBtnSettingCenterPoint.y = self.view.bounds.size.height - self.btnShortkeysSettings.frame.size.height/2;
    
    NSValue *animationDurationValue = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    self.textCode.frame = self.view.bounds;
    self.btnHideKeyboard.hidden = YES;
    self.btnShortkeysSettings.hidden = YES;
    self.btnShortkeysSettings.center = smallBtnSettingCenterPoint;
    keyboardActive = NO;
    
    [UIView commitAnimations];
}

- (void)setupAccessoryView
{
    if (self.accessoryView){
        self.accessoryView = nil;
    }
    
    float buttonWidth = IPAD ? 50.0 : 25.0;
    float buttonPadding = IPAD ? 10.0 : 5.0; // left & right
    float barHeight = IPAD ? 60.0 : 40.0;
    float buttonFontSize = IPAD ? 25.0 : 15.0;
    
    float barWidth = self.view.frame.size.width;
    float barPadding = 5.0; // top & bottom
    CGRect barRect = CGRectMake(0.0, self.view.frame.size.height - barHeight, barWidth, barHeight);
    
    NSDictionary* symbolsForCurrentLanguage = [DataManager getOrderedSymbolIDsForLanguage:project.projLanguage];
    if (symbolsForCurrentLanguage.count > 0){
        UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:barRect];
        [scrollView setShowsHorizontalScrollIndicator:NO];
        [scrollView setShowsVerticalScrollIndicator:NO];
        scrollView.backgroundColor = [UIColor lightGrayColor];
    
        UIFont *accessoryButtonFont = [UIFont fontWithName:@"Helvetica" size:buttonFontSize];
    
        NSMutableDictionary* symbolsMap = [[NSMutableDictionary alloc] init];
        for (int i = 0; i < symbolsForCurrentLanguage.count; i++) {
            NSNumber* symbId = (NSNumber*)[symbolsForCurrentLanguage objectForKey:[NSNumber numberWithInt:i]];
            QuickSymbol* operatingSymbol = [DataManager loadQuickSymbol:symbId.intValue];
        
            float btnX = i*buttonWidth + (i+1.0)*buttonPadding;
            float btnHeight = barHeight - 2.0*barPadding;
            float btnWidth = buttonWidth;
            CGRect btnRect = CGRectMake(btnX, 0.0, btnWidth, btnHeight);
        
            UILabel *button = [[UILabel alloc] initWithFrame:btnRect];
            [self setupShortKeyButtonCommonProperties:&button];
            button.text = [operatingSymbol.symbTitle stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            button.font = accessoryButtonFont;

            
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(accessoryButtonPressed:)];
            [button addGestureRecognizer:tapGesture];
        
            button.tag = symbId.intValue;
        
            [scrollView addSubview:button];
            button.center = CGPointMake(btnRect.origin.x+btnWidth/2.0, barRect.size.height/2.0);
        
            [symbolsMap setObject:operatingSymbol.symbContent forKey:symbId];
        }
    
        float scrollContentWidth = MAX(barWidth, (symbolsForCurrentLanguage.count+2/*extra room for space & settings button*/)*(buttonPadding+buttonWidth)-buttonPadding);
    
        // space & settings button
        float btnX = scrollContentWidth - buttonWidth - buttonPadding;
        float btnHeight = barHeight - 2.0*barPadding;
        float btnWidth = buttonWidth;
        CGRect btnRect = CGRectMake(btnX, 0.0, btnWidth, btnHeight);
    
        UIImageView *btnSettings = [[UIImageView alloc] initWithFrame:btnRect];
        [self setupShortKeyButtonCommonProperties:&btnSettings];
        btnSettings.image = [UIImage imageNamed:IPAD?@"padSettings.png":@"phoneSettings.png"];
        btnSettings.contentMode = UIViewContentModeScaleAspectFit;
    
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(accessorySettingsButtonPressed:)];
        [btnSettings addGestureRecognizer:tapGesture];
    
        [scrollView addSubview:btnSettings];
        btnSettings.center = CGPointMake(btnRect.origin.x+btnWidth/2.0, barRect.size.height/2.0);
        
        // setting scroll size
	
        [scrollView setContentSize:CGSizeMake(scrollContentWidth, barHeight)];
    
        quickSymbols = nil;
        quickSymbols = [[NSDictionary alloc] initWithDictionary:symbolsMap];
    
        self.accessoryView = scrollView;
    }
}

-(void)symbolsLayoutChanged:(SymbolsLayoutChange)action{
    BOOL needBecome = NO;
    if (keyboardActive || action == SYMBOL_ADDED){
        needBecome = YES;
        [self.textCode resignFirstResponder];
    }
    self.textCode.inputAccessoryView = nil;
    [self setupAccessoryView];
    self.textCode.inputAccessoryView = self.accessoryView;
    if (needBecome){
        [self.textCode becomeFirstResponder];
    }
}

-(void)setupShortKeyButtonCommonProperties:(UIView**)btn{
    (*btn).layer.cornerRadius = 5.0;
    (*btn).layer.borderColor = [UIColor blackColor].CGColor;
    (*btn).layer.borderWidth = 0.5f;
    (*btn).backgroundColor = [UIColor whiteColor];
    (*btn).userInteractionEnabled = YES;
    if ([(*btn) isKindOfClass:[UILabel class]]){
        ((UILabel*)(*btn)).textAlignment = NSTextAlignmentCenter;
    }
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

- (IBAction)accessorySmallSettingsButtonPressed{
    [self accessorySettingsButtonPressed:nil];
}

- (IBAction)accessorySettingsButtonPressed:(UIGestureRecognizer*)gestureRecognizer {
    if (IPAD){
        if (popoverController){
            if ([popoverController isPopoverVisible]){
                [popoverController dismissPopoverAnimated:YES];
                return;
            }
            popoverController = nil;
        }
        
        MainNavController *shortkeysManagerVC = [[UIStoryboard storyboardWithName:@"iPhoneMain" bundle:nil] instantiateViewControllerWithIdentifier:@"screenSymbolsManager"];
        if (!shortkeysManagerVC){
            return;
        }
        QuickSymbolManager* manager = (QuickSymbolManager*)[shortkeysManagerVC.viewControllers objectAtIndex:0];
        manager.projectLanguge = project.projLanguage;
        manager.delegate = self;
        
        CGRect showPointRect = CGRectMake(self.textCode.bounds.size.width, self.textCode.bounds.size.height, 1, 1);
        popoverController = [[UIPopoverController alloc] initWithContentViewController:shortkeysManagerVC];
        [popoverController presentPopoverFromRect:showPointRect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    } else {
        [self performSegueWithIdentifier:@"segueEditorToSymbolsManager" sender:self];
    }
}

-(void)insertTextInEditor:(NSString*)content{
    NSMutableString *text = [self.textCode.text mutableCopy];
    self.textCode.scrollEnabled = NO;
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
    self.textCode.scrollEnabled = YES;
    [self textViewDidEndEditing:self.textCode]; // updating Share button state
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
-(void)submissionDetailsReceived:(NSString*)output cmpinfo:(NSString*)cmpinfo stdErr:(NSString *)stdErr{
    lastCmpInfo = cmpinfo;
    lastOutput = output;
    lastStdErr = stdErr;
    
    detailsRequested = NO;
    
    [self updateToolbarWithViewResultsButton];
    if (showResultsOnArrive){
        [self viewOutput];
    }
}
-(void)testResponseReceived{
    
}
-(void)errorOccurred:(NSError*)error{
    [self updateToolbarWithSpinner:NO statusText:@""];
    [navCon showInfoBarWithNegativeMessage:error.localizedDescription];
}

-(IBAction)sharePressed:(id)sender{
    if (self.textCode.text.length == 0 && project.projLink.length == 0){
        return;
    }
    
    UIActionSheet *shareActionSheet = [[UIActionSheet alloc] initWithTitle:@"Sharing options:" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    
    if (self.textCode.text.length > 0){
        [shareActionSheet addButtonWithTitle:@"Source code"];
    }
    if (project.projLink.length > 0){
        [shareActionSheet addButtonWithTitle:@"The latest code run (URL)"];
    }
    [shareActionSheet addButtonWithTitle:@"Cancel"];
    shareActionSheet.cancelButtonIndex = shareActionSheet.numberOfButtons - 1;
    
    [shareActionSheet showFromToolbar:navCon.toolbar];
    //[shareActionSheet showInView:self.view];
}

-(void) actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == actionSheet.cancelButtonIndex){
        return;
    }
    
    NSString* shareIntroString = [NSString stringWithFormat:@"%@ source code from iPocketCoder:", [DataManager getLanguageName:project.projLanguage]];
    
    NSString* textToShare = @"";
    if (buttonIndex == 0 && self.textCode.text.length > 0){ // [source]
        textToShare = [NSString stringWithFormat:@"%@\n\n%@", shareIntroString, self.textCode.text];
    } else { // [link]
        textToShare = [NSString stringWithFormat:@"Link to the %@ http://ideone.com/%@", shareIntroString, project.projLink];
    }
    
    [Utils shareText:textToShare overViewController:self];
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

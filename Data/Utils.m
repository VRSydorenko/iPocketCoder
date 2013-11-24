//
//  Utils.m
//  BuildAnywhere
//
//  Created by Viktor Sydorenko on 2/16/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "Utils.h"
#import "LangDefinition.h"
#import "SourceCodeDefinition.h"

@implementation Utils

+(NSString*) trimWhitespaces:(NSString*)string{
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

+(void)shareText:(NSString*)textToShare overViewController:(UIViewController*)viewController{
    NSArray *activityItems = @[textToShare];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    
    NSMutableArray *excludedTypes = [[NSMutableArray alloc] init];
    [excludedTypes addObject:UIActivityTypeAssignToContact];
    [excludedTypes addObject:UIActivityTypeSaveToCameraRoll];
    if (textToShare.length > 140){ // max Twitter and Weibo post lengths
        [excludedTypes addObject:UIActivityTypePostToTwitter];
        [excludedTypes addObject:UIActivityTypePostToWeibo];
    }
    if (textToShare.length > 300){ // max Message length (my decision)
        [excludedTypes addObject:UIActivityTypeMessage];
    }
    
    activityVC.excludedActivityTypes = [NSArray arrayWithArray:excludedTypes];
    [viewController presentViewController:activityVC animated:TRUE completion:nil];
}

+(NSString*)getShortDescriptionOfResultCode:(ResultCodes)code{
    switch (code) {
        case COMPILATION_ERROR:
            return @"Compilation error";
        case ILLEGAL_SYSTEM_CALL:
            return @"Illegal system call";
        case INTERNAL_ERROR:
            return @"Internal service error!";
        case MEMORY_LIMIT_EXCEEDED:
            return @"Memory limit exceeded";
        case NOT_RUNNING:
            return @"Success"; // should not happen
        case RUNTIME_ERROR:
            return @"Runtime error";
        case SUCCESS:
            return @"Success";
        case TIME_LIMIT_EXCEEDED:
            return @"Time limit exceeded";
        default:
            return @"Failure"; // should not happen
    }
}

+(NSString*)getSignalDescription:(int)signal{
    NSString *result = [NSString stringWithFormat:@"The program received the next signal code from the system: %d", signal];
    NSString *description = @"";
    switch (signal) {
        case 1:{
            description = @"The SIGHUP signal is sent to a process when its controlling terminal is closed. It was originally designed to notify the process of a serial line drop. In modern systems, this signal usually means that controlling pseudo or virtual terminal has been closed.";
            break;
        }
        case 2:{
            description = @"The SIGINT signal is sent to a process by its controlling terminal when a user wishes to interrupt the process. This is typically initiated by pressing Control-C, but on some systems, the \"delete\" character or \"break\" key can be used.";
            break;
        }
        case 3:{
            description = @"The SIGQUIT signal is sent to a process by its controlling terminal when the user requests that the process perform a core dump.";
            break;
        }
        case 4:{
            description = @"The SIGILL signal is sent to a process when it attempts to execute a malformed, unknown, or privileged instruction.";
            break;
        }
        case 6:{
            description = @"The SIGABRT signal is sent to a process to tell it to abort, i.e. to terminate. The signal can only be initiated by the process itself when it calls abort function of the C Standard Library.";
            break;
        }
        case 8:{
            description = @"The SIGFPE signal is sent to a process when it executes an erroneous arithmetic operation, such as division by zero.";
            break;
        }
        case 9:{
            description = @"The SIGKILL signal is sent to a process to cause it to terminate immediately. In contrast to SIGTERM and SIGINT, this signal cannot be caught or ignored, and the receiving process cannot perform any clean-up upon receiving this signal.";
            break;
        }
        case 11:{
            description = @"The SIGSEGV signal is sent to a process when it makes an invalid virtual memory reference, or segmentation fault, i.e. when it performs a segmentation violation.";
            break;
        }
        case 13:{
            description = @"The SIGPIPE signal is sent to a process when it attempts to write to a pipe without a process connected to the other end.";
            break;
        }
        case 14:{
            description = @"The SIGALRM, SIGVTALRM and SIGPROF signal is sent to a process when the time limit specified in a call to a preceding alarm setting function (such as setitimer) elapses. SIGALRM is sent when real or clock time elapses. SIGVTALRM is sent when CPU time used by the process elapses. SIGPROF is sent when CPU time used by the process and by the system on behalf of the process elapses.";
            break;
        }
        case 15:{
            description = @"The SIGTERM signal is sent to a process to request its termination. Unlike the SIGKILL signal, it can be caught and interpreted or ignored by the process. This allows the process to perform nice termination releasing resources and saving state if appropriate. It should be noted that SIGINT is nearly identical to SIGTERM.";
            break;
        }
        case 24:{
            description = @"The SIGXCPU signal is sent to a process when it has used up the CPU for a duration that exceeds a certain predetermined user-settable value. The arrival of a SIGXCPU signal provides the receiving process a chance to quickly save any intermediate results and to exit gracefully, before it is terminated by the operating system using the SIGKILL signal.";
            break;
        }
        case 25:{
            description = @"The SIGXFSZ signal is sent to a process when it grows a file larger than the maximum allowed size.";
            break;
        }
        default:{
            description = @"";
            break;
        }
    }
    if (description.length > 0){
        result = [result stringByAppendingFormat:@"\n%@", description];
    }
    
    return result;
}

+(NSString*)returnCaretIfNotEmpty:(NSString*)targetString returnNumbers:(int)returns{
    if (returns < 0 || returns > 100){ // even 10 will not be needed :)
        return targetString;
    }
    NSString* result = targetString;
    for (int i = 0; i < returns ; i++) {
        result = [result stringByAppendingString:@"\n"];
    }
    return result;
}

+(NSString*)codeTemplateForLanguage:(int)langId{
    switch (langId) {
        case LANG_ADA: return TEMPL_ADA;
        case LANG_ASM_GCC472: return TEMPL_ASM_GCC472;
        case LANG_ASM_NASM207: return TEMPL_ASM_NASM207;
        case LANG_AWK_GAWK: return TEMPL_AWK_GAWK;
        case LANG_AWK_MAWK: return TEMPL_AWK_MAWK;
        case LANG_BASH: return TEMPL_BASH;
        case LANG_BC: return TEMPL_BC;
        case LANG_BRAINFUCK: return TEMPL_BRAINFUCK;
        default:return @"";
    }
    return @"";
}

@end

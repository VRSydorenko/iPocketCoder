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
        case LANG_BC: return TEMPL_EMPTY_BC;
        case LANG_BRAINFUCK: return TEMPL_EMPTY_BRAINFUCK;
        case LANG_C: return TEMPL_C;
        case LANG_C99: return TEMPL_C99;
        case LANG_C_SHARP: return TEMPL_C_SHARP;
        case LANG_CLIPS: return TEMPL_CLIPS;
        case LANG_CLISP: return TEMPL_CLISP;
        case LANG_CLOJURE: return TEMPL_EMPTY_CLOJURE;
        case LANG_COBOL: return TEMPL_COBOL;
        case LANG_COBOL85: return TEMPL_COBOL85;
        case LANG_CPP_432: return TEMPL_CPP_432;
        case LANG_CPP_481: return TEMPL_CPP_481;
        case LANG_CPP11: return TEMPL_CPP11;
        case LANG_D_DMD: return TEMPL_EMPTY_D_DMD;
        case LANG_ERLANG: return TEMPL_ERLANG;
        case LANG_F_SHARP: return TEMPL_F_SHARP;
        case LANG_FACTOR: return TEMPL_FACTOR;
        case LANG_FALCON: return TEMPL_EMPTY_FALCON;
        case LANG_FORTH: return TEMPL_EMPTY_FORTH;
        case LANG_FORTRAN: return TEMPL_FORTRAN;
        case LANG_GO: return TEMPL_GO;
        case LANG_GROOVY: return TEMPL_EMPTY_GROOVY;
        case LANG_HASKELL: return TEMPL_HASKELL;
        case LANG_ICON: return TEMPL_ICON;
        case LANG_INTERCAL: return TEMPL_INTERCAL;
        case LANG_JAVA: return TEMPL_JAVA;
        case LANG_JAVA7: return TEMPL_JAVA7;
        case LANG_JAVASCRIPT_RHINO: return TEMPL_JAVASCRIPT_RHINO;
        case LANG_JAVASCRIPT_SPIDER: return TEMPL_EMPTY_JAVASCRIPT_SPIDER;
        case LANG_LUA: return TEMPL_EMPTY_LUA;
        case LANG_NEMERLE: return TEMPL_NEMERLE;
        case LANG_NICE: return TEMPL_NICE;
        case LANG_NIMROD: return TEMPL_EMPTY_NIMROD;
        case LANG_NODE_JS: return TEMPL_NODE_JS;
        case LANG_OBJ_C: return TEMPL_OBJ_C;
        case LANG_OCAML: return TEMPL_EMPTY_OCAML;
        case LANG_OCTAVE: return TEMPL_EMPTY_OCTAVE;
        case LANG_OZ: return TEMPL_OZ;
        case LANG_PARI_GP: return TEMPL_EMPTY_PARI_GP;
        case LANG_PASCAL_FPC: return TEMPL_PASCAL_FPC;
        case LANG_PASCAL_GPC: return TEMPL_PASCAL_GPC;
        case LANG_PERL: return TEMPL_PERL;
        case LANG_PERL_6: return TEMPL_PERL_6;
        case LANG_PHP: return TEMPL_PHP;
        case LANG_PIKE: return TEMPL_PIKE;
        case LANG_PROLOG_GNU: return TEMPL_PROLOG_GNU;
        case LANG_PROlOG_SWI: return TEMPL_PROlOG_SWI;
        case LANG_PYTHON: return TEMPL_EMPTY_PYTHON;
        case LANG_PYTHON3: return TEMPL_EMPTY_PYTHON3;
        case LANG_R: return TEMPL_EMPTY_R;
        case LANG_RUBY: return TEMPL_EMPTY_RUBY;
        case LANG_SCALA: return TEMPL_SCALA;
        case LANG_SCHEME: return TEMPL_EMPTY_SCHEME;
        case LANG_SMALLTALK: return TEMPL_EMPTY_SMALLTALK;
        case LANG_SQL: return TEMPL_EMPTY_SQL;
        case LANG_TCL: return TEMPL_EMPTY_TCL;
        case LANG_TEXT: return TEMPL_EMPTY_TEXT;
        case LANG_UNLAMBDA: return TEMPL_EMPTY_UNLAMBDA;
        case LANG_VB_NET: return TEMPL_VB_NET;
        case LANG_WHITESPACE: return TEMPL_EMPTY_WHITESPACE;
            
        default:return @"";
    }
    return @"";
}

+(NSString*)helloWorldForLanguage:(int)langId{
    switch (langId) {
        case LANG_ADA: return HW_ADA;
        case LANG_ASM_GCC472: return HW_ASM_GCC472;
        case LANG_ASM_NASM207: return HW_ASM_NASM207;
        case LANG_AWK_GAWK: return HW_AWK_GAWK;
        case LANG_AWK_MAWK: return HW_AWK_MAWK;
        case LANG_BASH: return HW_BASH;
        case LANG_BC: return HW_BC;
        case LANG_BRAINFUCK: return HW_BRAINFUCK;
        case LANG_C: return HW_C;
        case LANG_C99: return HW_C99;
        case LANG_C_SHARP: return HW_C_SHARP;
        case LANG_CLIPS: return HW_CLIPS;
        case LANG_CLISP: return HW_CLISP;
        case LANG_CLOJURE: return HW_CLOJURE;
        case LANG_COBOL: return HW_COBOL;
        case LANG_COBOL85: return HW_COBOL85;
        case LANG_CPP_432: return HW_CPP_432;
        case LANG_CPP_481: return HW_CPP_481;
        case LANG_CPP11: return HW_CPP11;
        case LANG_D_DMD: return HW_D_DMD;
        case LANG_ERLANG: return HW_ERLANG;
        case LANG_F_SHARP: return HW_F_SHARP;
        case LANG_FACTOR: return HW_FACTOR;
        case LANG_FALCON: return HW_FALCON;
        case LANG_FORTH: return HW_FORTH;
        case LANG_FORTRAN: return HW_FORTRAN;
        case LANG_GO: return HW_GO;
        case LANG_GROOVY: return HW_GROOVY;
        case LANG_HASKELL: return HW_HASKELL;
        case LANG_ICON: return HW_ICON;
        case LANG_INTERCAL: return HW_INTERCAL;
        case LANG_JAVA: return HW_JAVA;
        case LANG_JAVA7: return HW_JAVA7;
        case LANG_JAVASCRIPT_RHINO: return HW_JAVASCRIPT_RHINO;
        case LANG_JAVASCRIPT_SPIDER: return HW_JAVASCRIPT_SPIDER;
        case LANG_LUA: return HW_LUA;
        case LANG_NEMERLE: return HW_NEMERLE;
        case LANG_NICE: return HW_NICE;
        case LANG_NIMROD: return HW_NIMROD;
        case LANG_NODE_JS: return HW_NODE_JS;
        case LANG_OBJ_C: return HW_OBJ_C;
        case LANG_OCAML: return HW_OCAML;
        case LANG_OCTAVE: return HW_OCTAVE;
        case LANG_OZ: return HW_OZ;
        case LANG_PARI_GP: return HW_PARI_GP;
        case LANG_PASCAL_FPC: return HW_PASCAL_FPC;
        case LANG_PASCAL_GPC: return HW_PASCAL_GPC;
        case LANG_PERL: return HW_PERL;
        case LANG_PERL_6: return HW_PERL_6;
        case LANG_PHP: return HW_PHP;
        case LANG_PIKE: return HW_PIKE;
        case LANG_PROLOG_GNU: return HW_PROLOG_GNU;
        case LANG_PROlOG_SWI: return HW_PROlOG_SWI;
        case LANG_PYTHON: return HW_PYTHON;
        case LANG_PYTHON3: return HW_PYTHON3;
        case LANG_R: return HW_R;
        case LANG_RUBY: return HW_RUBY;
        case LANG_SCALA: return HW_SCALA;
        case LANG_SCHEME: return HW_SCHEME;
        case LANG_SMALLTALK: return HW_SMALLTALK;
        case LANG_SQL: return HW_SQL;
        case LANG_TCL: return HW_TCL;
        case LANG_TEXT: return HW_TEXT;
        case LANG_UNLAMBDA: return HW_UNLAMBDA;
        case LANG_VB_NET: return HW_VB_NET;
        case LANG_WHITESPACE: return HW_WHITESPACE;
            
        default:return @"";
    }
    return @"";
}

+(NSString*)make3digitsStringFromNumber:(int)number{
    return [NSString stringWithFormat:@"%03d", number];
}

@end

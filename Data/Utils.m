//
//  Utils.m
//  BuildAnywhere
//
//  Created by Viktor Sydorenko on 2/16/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import "Utils.h"

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

@end

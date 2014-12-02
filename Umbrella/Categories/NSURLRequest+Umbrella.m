//
//  NSURLRequest+Umbrella.m
//  Umbrella
//
//  Created by Jon Rexeisen on 8/16/13.
//  Copyright (c) 2013 The Nerdery. All rights reserved.
//

#import "NSURLRequest+Umbrella.h"

@implementation NSURLRequest (Umbrella)

+ (NSURLRequest *)nrd_weatherRequestForIcon:(NSString *)icon highlighted:(BOOL)highlighted
{
    NSString *formatString = @"http://nerdery-umbrella.s3.amazonaws.com/%@.png";
    if (highlighted) {
        formatString = @"http://nerdery-umbrella.s3.amazonaws.com/%@-selected.png";
    }
    
    NSURL *iconURL = [NSURL URLWithString:[NSString stringWithFormat:formatString, icon]];
    return [NSURLRequest requestWithURL:iconURL];
}


@end

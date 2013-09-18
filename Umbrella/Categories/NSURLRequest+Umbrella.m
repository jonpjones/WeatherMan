//
//  NSURLRequest+Umbrella.m
//  Umbrella
//
//  Created by Jon Rexeisen on 8/16/13.
//  Copyright (c) 2013 The Nerdery. All rights reserved.
//

#import "NSURLRequest+Umbrella.h"

@implementation NSURLRequest (Umbrella)

+ (NSURLRequest *)weatherRequestForIcon:(NSString *)icon
{
    NSURL *iconURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://dl.dropboxusercontent.com/u/2141923/umbrella/%@.png", icon]];
    return [NSURLRequest requestWithURL:iconURL];
}

@end

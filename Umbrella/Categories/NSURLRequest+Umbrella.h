//
//  NSURLRequest+Umbrella.h
//  Umbrella
//
//  Created by Jon Rexeisen on 8/16/13.
//  Copyright (c) 2013 The Nerdery. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLRequest (Umbrella)

/**
 Given a weather icon, like `clear`, generates a URLRequest pointing to the appropriate resource
 @param icon The icon to fetch
 @return Configured urlrequest
*/
+ (NSURLRequest *)weatherRequestForIcon:(NSString *)icon;

@end

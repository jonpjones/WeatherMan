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
 *  Given a weather icon, like @c clear, generates a URLRequest pointing to the appropriate resource
 *
 *  @param icon        The icon to fetch
 *  @param highlighted @c YES to get an filled in icon, appropriate for filling in
 *
 *  @return Configured urlrequest
 */
+ (NSURLRequest *)nrd_weatherRequestForIcon:(NSString *)icon highlighted:(BOOL)highlighted;


@end

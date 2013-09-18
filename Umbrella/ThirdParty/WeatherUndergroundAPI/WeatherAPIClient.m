//
//  LWAPIClient.m
//  Local Weather
//
//  Created by Jonathan Rexeisen on 7/23/12.
//  Copyright (c) 2012 The Nerdery. All rights reserved.
//

#import "WeatherAPIClient.h"

@interface WeatherAPIClient ()

- (NSError *)genericError;
- (NSError *)missingAPIKeyError;

@end

// Base URL
static NSString * const kWeatherAPIBaseURLString = @"http://api.wunderground.com/";
static NSString * const kWeatherAPIConditionsPath = @"/conditions/hourly";

// Custom error domain and codes
NSString * const kWeatherAPIClientErrorDomain = @"com.nerdery.weather";
NSInteger const kWeatherAPIClientErrorCodeGeneric = 1000;
NSInteger const kWeatherAPIClientErrorCodeNoAPIKey = 1001;

@implementation WeatherAPIClient

#pragma mark - Singleton creation

+ (WeatherAPIClient *)sharedClient
{
    // proper care of singletons - http://www.mikeash.com/pyblog/friday-qa-2009-10-02-care-and-feeding-of-singletons.html
    static WeatherAPIClient *_sharedClient = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedClient = [[WeatherAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kWeatherAPIBaseURLString]];
    });
    
    return _sharedClient;
}

#pragma mark - API calls

- (NSURLSessionDataTask *)getForecastAndConditionsForZipCode:(NSString *)zipCode withCompletionBlock:(WeatherAPICompletionBlock)completionBlock
{
    if (!self.APIKey) {
        NSAssert(NO, @"API Key not set", nil);
        completionBlock(NO, nil, [self missingAPIKeyError]);
        return nil;
    }
    
    if (![NSThread isMainThread]) {
        NSAssert(NO, @"API client method must be called on the main thread", nil);
        completionBlock(NO, nil, [self genericError]);
        return nil;
    }
    
    // Create the path
    NSString *pathString = [NSString stringWithFormat:@"/api/%@%@/q/%@.json", self.APIKey, kWeatherAPIConditionsPath, zipCode];
    
    // To avoid a retain cycle
    __weak __typeof(self)weakSelf = self;
    
    // Start the request
    
    return [self GET:pathString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        // Check the responseObject
        if (!responseObject || ![responseObject isKindOfClass:[NSDictionary class]] || [responseObject count] == 0) {
            DLog(@"Invalid responseObject: %@", responseObject);
            completionBlock(NO, nil, [weakSelf genericError]);
            return;
        }
        completionBlock(YES, responseObject, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        DLog(@"Error with getForcastForLocation response: %@", error);
        completionBlock(NO, nil, error);
    }];
}

#pragma mark - Errors

- (NSError *)genericError
{
    NSString *localizedParsingErrorDescription = NSLocalizedString(@"Unknown response from the Weather Underground server.", @"Generic failure error message");
    return [NSError errorWithDomain:kWeatherAPIClientErrorDomain
                               code:kWeatherAPIClientErrorCodeGeneric
                           userInfo:[NSDictionary dictionaryWithObject:localizedParsingErrorDescription forKey:NSLocalizedDescriptionKey]];
}
                        
- (NSError *)missingAPIKeyError
{
    NSString *localizedParsingErrorDescription = NSLocalizedString(@"Please enter a Weather Underground API Key.", @"Please enter a Weather Underground API Key error message");
    return [NSError errorWithDomain:kWeatherAPIClientErrorDomain
                               code:kWeatherAPIClientErrorCodeNoAPIKey
                           userInfo:[NSDictionary dictionaryWithObject:localizedParsingErrorDescription forKey:NSLocalizedDescriptionKey]];
}

@end

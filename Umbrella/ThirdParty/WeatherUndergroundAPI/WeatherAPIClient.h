//
//  WeatherAPIClient.h
//  Local Weather
//
//  Created by Jonathan Rexeisen on 7/23/12.
//  Copyright (c) 2012 The Nerdery. All rights reserved.
//

#import "AFHTTPSessionManager.h"

/**
 A block that will be called when the API request is complete.
 @param success YES if the request was successful
 @param error An NSError that occurred, if there was one (will only be present if the request was not successful)
 */
typedef void (^WeatherAPICompletionBlock)(BOOL success, NSDictionary *result, NSError *error);

// Custom error domain & codes
extern NSString * const kWeatherAPIClientErrorDomain;
extern NSInteger const kWeatherAPIClientErrorCodeGeneric;
extern NSInteger const kWeatherAPIClientErrorCodeNoAPIKey;

/**
 This class will call out to the Weather Client and fetch the appropriate data
 */
@interface WeatherAPIClient : AFHTTPSessionManager

/**
 Required for making calls to the weather underground API.
 */
@property (nonatomic, strong) NSString *APIKey;

#pragma mark - Singleton

/**
 Singleton for the WUnderground API.
 */
+ (WeatherAPIClient *)sharedClient;

#pragma mark - Fetchers

/**
 Gets the gets the forcast and conditions from the Weather Underground API and calls the completion block on success/failure. Must be called on main thread.
 @param zipCode the 5 digit zip code of the location to retrieve the weather
 @param completionBlock The completion block to be executed when the request has completed. The completion block will be called on the main thread.
 @return The task that was created for fetching the weather
 */
- (NSURLSessionDataTask *)getForecastAndConditionsForZipCode:(NSString *)zipCode withCompletionBlock:(WeatherAPICompletionBlock)completionBlock;

@end

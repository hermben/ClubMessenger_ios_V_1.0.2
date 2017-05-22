
//  WebServiceController.h
//  Gymnut
//
//  Created by Administrator on 05/03/16.
//  Copyright © 2016 Gymnut. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface WebServiceController : NSObject

#pragma mark - To get data using query string
+ (void)callURLString:(NSString *)URLString withQSRequest:(NSString *)queryString andMethod:(NSString *)method withSuccess:(void (^) (NSDictionary *responseDictionary))success failure:(void (^) (NSError *error))failure;

#pragma mark - To get data using query string
+ (void)callURLString:(NSString *)URLString withQueryStringRequest:(NSString *)queryString andMethod:(NSString *)method withSuccess:(void (^) (NSDictionary *responseDictionary))success failure:(void (^) (NSError *error))failure;

#pragma mark - To send plain text data
+ (void)callURLString:(NSString *)URLString withRequest:(NSDictionary *)requestDictionary andMethod:(NSString *)method withSuccess:(void (^) (NSDictionary *responseDictionary))success failure:(void (^) (NSError *error))failure;

#pragma mark - To send multipart data
+ (void)callURLString:(NSString *)URLString withRequest:(NSMutableDictionary *)requestDictionary withImage:(NSData *)imageData withImageName:(NSString *)imageName withImagePath:(NSURL *)imagePath andMethod:(NSString *)method withSuccess:(void (^)(NSDictionary *responseDictionary))success failure:(void (^)(NSError *error))failure;

# pragma mark Send multipart Data with Video
+ (void)callURLString:(NSString *)URLString withRequest:(NSMutableDictionary *)requestDictionary WithFileDictionary:(NSDictionary *)fileDictionary andMethod:(NSString *)method withSuccess:(void (^)(NSDictionary *responseDictionary))success failure:(void (^)(NSError *error))failure;

@end

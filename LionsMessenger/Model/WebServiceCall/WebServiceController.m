//  WebServiceController.h
//  Gymnut
//
//  Created by Administrator on 05/03/16.
//  Copyright © 2016 Gymnut. All rights reserved.
//

#import "WebServiceController.h"
#import "AFURLSessionManager.h"
#import "DataModel.h"
#import "QMConstants.h"

@implementation WebServiceController

#pragma mark - To get data using query string

+ (void)callURLString:(NSString *)URLString withQSRequest:(NSString *)queryString andMethod:(NSString *)method withSuccess:(void (^) (NSDictionary *responseDictionary))success failure:(void (^) (NSError *error))failure {
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:URLString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPMethod:@"POST"];
    NSLog(@"Request URL: %@", URLString);
    NSURLSessionDataTask  *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            failure(error);
            NSLog(@"Error: %@", error);
        } else {
            NSDictionary *dict = responseObject;
            success (dict);
            NSLog(@"Response: %@",responseObject);
        }
    }];
    
    [dataTask resume];
}


#pragma mark - To get data using query string

+ (void)callURLString:(NSString *)URLString withQueryStringRequest:(NSString *)queryString andMethod:(NSString *)method withSuccess:(void (^) (NSDictionary *responseDictionary))success failure:(void (^) (NSError *error))failure {

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:URLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSLog(@"Request URL: %@", URLString);
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            failure(error);
            NSLog(@"Error: %@", error);
        } else {
            NSDictionary *dict = responseObject;
            success (dict);
            NSLog(@"Response: %@",responseObject);
        }
    }];
    
    [dataTask resume];
}

#pragma mark - To send plain text data
+ (void)callURLString:(NSString *)URLString withRequest:(NSDictionary *)requestDictionary andMethod:(NSString *)method withSuccess:(void (^) (NSDictionary *responseDictionary))success failure:(void (^) (NSError *error))failure {

    //    NSLog(@"URL : %@", URLString);
    //    NSLog(@"Parameter : %@", requestDictionary);
    //
    //    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    //    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    //
    //    //NSURL *URL = [NSURL URLWithString:URLString];
    //
    //    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:method URLString:URLString parameters:requestDictionary error:nil];

    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:requestDictionary options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];

    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:URLString parameters:nil error:nil];
    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"URL : %@", URLString);
    NSLog(@"Parameter : %@", jsonString);


    NSURLSessionDataTask  *dataTask = [manager dataTaskWithRequest:req completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        if (error) {
            NSLog(@"Error: %@", error);
            failure(error);
        } else {
            NSLog(@"Response Object: %@", responseObject);
            NSDictionary *dict = responseObject;
            success (dict);
        }
    }];
    [dataTask resume];

}

#pragma mark - To send multipart data
+ (void)callURLString:(NSString *)URLString withRequest:(NSMutableDictionary *)requestDictionary withImage:(NSData *)imageData withImageName:(NSString *)imageName withImagePath:(NSURL *)imagePath andMethod:(NSString *)method withSuccess:(void (^)(NSDictionary *responseDictionary))success failure:(void (^)(NSError *error))failure {

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];

    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:method URLString:URLString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileURL:imagePath name:@"file" fileName:imageName mimeType:@"image/png" error:nil];
    } error:nil];

    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];

    NSLog(@"Request URL: %@", URLString);
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager uploadTaskWithStreamedRequest:request progress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            failure(error);
            NSLog(@"Error: %@", error);
        } else {
            NSDictionary *dict = responseObject;
            success (dict);
            NSLog(@"Response: %@",responseObject);
        }
    }];

    [uploadTask resume];
}

# pragma mark Send multipart Data with Video 
+ (void)callURLString:(NSString *)URLString withRequest:(NSMutableDictionary *)requestDictionary WithFileDictionary:(NSDictionary *)fileDictionary andMethod:(NSString *)method withSuccess:(void (^)(NSDictionary *responseDictionary))success failure:(void (^)(NSError *error))failure {
    
   __block NSData *data;
   __block NSString *jsonString;
    
    @autoreleasepool {
        NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:method URLString:URLString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            if ([[fileDictionary objectForKey:FILE_MIME_TYPE] isEqualToString:MIME_JPEG]) {
                [formData appendPartWithFileURL:[fileDictionary objectForKey:FILE_URL] name:@"file" fileName:[fileDictionary objectForKey:FILE_NAME] mimeType:MIME_JPEG error:nil];
            }
            
            if ([[fileDictionary objectForKey:FILE_MIME_TYPE] isEqualToString:MIME_JPG]) {
                [formData appendPartWithFileURL:[fileDictionary objectForKey:FILE_URL] name:@"file" fileName:[fileDictionary objectForKey:FILE_NAME] mimeType:MIME_JPG error:nil];
            }
            
            if ([[fileDictionary objectForKey:FILE_MIME_TYPE] isEqualToString:MIME_PNG]) {
                [formData appendPartWithFileURL:[fileDictionary objectForKey:FILE_URL] name:@"file" fileName:[fileDictionary objectForKey:FILE_NAME] mimeType:MIME_PNG error:nil];
            }
            
            if ([[fileDictionary objectForKey:FILE_MIME_TYPE] isEqualToString:MIME_MP4]) {
                [formData appendPartWithFileURL:[fileDictionary objectForKey:FILE_URL] name:@"file" fileName:[fileDictionary objectForKey:FILE_NAME] mimeType:MIME_MP4 error:nil];
            }
            
            if ([[fileDictionary objectForKey:FILE_MIME_TYPE] isEqualToString:MIME_MOV]) {
                [formData appendPartWithFileURL:[fileDictionary objectForKey:FILE_URL] name:@"file" fileName:[fileDictionary objectForKey:FILE_NAME] mimeType:MIME_MOV error:nil];
            }
        } error:nil];
         NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        
        NSLog(@"Request URL: %@", URLString);
        NSURLSessionUploadTask *uploadTask;
        
        uploadTask = [manager uploadTaskWithStreamedRequest:request progress:nil completionHandler:^(NSURLResponse *  _Nonnull response, id  _Nullable responseObject, NSError *  _Nullable error) {
            if (error) {
                @try {
                    data = [NSJSONSerialization dataWithJSONObject:error.userInfo options:0 error:&error];
                }
                @catch (NSException *exception) {
                    NSLog(@"Dictionary is not valid: %@, %@, %@", exception.name, exception.reason, exception.userInfo);
                }
                @finally {
                    jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                }
                NSLog(@"\nError: %@\n\n", jsonString);
                NSLog(@"\nError: %@\n\n", error);
                failure(error);
            }
            else {
                @try {
                    data = [NSJSONSerialization dataWithJSONObject:responseObject options:0 error:&error];
                }
                @catch (NSException *exception) {
                    NSLog(@"Dictionary is not valid: %@, %@, %@", exception.name, exception.reason, exception.userInfo);
                }
                @finally {
                    jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                }
                NSLog(@"\nResponse: %@\n\n", jsonString);
                NSDictionary *dict = responseObject;
                success (dict);
            }
        }];
        
        [uploadTask resume];
    }
}
@end

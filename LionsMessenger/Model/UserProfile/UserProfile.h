//
//  UserProfile.h
//  InstaMedic
//
//  Created by Administrator on 07/06/16.
//  Copyright © 2016 Defferenzsystem PVT.LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QMConstants.h"
#import "WebServiceController.h"

@interface UserProfile : NSObject

# pragma mark SendVerification Code

-(void)getAllGroupsWithSuccess:(void (^)(NSDictionary *))success
                       failure:(void (^)(NSError *))failure;

//Sub Groups
-(void)getAllSubGroupsWithSuccess:(NSString *)strGroupID
                      withSuccess:(void (^)(NSDictionary *))success
                          failure:(void (^)(NSError *))failure;

//RegisterUser
-(void)registerUserWithSuccess:(NSDictionary*)requestDictionary
                   withSuccess:(void (^)(NSDictionary *))success
                       failure:(void (^)(NSError *))failure;

//Update User
-(void)updateUserWithSuccess:(NSDictionary*)requestDictionary
                 withSuccess:(void (^)(NSDictionary *))success
                     failure:(void (^)(NSError *))failure;

//chack UserExist
-(void)getEmailPasswordByFbIdWithSuccess:(NSString *)strFBID
                             withSuccess:(void (^)(NSDictionary *))success
                                 failure:(void (^)(NSError *))failure;
//GET USER DETAIL
-(void)getUserProfileByIdWithSuccess:(NSString *)strUserID
                         withSuccess:(void (^)(NSDictionary *))success
                             failure:(void (^)(NSError *))failure;
//for get User by Group
-(void)getUserByGroupWithSuccess:(NSDictionary *)requestDictionary
                     withSuccess:(void (^)(NSDictionary *))success
                         failure:(void (^)(NSError *))failure;


//for get User by SubGroup
-(void)getUserBySubGroupWithSuccess:(NSDictionary *)requestDictionary
                        withSuccess:(void (^)(NSDictionary *))success
                            failure:(void (^)(NSError *))failure;

//for send Payment
-(void)sendPaymentWithSuccess:(NSDictionary *)requestDictionary
                  withSuccess:(void (^)(NSDictionary *))success
                      failure:(void (^)(NSError *))failure;

// Delete User Account 
-(void)deleteUSerByIdWithSuccess:(NSString *)strUserID
                     withSuccess:(void (^)(NSDictionary *))success
                         failure:(void (^)(NSError *))failure;

@end

//
//  UserProfile.m
//  InstaMedic
//
//  Created by Administrator on 07/06/16.
//  Copyright © 2016 Defferenzsystem PVT.LTD. All rights reserved.
//

#import "UserProfile.h"

@implementation UserProfile

# pragma mark SendVerification Code

-(void)getAllGroupsWithSuccess:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure
{
    [WebServiceController callURLString:API_URL_GET_ALLGROUPS withQueryStringRequest:nil andMethod:@"GET" withSuccess:^(NSDictionary *responseDictionary) {
     
       success (responseDictionary);
    
    } failure:failure];

}
//Sub Groups
-(void)getAllSubGroupsWithSuccess:(NSString *)strGroupID withSuccess:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure
{
    NSString *strURL = [[NSString stringWithFormat:@"%@/%@",API_URL_GET_SUBGROUPS,strGroupID]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [WebServiceController callURLString:strURL withQueryStringRequest:nil andMethod:@"GET" withSuccess:^(NSDictionary *responseDictionary) {
        
        success (responseDictionary);
        
    } failure:failure];
        
}

//RegisterUser
-(void)registerUserWithSuccess:(NSDictionary*)requestDictionary withSuccess:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure
{
    [WebServiceController callURLString:API_URL_RERISTRATION withRequest:requestDictionary andMethod:@"POST" withSuccess:^(NSDictionary *responseDictionary)
     {
         success (responseDictionary);
         
     } failure:failure];
    
}

//Update User
-(void)updateUserWithSuccess:(NSDictionary*)requestDictionary withSuccess:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure
{
    [WebServiceController callURLString:API_URL_UPDATE_USER withRequest:requestDictionary andMethod:@"POST" withSuccess:^(NSDictionary *responseDictionary)
     {
         success (responseDictionary);
         
     } failure:failure];
    
}

//FACEBOOK Registration
-(void)getEmailPasswordByFbIdWithSuccess:(NSString *)strFBID withSuccess:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure
{
    NSString *strURL = [[NSString stringWithFormat:@"%@/%@",API_URL_GET_EMAIL_BYFBID,strFBID]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [WebServiceController callURLString:strURL withQueryStringRequest:nil andMethod:@"GET" withSuccess:^(NSDictionary *responseDictionary) {
        
        success (responseDictionary);
        
    } failure:failure];
    
}

//GET USER DETAIL
-(void)getUserProfileByIdWithSuccess:(NSString *)strUserID withSuccess:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure
{
    
    NSString *strURL = [[NSString stringWithFormat:@"%@/%@",API_URL_GET_USERBY_ID,strUserID]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [WebServiceController callURLString:strURL withQueryStringRequest:nil andMethod:@"GET" withSuccess:^(NSDictionary *responseDictionary) {
        
        success (responseDictionary);
      
    } failure:failure];

    
}
//for get User by Group
-(void)getUserByGroupWithSuccess:(NSDictionary *)requestDictionary withSuccess:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure
{
    [WebServiceController callURLString:API_URL_GET_USER_BY_GROUP withRequest:requestDictionary andMethod:@"POST" withSuccess:^(NSDictionary *responseDictionary)
     {
         success (responseDictionary);
         
     } failure:failure];
}
//for get User by subGroup
-(void)getUserBySubGroupWithSuccess:(NSDictionary *)requestDictionary withSuccess:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure
{
    [WebServiceController callURLString:API_URL_GET_USER_BY_SUBGROUP withRequest:requestDictionary andMethod:@"POST" withSuccess:^(NSDictionary *responseDictionary)
     {
         success (responseDictionary);
         
     } failure:failure];
}

//for send Payment
-(void)sendPaymentWithSuccess:(NSDictionary *)requestDictionary withSuccess:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure
{
    [WebServiceController callURLString:API_URL_SEND_PAYMENT withRequest:requestDictionary andMethod:@"POST" withSuccess:^(NSDictionary *responseDictionary)
     {
         success (responseDictionary);
         
     } failure:failure];
}


// Delete User Account
-(void)deleteUSerByIdWithSuccess:(NSString *)strUserID withSuccess:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure
{
    NSString *strURL = [[NSString stringWithFormat:@"%@?id=%@",API_URL_DELETE_USER,strUserID]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [WebServiceController callURLString:strURL withQSRequest:nil andMethod:@"POST" withSuccess:^(NSDictionary *responseDictionary)
     {
         success (responseDictionary);

     } failure:failure];

}


@end

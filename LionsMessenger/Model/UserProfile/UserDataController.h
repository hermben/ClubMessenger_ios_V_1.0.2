//
//  UserDataController.h
//  InstaMedic
//
//  Created by Administrator on 07/06/16.
//  Copyright © 2016 Defferenzsystem PVT.LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDataController : NSObject

@property (nonatomic, strong) NSString          *strUserId;
@property (nonatomic, strong) NSString          *strFullName;
@property (nonatomic, strong) NSString          *strProfileImage;
@property (nonatomic, strong) NSString          *strPhoneNo;
@property (nonatomic, strong) NSString          *strEmail;
@property (nonatomic, strong) NSString          *strDOB;
@property (nonatomic, strong) NSString          *strLionsTitle;
@property (nonatomic, strong) NSString          *strPassword;
@property (nonatomic, strong) NSString          *strDistrict;
@property (nonatomic, strong) NSString          *strAchievement;
@property (nonatomic, strong) NSString          *strCareer;
@property (nonatomic, strong) NSString          *strCity;
@property (nonatomic, strong) NSString          *strState;
@property (nonatomic, strong) NSString          *strCountry;
@property (nonatomic, strong) NSString          *strGroupID;
@property (nonatomic, strong) NSString          *strGroupName;
@property (nonatomic, strong) NSString          *strSubGroupID;
@property (nonatomic, strong) NSString          *strSubGroupName;
@property (nonatomic, strong) NSString          *strQuickbloxUserID;
@property (nonatomic, strong) NSString          *strFbID;
@property (nonatomic, strong) NSString          *strBlobID;
@property (nonatomic, strong) NSString          *strIsEligible;
@property (nonatomic, strong) NSString          *strCreatedDate;
@property (nonatomic, strong) NSString          *strUpdatedDate;
@property (nonatomic, assign) BOOL              isBack;

- (id)initWithDictionary:(NSDictionary *)dictionary;

-(void)avoidNullValues;

@end

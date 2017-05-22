//
//  UserDataController.m
//  InstaMedic
//
//  Created by Administrator on 07/06/16.
//  Copyright © 2016 Defferenzsystem PVT.LTD. All rights reserved.
//

#import "UserDataController.h"
#import "DataModel.h"
@implementation UserDataController


- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [self init];
    
    if (self) {
        @try {
            
            self.strUserId           = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"UserID"]];
            self.strFullName         = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"Fullname"]];
            self.strEmail            = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"Email"]];
            self.strPassword         = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"Password"]];
            self.strProfileImage     = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"Picture"]];
            self.strPhoneNo          = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"Phone"]];
            self.strLionsTitle       = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"PresentTitle"]];
            self.strDistrict         = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"GroupMultiple"]];
            self.strAchievement      = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"Achivements"]];
            self.strDOB              = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"BirthDate"]];
            self.strCareer           = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"Career"]];
            self.strCity             = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"City"]];
            self.strState            = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"State"]];
            self.strCountry          = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"Country"]];
            self.strGroupID          = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"GroupID"]];
            self.strGroupName        = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"GroupName"]];
            self.strSubGroupID       = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"SubGroupID"]];
            self.strSubGroupName     = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"SubGroupName"]];
            self.strIsEligible       = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"IsEligible"]];
            self.strSubGroupID       = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"SubGroupID"]];
            self.strBlobID           = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"BlobID"]];
            self.strQuickbloxUserID  = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"QuickbloxUserID"]];
            self.strFbID             = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"FbID"]];
            self.strCreatedDate      = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"CreatedDate"]];
            self.strUpdatedDate      = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"UpdatedDate"]];
           
            
            [self avoidNullValues];
        }
        
        @catch (NSException *exception)
        {
            NSLog(@"Key Error: %@", exception);
        }
    }
    return self;
}


-(void)avoidNullValues
{
    if ([[DataModel sharedInstance]isNull:self.strUserId])
        self.strUserId = @"";
    
    if ([[DataModel sharedInstance]isNull:self.strFullName])
        self.strFullName = @"";
    
    if ([[DataModel sharedInstance]isNull:self.strProfileImage])
        self.strProfileImage = @"";
    
    if ([[DataModel sharedInstance]isNull:self.strPhoneNo])
        self.strPhoneNo = @"";
    
    if ([[DataModel sharedInstance]isNull:self.strDistrict])
        self.strDistrict = @"";
    
    if ([[DataModel sharedInstance]isNull:self.strDOB])
        self.strDOB = @"";
    
    if ([[DataModel sharedInstance]isNull:self.strPassword])
        self.strPassword = @"";
    
    if ([[DataModel sharedInstance]isNull:self.strLionsTitle])
        self.strLionsTitle = @"";

    if ([[DataModel sharedInstance]isNull:self.strCareer])
        self.strCareer = @"";
    
    if ([[DataModel sharedInstance]isNull:self.strAchievement])
        self.strAchievement = @"";
    
    if ([[DataModel sharedInstance]isNull:self.strCity])
        self.strCity = @"";
    
    if ([[DataModel sharedInstance]isNull:self.strState])
        self.strState = @"";
    
    if ([[DataModel sharedInstance]isNull:self.strCountry])
        self.strCountry = @"";
    
    if ([[DataModel sharedInstance]isNull:self.strGroupID])
        self.strGroupID = @"";
    
    if ([[DataModel sharedInstance]isNull:self.strGroupName])
        self.strGroupName = @"";
    
    if ([[DataModel sharedInstance]isNull:self.strSubGroupID])
    self.strSubGroupID = @"";
    
    if ([[DataModel sharedInstance]isNull:self.strSubGroupName])
    self.strSubGroupName = @"";
    
    if ([[DataModel sharedInstance]isNull:self.strQuickbloxUserID])
        self.strQuickbloxUserID = @"";
    
    if ([[DataModel sharedInstance]isNull:self.strFbID])
        self.strFbID = @"";
    
    if ([[DataModel sharedInstance]isNull:self.strBlobID])
        self.strBlobID = @"";

    if ([[DataModel sharedInstance]isNull:self.strIsEligible])
        self.strIsEligible = @"";
    
    if ([[DataModel sharedInstance]isNull:self.strCreatedDate])
        self.strCreatedDate = @"";
    
    if ([[DataModel sharedInstance]isNull:self.strUpdatedDate])
        self.strUpdatedDate = @"";
    
}

@end

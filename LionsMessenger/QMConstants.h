//
//  QMConstants.h
//  Q-municate
//
//  Created by Vitaliy Gorbachov on 3/19/16.
//  Copyright © 2016 Quickblox. All rights reserved.
//
#import <AVKit/AVKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import <SVProgressHUD.h>
#import "DataModel.h"
#import "QMCore.h"
#import "QMContent.h"
#import "QMTasks.h"
#import "UINavigationController+QMNotification.h"
#import "QMAppDelegate.h"
#import "KSToastView.h"

#ifndef QMConstants_h
#define QMConstants_h

#ifdef DEBUG

#define ILog(...) do { NSLog(@"%s %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:__VA_ARGS__]); } while(0)

#else

#define ILog(...) do { } while (0)

#endif
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define RGBColor(_RED_,_GREEN_,_BLUE_) [UIColor colorWithRed:_RED_/255.0 green:_GREEN_/255.0 blue:_BLUE_/255.0 alpha:1.0]


#define RGBCommanColor [UIColor colorWithRed:255/255.0 green:183/255.0 blue:15/255.0 alpha:1.0]
#define RGBCommanTitleColor [UIColor colorWithRed:0/255.0 green:114/255.0 blue:176/255.0 alpha:1.0]

#define CommanErrorMessage @"Something went wrong please try agin"
#define ConnectionError    @"Please connect the device with internet"

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#define APPDELEGATE ((QMAppDelegate *)[[UIApplication sharedApplication]delegate])

//for Video and Image Data
#define FILE_NAME                       @"com.lionsMessenger.filename"
#define FILE_MIME_TYPE                  @"com.lionsMessenger.mimetype"
#define FILE_URL                        @"com.lionsMessenger.fileurl"
#define FILE_DATA                       @"com.lionsMessenger.filedata"

#define FILE_ATTACHMENTMESSAGE_KEY      @"message"
#define FILE_ATTACHMENTMESSGE_IMAGE     @"image"
#define FILE_ATTACHMENTMESSGE_VIDEO     @"video"

#define MIME_JPG                        @"image/jpg"
#define MIME_JPEG                       @"image/jpeg"
#define MIME_PNG                        @"image/png"
#define MIME_MP4                        @"video/mp4"
#define MIME_MOV                        @"video/mov"
#define FOLDERGALLERY                   @"FOLDERGALLERY"

static const CGFloat KEYBOARD_ANIMATION_DURATION    = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION        = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION        = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT       = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT      = 162;

// stripe credentials

// client credentials
// for test account
//static NSString * const PUBLISHABLE_KEY = @"pk_test_d73Y0mxGxFlZ0zdPNXqDg4vk";
//static NSString * const SECRET_KEY = @"sk_test_eYDKiH97Bk0xE3KYX4BXHuws";

// client credentials
// for live account
//    static NSString * const PUBLISHABLE_KEY =@"pk_live_8O1WCscnDUs6ZFP69FYUMRtF";
//    static NSString * const SECRET_KEY = @"sk_live_OipD5bbc00Sr8U7qy5nN9SfZ";
//


//Server URL
//For Live Server                                     http://ec2-54-191-126-199.us-west-2.compute.amazonaws.com/
//#define SERVER_ZONE                                 @"http://ec2-34-210-19-215.us-west-2.compute.amazonaws.com/"
//#define USERSERVICE_RESOURCES                       @"api/QCommunication/"

#define SERVER_ZONE                                   @"http://ec2-35-165-57-110.us-west-2.compute.amazonaws.com/"
#define USERSERVICE_RESOURCES                         @"QCommunication/api/QCommunication/"

#define SERVER_ZONE                                   @"http://app.clubmessengers.org/"
#define USERSERVICE_RESOURCES                         @"api/QCommunication/"


//For UAT Server
//#define SERVER_ZONE                                 @"http://differenzuat.com/"
//#define USERSERVICE_RESOURCES                       @"qcommunication/api/QCommunication/"

//Services
#define API_URL_GET_ALLGROUPS                       SERVER_ZONE USERSERVICE_RESOURCES      @"GetGroups"
#define API_URL_GET_SUBGROUPS                       SERVER_ZONE USERSERVICE_RESOURCES      @"GetSubGroupsByGroup"
#define API_URL_RERISTRATION                        SERVER_ZONE USERSERVICE_RESOURCES      @"RegisterUser"
#define API_URL_UPDATE_USER                         SERVER_ZONE USERSERVICE_RESOURCES      @"UpdateUser"
#define API_URL_GET_EMAIL_BYFBID                    SERVER_ZONE USERSERVICE_RESOURCES      @"GetEmailPasswordByFbId"
#define API_URL_GET_USERBY_ID                       SERVER_ZONE USERSERVICE_RESOURCES      @"GetUsersByID"

#define API_URL_GET_USER_BY_GROUP                   SERVER_ZONE USERSERVICE_RESOURCES      @"GetUsersByGroup"
#define API_URL_GET_USER_BY_SUBGROUP                SERVER_ZONE USERSERVICE_RESOURCES      @"GetUsersBySubGroup"

#define API_URL_SEND_PAYMENT                        SERVER_ZONE USERSERVICE_RESOURCES      @"PaymentToApplicationAccount"
#define API_URL_DELETE_USER                         SERVER_ZONE USERSERVICE_RESOURCES      @"DeleteUser"


// storyboards
static NSString *const kQMMainStoryboard = @"Main";
static NSString *const kQMChatStoryboard = @"Chat";
static NSString *const kQMSettingsStoryboard = @"Settings";

static NSString *const kQMPushNotificationDialogIDKey = @"dialog_id";
static NSString *const kQMPushNotificationUserIDKey = @"user_id";

static NSString *const kQMDialogsUpdateNotificationMessage = @"Notification message";
static NSString *const kQMContactRequestNotificationMessage = @"Contact request";
static NSString *const kQMLocationNotificationMessage = @"Location";
static NSString *const kQMCallNotificationMessage = @"Call notification";

static const CGFloat kQMBaseAnimationDuration = 0.2f;
static const CGFloat kQMSlashAnimationDuration = 0.1f;
static const CGFloat kQMDefaultNotificationDismissTime = 2.0f;
static const CGFloat kQMShadowViewHeight = 0.5f;

static const CLLocationDegrees MKCoordinateSpanDefaultValue = 250;

#endif /* QMConstants_h */

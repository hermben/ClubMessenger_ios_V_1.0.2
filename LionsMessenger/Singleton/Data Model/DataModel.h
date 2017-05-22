//
//  DataModel.h
//  ClickLabor
//
//  Created by Dev on 18/05/15.
//  Copyright (c) 2015 Differenz system pvt ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UserDataController.h"

@interface DataModel : NSObject

@property (nonatomic, retain) NSString *strGroupName;

+ (instancetype)sharedInstance;

# pragma mark - Initialie Method

@property (strong,nonatomic)UserDataController *objUser;
-(BOOL)isInternetConnected;

- (NSString *)getDocumentDirectoryPath;

- (void)setIsUserLoggedIn:(BOOL)value;
- (BOOL)isUserLoggedIn;

- (void)setIsUserLoggedOut:(BOOL)value;
- (BOOL)isUserLoggedOut;

- (void)setIsExtendSearch:(BOOL)value;
- (BOOL)isExtendSearch;


- (void)setDeviceToken:(NSString *)DeviceToken;
- (NSString *)getDeviceToken;

- (void)setUserID:(NSString *)strUserID;
- (NSString *)getUserID;

- (void)setProfileData:(NSData *)profileData;
- (NSData *)getProfileData;

- (void)removeAllCredentials;


- (NSNumber *)dateToSecondConvert:(NSString *)string;
- (NSString *)timeFormatted:(NSUInteger)totalSeconds;

- (BOOL)isNull:(id)var;
# pragma mark - Input Validator method

- (BOOL)validateEmailWithString:(NSString *)string;
- (BOOL)validateWhiteSpaceWithString: (NSString *)string;
- (BOOL)validateSpecialCharactor:(NSString *)text;
- (BOOL)validateIntegerWithString:(NSString *)string;

# pragma mark - Handler TextField

- (UITextField *)createCustomTextField:(UITextField *)txtField withImageName:(NSString *)imageName;
- (void)setTextFieldPlaceHolderStringAttribute:(NSString *)placeHolder forTextField:(UITextField *)textfield;

# pragma mark - Image Handler
- (void)createFolder:(NSString *)strFolderName;

- (void)saveVideo:(NSData *)video withName:(NSString *)name;
- (NSString *)loadVideoWithName:(NSString *)name;

- (void)saveImage:(UIImage*)image withName:(NSString *)name;
- (void)saveOriginal:(UIImage *)image withName:(NSString *)name;

- (UIImage *)loadImagewithName:(NSString *)name;
- (UIImage *)loadOriginalImage:(NSString *)name;

- (NSString *)encodeInBase64String:(UIImage *)image;
- (UIImage *)decodeBase64StringToImage:(NSString *)string;

- (UIImage *)createThubnailImageForOriginalImage:(UIImage *)image withSize:(CGSize)size;

# pragma mark - SaveImage And Video File On ServerPath

- (NSDictionary *)getImageFileUrl:(UIImage *)image;
- (NSDictionary *)getVideoFileUrl:(NSString *)urlString;

# pragma mark - textViewHeight
- (CGFloat)heigthFromString:(NSString *)string withFont:(UIFont *)font width:(CGFloat)width;

# pragma mark - Emoji Handler

- (NSString *)convertEmojiCharacterWithString:(NSString *)string;
- (NSString *)convertStringToEmojiCharacter:(NSString *)string;

@end

//
//  DataModel.m
//  ClickLabor
//
//  Created by Dev on 18/05/15.
//  Copyright (c) 2015 Differenz system pvt ltd. All rights reserved.
//

#import "DataModel.h"
#import "QMConstants.h"
#import <Reachability.h>

static NSString *strLoggedIn            =       @"islogin";
static NSString *strLoggedOut           =       @"islogout";
static NSString *strIsExtendSearch      =       @"isExtendSearch";
static NSString *strUserProfileData     =       @"userProfileData";
static NSString *strUID                 =       @"userID";
static NSString *strDeviceToken         =       @"device_token";

@implementation DataModel

+ (instancetype)sharedInstance {
    
    static DataModel *dataModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataModel = [[self alloc]init];
    });
    
    return dataModel;
}
//#pragma mark chack internet method
-(BOOL)isInternetConnected{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        return false;
    } else {
        return true;
    }
}
# pragma mark - Initialez Method

- (NSString *)getDocumentDirectoryPath {
    
    // ger root directroy path
    
    NSArray *dirPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    // get path of document directory
    
    NSString *strDirPath = [dirPath objectAtIndex:0];
    
    return strDirPath;
}

- (void)setDeviceToken:(NSString *)DeviceToken
{
    
    [[NSUserDefaults standardUserDefaults]setObject:DeviceToken forKey:strDeviceToken];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (NSString *)getDeviceToken {
    
    NSString *strDeviceT = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:strDeviceToken]];
    
    return strDeviceT;
}
- (void)setUserID:(NSString *)strUserID
{
    
    [[NSUserDefaults standardUserDefaults]setObject:strUserID forKey:strUID];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (NSString *)getUserID
{
    NSString *strID = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:strUID]];
    
    return strID;
}

- (void)setIsUserLoggedIn:(BOOL)value {
    
    [[NSUserDefaults standardUserDefaults]setBool:value forKey:strLoggedIn];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (BOOL)isUserLoggedIn {
    
    BOOL returnValue = [[NSUserDefaults standardUserDefaults]boolForKey:strLoggedIn];
    
    return returnValue;
}
- (void)setIsUserLoggedOut:(BOOL)value {
    
    [[NSUserDefaults standardUserDefaults]setBool:value forKey:strLoggedOut];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (BOOL)isUserLoggedOut {
    
    BOOL returnValue = [[NSUserDefaults standardUserDefaults]boolForKey:strLoggedOut];
    
    return returnValue;
}


- (void)setIsExtendSearch:(BOOL)value
{
    [[NSUserDefaults standardUserDefaults]setBool:value forKey:strIsExtendSearch];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
- (BOOL)isExtendSearch
{
    BOOL returnValue = [[NSUserDefaults standardUserDefaults]boolForKey:strIsExtendSearch];
    
    return returnValue;
}

- (void)setProfileData:(NSData *)profileData{
    
    [[NSUserDefaults standardUserDefaults]setObject:profileData forKey:strUserProfileData];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
- (NSData *)getProfileData{
    
    NSData *str_proData = [[NSUserDefaults standardUserDefaults]objectForKey:strUserProfileData];
    
    return str_proData;
}


- (NSString *)getNumbersFromString:(NSString *)number {
    
    NSString * strippedNumber = [number stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [number length])];
    
    NSString *trimmedString = [strippedNumber substringFromIndex:MAX((int)[strippedNumber length] - 10, 0)];
    
    return trimmedString;
}

- (void)createFolderForUserProfile {
    
    NSString *doctumentDirectory = [self getDocumentDirectoryPath];
    
    NSString *dataPath = [doctumentDirectory stringByAppendingPathComponent:@"/ProfilePic"];
    
    NSError *error;
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
    
    NSLog(@"%@",dataPath);
}

- (BOOL)saveUserProfileForUserId:(NSString *)userid {
    
    return YES;
}

- (UIImage *)getUserProfilePicture {
    
    UIImage *image = nil;
    
    return image;
}

- (void)setRoundedView:(UIImageView *)roundedView toDiameter:(float)newSize {
    
    CGPoint saveCenter = roundedView.center;
    CGRect newFrame = CGRectMake(roundedView.frame.origin.x, roundedView.frame.origin.y, newSize, newSize);
    roundedView.frame = newFrame;
    roundedView.layer.cornerRadius = newSize / 2.0;
    roundedView.center = saveCenter;
}






# pragma mark - Remove All Data

- (void)removeAllCredentials
{
   
    [self setIsUserLoggedIn:NO];
    [self saveImage:nil withName:nil];
    [self setProfileData:nil];
    [self setIsExtendSearch:NO];
    [self setUserID:nil];
   
    
}

- (NSNumber *)dateToSecondConvert:(NSString *)string {
    
    NSArray *components = [string componentsSeparatedByString:@":"];
    
    NSInteger hours   = [[components objectAtIndex:0] integerValue];
    NSInteger minutes = [[components objectAtIndex:1] integerValue];
    NSInteger seconds = [[components objectAtIndex:2] integerValue];
    
    return [NSNumber numberWithInteger:(hours * 60 * 60) + (minutes * 60) + seconds];
}

- (NSString *)timeFormatted:(NSUInteger)totalSeconds {
    
    //    NSUInteger seconds = totalSeconds % 60;
    NSUInteger minutes = (totalSeconds / 60) % 60;
    NSUInteger hours = totalSeconds / 3600;
    
    return [NSString stringWithFormat:@"%02lu:%02lu",(unsigned long)hours, (unsigned long)minutes];
}
- (BOOL)isNull:(id)var {
    
    if ([var isKindOfClass:[NSString class]] == YES) {
        NSCharacterSet* whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString* trimmed = [var stringByTrimmingCharactersInSet:whitespace];
        
        if (trimmed == nil || [trimmed class] == [NSNull class] || [trimmed isEqualToString:@""] || [trimmed isEqualToString:@"(null)"] || [trimmed isEqualToString:@"<null>"]) {
            return true;
        }
        return false;
    }
    else if ([var isKindOfClass:[NSArray class]] == YES) {
        if ([var isKindOfClass:[NSNull class]] || var == nil || [var count] == 0) {
            return true;
        }
        else {
            return false;
        }
    }
    else if ([var isKindOfClass:[NSDictionary class]] == YES) {
        if ([var isKindOfClass:[NSNull class]] || var == nil || [var count] == 0) {
            return true;
        }
        else {
            return false;
        }
    }
    else if ([var isKindOfClass:[NSNull class]] == YES) {
        return true;
    }
    return true;
}
# pragma mark - Input Validator method

- (BOOL)validateEmailWithString:(NSString *)string {
    
    BOOL stricterFilter = false;
    
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:string];
}

- (BOOL)validateWhiteSpaceWithString:(NSString *)string
{
    
    BOOL returnValue = false;
    
    NSCharacterSet *charSet = [NSCharacterSet whitespaceCharacterSet];
    
    NSRange range = [string rangeOfCharacterFromSet:charSet];
    
    if (range.location == NSNotFound) {
        returnValue = true;
    }
    
    return returnValue;
}

- (BOOL)validateSpecialCharactor:(NSString *)text {
    
    NSString *Regex = @"[A-Za-z0-9 @ $ _ . # - ^]*";
    // NSString *Regex = @"[a-zA-Z0-9!@#$*_-.]*";
    NSPredicate *TestResult = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return [TestResult evaluateWithObject:text];
}

- (BOOL)validateIntegerWithString:(NSString *)string {
    
    BOOL returnValue = NO;
    
    NSCharacterSet *alphaNumbersSet = [NSCharacterSet decimalDigitCharacterSet];
    
    NSCharacterSet *stringSet = [NSCharacterSet characterSetWithCharactersInString:string];
    
    returnValue = [alphaNumbersSet isSupersetOfSet:stringSet];
    
    return returnValue;
}


# pragma mark - Handler TextField


- (UITextField *)createCustomTextField:(UITextField *)txtField withImageName:(NSString *)imageName {
    
    txtField.rightViewMode = UITextFieldViewModeAlways;
    txtField.leftViewMode = UITextFieldViewModeAlways;
    
    
    
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, 10.0, txtField.frame.size.height)];
    txtField.leftView = leftView;
    
    CGFloat widthInner = 0.0;
    
    if(!IS_IPAD)
        widthInner = 40.0;
    else
        widthInner = 50.0;
    
    UIImageView *imgView = [[UIImageView alloc]init];
    
    [imgView setFrame:CGRectMake(0.0, 0.0, widthInner, txtField.frame.size.height)];
    [imgView setContentMode:UIViewContentModeCenter];
    [imgView setBackgroundColor:UIColorFromRGB(0xcccccc)];
    //    [imgView.layer setBorderWidth:1.0];
    
    UIImage *img = [UIImage imageNamed:imageName];
    [imgView setImage:img];
    
    [txtField setRightView:imgView];
    
    return txtField;
}

- (void)setTextFieldPlaceHolderStringAttribute:(NSString *)placeHolder forTextField:(UITextField *)textfield {
    
    if ([textfield respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        
        UIColor *newColor = RGBColor(250.0, 147.0, 27.0);
        
        textfield.attributedPlaceholder = [[NSAttributedString alloc]
                                           initWithString:textfield.placeholder
                                           attributes:@{
                                                        NSForegroundColorAttributeName: newColor
                                                        }];
    }
    else {
        NSLog(@"Can Not Set");
    }
}

# pragma mark - Private method

- (UIImage *)imageResize :(UIImage*)img andResizeTo:(CGSize)newSize {
    
    CGFloat scale = [[UIScreen mainScreen]scale];
    
    /*You can remove the below comment if you dont want to scale the image in retina   device .Dont forget to comment UIGraphicsBeginImageContextWithOptions*/
    //UIGraphicsBeginImageContext(newSize);
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, scale);
    [img drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

# pragma mark - Image Handler

- (void)createFolder:(NSString *)strFolderName{
    
    NSString *doctumentDirectory = [self getDocumentDirectoryPath];
    
    NSString *dataPath = [doctumentDirectory stringByAppendingPathComponent:strFolderName];
    
    NSError *error;
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
    
    NSLog(@"%@",dataPath);
}

- (void)saveOriginal:(UIImage *)image withName:(NSString *)name {
    
    if (image != nil) {
        
        [self createFolder:@"/Original"];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString* path = [documentsDirectory stringByAppendingPathComponent:
                          [NSString stringWithFormat:@"/Original/%@.png",name]];
        NSData* data = UIImagePNGRepresentation(image);
        [data writeToFile:path atomically:YES];
    }
}

- (NSString *)loadVideoWithName:(NSString *)name {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:
                      [NSString stringWithFormat:@"%@.mp4",name]];
    
    
    return path;
}

- (void)saveVideo:(NSData *)video withName:(NSString *)name {
    
    if(video != nil) {
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString* path = [documentsDirectory stringByAppendingPathComponent:
                          [NSString stringWithFormat:@"%@.mp4",name]];
        
        [video writeToFile:path atomically:YES];
    }
}

- (void)moveVideoFromPath:(NSString *)videoPath withName:(NSString *)name {
    
    
}

- (void)removeImageWithName:(NSString *)name {
    
}

- (void)saveImage:(UIImage*)image withName:(NSString *)name {
    
    if (image != nil) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString* path = [documentsDirectory stringByAppendingPathComponent:
                          [NSString stringWithFormat:@"%@.png",name]];
        NSData* data = UIImagePNGRepresentation(image);
        [data writeToFile:path atomically:YES];
    }
}

- (UIImage *)loadOriginalImage:(NSString *)name {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:
                      [NSString stringWithFormat:@"/Original/%@.png",name]];
    UIImage* image = [UIImage imageWithContentsOfFile:path];
    
    return image;
}

- (UIImage *)loadImagewithName:(NSString *)name {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:
                      [NSString stringWithFormat:@"%@.png",name]];
    UIImage* image = [UIImage imageWithContentsOfFile:path];
    
    return image;
}

- (NSString *)encodeInBase64String:(UIImage *)image {
    
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

- (UIImage *)decodeBase64StringToImage:(NSString *)string {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:string options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}

- (UIImage *)createThubnailImageForOriginalImage:(UIImage *)image withSize:(CGSize)size {
    
    UIImage *originalImage = image;
    CGSize destinationSize = size;
    UIGraphicsBeginImageContext(destinationSize);
    [originalImage drawInRect:CGRectMake(0,0,destinationSize.width,destinationSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (BOOL)isBase64Data:(NSString *)input
{
    input=[[input componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] componentsJoinedByString:@""];
    if ([input length] % 4 == 0) {
        static NSCharacterSet *invertedBase64CharacterSet = nil;
        if (invertedBase64CharacterSet == nil) {
            invertedBase64CharacterSet = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/="]invertedSet];
        }
        return [input rangeOfCharacterFromSet:invertedBase64CharacterSet options:NSLiteralSearch].location == NSNotFound;
    }
    return NO;
}

# pragma mark - SaveImage And Video File On ServerPath
- (NSDictionary *)getImageFileUrl:(UIImage *)image {
    NSURL *finalURL;
    NSData *imageData = UIImagePNGRepresentation(image);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString * timestamp = [NSString stringWithFormat:@"%.f",[[NSDate date] timeIntervalSince1970]];
    NSString *imagePathProfile =[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"image%@.png", timestamp]];
    
    if (![imageData writeToFile:imagePathProfile atomically:NO])
    {
        NSLog(@"Failed to cache image data to disk");
        return nil;
    }
    else
    {
        finalURL = [NSURL fileURLWithPath:[imagePathProfile stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSLog(@"the cachedImagedPath is %@",finalURL);
        NSDictionary *dict = @{
                               FILE_NAME: timestamp,
                               FILE_MIME_TYPE : MIME_JPG,
                               FILE_URL : finalURL,
                               FILE_DATA : imageData,
                               FILE_ATTACHMENTMESSAGE_KEY: FILE_ATTACHMENTMESSGE_IMAGE
                               };
        return dict;
    }
}
- (NSDictionary *)getVideoFileUrl:(NSString *)urlString {
    NSURL *finalURL;
    
    NSData *videoData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString * timestamp = [NSString stringWithFormat:@"%.f",[[NSDate date] timeIntervalSince1970]];
    NSString *videoPathProfile = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"test1%@.mp4", timestamp]];
    
    if (![videoData writeToFile:videoPathProfile atomically:NO])
    {
        NSLog(@"Failed to cache video data to disk");
        return nil;
    }
    else
    {
        finalURL = [NSURL fileURLWithPath:[videoPathProfile stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSLog(@"the cachedImagedPath is %@",finalURL);
        NSDictionary *dict = @{
                               FILE_NAME: timestamp,
                               FILE_MIME_TYPE : MIME_MP4,
                               FILE_URL : finalURL,
                               FILE_DATA : videoData
                               };
        return dict;
    }
}

# pragma mark - textViewHeight

- (CGFloat)heigthFromString:(NSString *)string withFont:(UIFont *)font width:(CGFloat)width {
    
    NSString *strComment = string;
    
    CGSize textSize = { width - 50.0, CGFLOAT_MAX };
    CGFloat height = 5.0;
    
    CGRect rect = CGRectZero;
    rect = [strComment  boundingRectWithSize:textSize
                                     options:(NSStringDrawingUsesLineFragmentOrigin)
                                  attributes:@{NSFontAttributeName:font} context:nil];
    height += rect.size.height;
    
    return height;
}

# pragma mark - Emoji Handler

- (NSString *)convertEmojiCharacterWithString:(NSString *)string {
    
    NSData *data = [string dataUsingEncoding:NSNonLossyASCIIStringEncoding];
    NSString *strValue = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    return strValue;
}

- (NSString *)convertStringToEmojiCharacter:(NSString *)string
{
    
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSString *strValue = [[NSString alloc] initWithData:data encoding:NSNonLossyASCIIStringEncoding];
    return strValue;
}

@end

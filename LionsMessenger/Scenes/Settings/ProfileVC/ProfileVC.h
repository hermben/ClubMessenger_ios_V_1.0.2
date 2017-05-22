//
//  ProfileVC.h
//  LionsMessenger
//
//  Created by Administrator on 2/16/17.
//  Copyright © 2017 Quickblox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QMImagePicker.h"
#import <QMImageView.h>
#import <NYTPhotoViewer/NYTPhotosViewController.h>
#import "QMImagePreview.h"

@interface ProfileVC : UIViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem  *btnEdit;
@property (weak, nonatomic) IBOutlet UINavigationItem *NavigationTitle;
@property (weak, nonatomic) IBOutlet QMImageView *imageProfile;

@property (weak, nonatomic) IBOutlet UIScrollView *scroll_Main;

@property (weak, nonatomic) IBOutlet UITextField  *txtFullName;
@property (weak, nonatomic) IBOutlet UITextField  *txtPhoneNumber;
@property (weak, nonatomic) IBOutlet UIButton     *btnDOB;
@property (weak, nonatomic) IBOutlet UITextField  *txtLionsTitle;
@property (weak, nonatomic) IBOutlet UITextField  *txtDistrict;
@property (weak, nonatomic) IBOutlet UITextField  *txtAchivement;
@property (weak, nonatomic) IBOutlet UITextField  *txtCareer;
@property (weak, nonatomic) IBOutlet UITextField  *txtCity;
@property (weak, nonatomic) IBOutlet UITextField  *txtState;
@property (weak, nonatomic) IBOutlet UITextField  *txtCountry;
@property (weak, nonatomic) IBOutlet UIDatePicker *pickerDOB;

@property (weak, nonatomic) IBOutlet UIView       *viewDatePicker;

@property (weak, nonatomic) IBOutlet UIButton     *btnDistricts;
@property (weak, nonatomic) IBOutlet UIButton     *btnClubs;

@property (strong,nonatomic)NSString              *strDOB;
@property (assign,nonatomic)BOOL                  isClubs;
@property(strong,nonatomic) NSString              *strimgProfile;
@property(strong,nonatomic) NSString              *blobID;
@property(strong,nonatomic) NSString              *fbID;
@property(strong, nonatomic) NSString             *strEmailId;
@property(strong, nonatomic) NSString             *strPassword;
@property(strong, nonatomic) NSString             *strProfileImage;
@property(strong, nonatomic) NSString             *strGroupId;
@property(strong, nonatomic) NSString             *strSubGroupID;
@property(strong, nonatomic) NSString             *strUserID;
#pragma mark NSLayout Property
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintViewContenHeight;


- (IBAction)btnDateOfBirth_Click:(UIButton *)sender;
- (IBAction)btnEdit:(id)sender;
- (IBAction)btnDone_Click:(UIButton *)sender;
- (IBAction)btnDistricts_Click:(UIButton *)sender;
- (IBAction)btnClub_Click:(UIButton *)sender;

@end

//
//  SignupSetp1VC.h
//  LionsMessenger
//
//  Created by Administrator on 2/13/17.
//  Copyright © 2017 Quickblox. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "QMImagePicker.h"
#import <QMImageView.h>
#import <NYTPhotoViewer/NYTPhotosViewController.h>
#import "QMImagePreview.h"

@interface SignupSetp1VC : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *NavigationTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblProfilePicture;

@property (weak, nonatomic) IBOutlet QMImageView *imageProfile;

@property (weak, nonatomic) IBOutlet UITextField *txtFullName;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UILabel     *lblTermsandCounditions;
@property (weak, nonatomic) IBOutlet UIButton    *btnDistricts;
@property (weak, nonatomic) IBOutlet UIButton    *btnClubs;


@property (assign,nonatomic)BOOL                 isClubs;
@property(strong,nonatomic) NSString             *strimgProfile;
@property(strong,nonatomic) NSString             *blobID;
@property(strong,nonatomic) NSString             *fbID;

- (IBAction)btnBack_Click:(id)sender;
- (IBAction)btnNext_Click:(id)sender;

@end

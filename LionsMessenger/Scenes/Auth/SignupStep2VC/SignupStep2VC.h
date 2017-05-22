//
//  SignupStep2VC.h
//  LionsMessenger
//
//  Created by Administrator on 2/14/17.
//  Copyright © 2017 Quickblox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserDataController.h"

@interface SignupStep2VC : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *txtPhoneNo;
@property (weak, nonatomic) IBOutlet UIButton *btnDOB;
@property (weak, nonatomic) IBOutlet UITextField *txtLionsTitle;
@property (weak, nonatomic) IBOutlet UITextField *txtDistrict;
@property (weak, nonatomic) IBOutlet UITextField *txtAchivement;
@property (weak, nonatomic) IBOutlet UITextField *txtCareer;
@property (weak, nonatomic) IBOutlet UITextField *txtCity;
@property (weak, nonatomic) IBOutlet UITextField *txtState;
@property (weak, nonatomic) IBOutlet UITextField *txtCountry;
@property (weak, nonatomic) IBOutlet UIDatePicker *pickerDOB;
@property (weak, nonatomic) IBOutlet UIView *viewDatePicker;

@property (strong,nonatomic)NSString *strDOB;

@property(strong,nonatomic)UserDataController *objUser;

- (IBAction)btnBack:(UIButton *)sender;
- (IBAction)btnDone:(UIButton *)sender;
- (IBAction)btnDOB:(UIButton *)sender;


@property (weak, nonatomic) IBOutlet UIScrollView *scrollView_Main;


#pragma mark NSLayout Property
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintViewContentHeight;


@end

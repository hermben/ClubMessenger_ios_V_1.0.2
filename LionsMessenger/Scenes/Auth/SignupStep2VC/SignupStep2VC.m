//
//  SignupStep2VC.m
//  LionsMessenger
//
//  Created by Administrator on 2/14/17.
//  Copyright © 2017 Quickblox. All rights reserved.
//

#import "SignupStep2VC.h"
#import "QMConstants.h"
#import "UserProfile.h"

@interface SignupStep2VC ()

@end

@implementation SignupStep2VC

#pragma mark View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.viewDatePicker setHidden:YES];
    
    [self setNavigationLeftMenu];
    
    self.txtPhoneNo.placeholder = NSLocalizedString(@"auth_hint_phone", nil);
    [self.btnDOB setTitle:NSLocalizedString(@"auth_hint_dob", nil) forState:UIControlStateNormal];
    self.txtLionsTitle.placeholder = NSLocalizedString(@"auth_hint_present_title", nil);
    self.txtDistrict.placeholder = NSLocalizedString(@"auth_hint_group_multiple", nil);
    self.txtAchivement.placeholder = NSLocalizedString(@"auth_hint_achievement", nil);
    self.txtCareer.placeholder = NSLocalizedString(@"auth_hint_career", nil);
    self.txtCity.placeholder = NSLocalizedString(@"auth_hint_city", nil);
    self.txtState.placeholder = NSLocalizedString(@"auth_hint_state", nil);
    self.txtCountry.placeholder = NSLocalizedString(@"auth_hint_country", nil);

    self.strDOB = @"";
    
   }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Private Methods
-(void)setNavigationLeftMenu
{
    
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.title = NSLocalizedString(@"auth_sign_up_title", nil);
    [self.navigationController.navigationBar setBackgroundColor:RGBCommanColor];
    [self.navigationController.navigationBar setBarTintColor:RGBCommanColor];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor blackColor],
       NSFontAttributeName:[UIFont systemFontOfSize:17.0]}];
    
    UIButton *btnDone = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnDone setTitle:@"Done" forState:UIControlStateNormal];
    btnDone.titleLabel.font = [UIFont systemFontOfSize:17];
    [btnDone setTitleColor:RGBCommanTitleColor forState:UIControlStateNormal];
    btnDone.frame = CGRectMake(260, 22, 50, 40);
    [btnDone addTarget:self action:@selector(btnDone:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:btnDone];
    
    self.navigationItem.rightBarButtonItem = customBarItem;
}
- (void)showAlertMessageWithMessage:(NSString *)Title mesage:(NSString *)message
{
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:Title message:message preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *__unused action) {
            
        }];
        
        [alertVc addAction:actionCancel];
        
        [self presentViewController:alertVc animated:YES completion:nil];
    }
    else {
        
        UIAlertView *alerView = [[UIAlertView alloc]initWithTitle:Title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alerView show];
    }
}



# pragma mark - UITextField Delegate Method

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if([self.txtPhoneNo isFirstResponder])
        
        [self.txtLionsTitle becomeFirstResponder];
    
    else   if([self.txtLionsTitle isFirstResponder])
        
        [self.txtDistrict becomeFirstResponder];
    else   if([self.txtDistrict isFirstResponder])
        
        [self.txtAchivement becomeFirstResponder];
    else   if([self.txtAchivement isFirstResponder])
        
        [self.txtCareer becomeFirstResponder];
    else   if([self.txtCareer isFirstResponder])
        
        [self.txtCity becomeFirstResponder];
    else   if([self.txtCity isFirstResponder])
        
        [self.txtState becomeFirstResponder];
    else   if([self.txtState isFirstResponder])
        
        [self.txtCountry becomeFirstResponder];
    else
        [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    [self.viewDatePicker setHidden:true];
    
    CGPoint scrollPoint;
    if (textField == self.txtCareer)
    {
        scrollPoint = CGPointMake(0.0, 100);
    }
    else if(textField == self.txtCity)
    {
        scrollPoint = CGPointMake(0.0, 150);
        
    }
    else if(textField == self.txtState)
    {
        scrollPoint = CGPointMake(0.0, 200);
        
    }
    else if(textField == self.txtCountry) {
        scrollPoint = CGPointMake(0.0, 250);
        
    }
    else
    {
        scrollPoint = CGPointMake(0.0, 0.0);
    }
    [self.scrollView_Main setContentOffset:scrollPoint animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)__unused textField {
    
    [self.scrollView_Main setContentOffset:CGPointZero animated:YES];
    
}

-(void)KeybordClose
{
    [self.txtPhoneNo resignFirstResponder];
    [self.txtLionsTitle resignFirstResponder];
    [self.txtDistrict resignFirstResponder];
    [self.txtAchivement resignFirstResponder];
    [self.txtCareer resignFirstResponder];
    [self.txtCity resignFirstResponder];
    [self.txtState resignFirstResponder];
    [self.txtCountry resignFirstResponder];
    
}


#pragma mark IBAction Methods

- (IBAction)btnBack:(UIButton *)__unused sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnDone:(UIButton *)__unused sender {
    
    if (self.txtPhoneNo.text.length == 0 && self.txtDistrict.text.length == 0 && self.txtLionsTitle.text.length == 0
        && self.txtAchivement.text.length == 0 && self.txtCareer.text.length == 0 && self.txtCity.text.length == 0
        && self.txtState.text.length == 0 && self.txtCountry.text.length == 0) {
        
        [self performSegueWithIdentifier:kQMSceneSegueMain sender:nil];
    }
    else
    {
        //service call Update User
        if([DataModel sharedInstance].isInternetConnected)
            
            [self updateUser];
        
        else
            [self showAlertMessageWithMessage:@"Connection error" mesage:NSLocalizedString(@"QM_STR_LOST_INTERNET_CONNECTION", nil)];
    }
    
}

- (IBAction)btnDOB:(UIButton *)__unused sender {
    
    [self KeybordClose];
    self.pickerDOB.backgroundColor = [UIColor lightGrayColor];
    [self.viewDatePicker setHidden:false];
}

- (IBAction)btnDone_Click:(UIButton *)__unused sender {
    
    [self.viewDatePicker setHidden:true];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    
    NSDate *date = self.pickerDOB.date;
    dateFormatter.dateFormat = @"dd-MM-yyyy";
    [self.btnDOB setTitle:[dateFormatter stringFromDate:date] forState:UIControlStateNormal];
    [self.btnDOB setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = @"yyyy-MM-dd";
    self.strDOB = [dateFormat stringFromDate:date];
}
#pragma mark Service CAll
-(void)updateUser
{
    
    UserProfile *UP = [UserProfile new];
    
    
    NSDictionary *RequestDataDictionary = @{
                                            @"Fullname"       :self.objUser.strFullName,
                                            @"Email"          :self.objUser.strEmail,
                                            @"Password"       :self.objUser.strPassword,
                                            @"Picture"        :self.objUser.strProfileImage,
                                            @"BirthDate"      :self.strDOB,
                                            @"GroupMultiple"  :self.txtDistrict.text,
                                            @"PresentTitle"   :self.txtLionsTitle.text,
                                            @"Phone"          :self.txtPhoneNo.text,
                                            @"Achivements"    :self.txtAchivement.text,
                                            @"Career"         :self.txtCareer.text,
                                            @"City"           :self.txtCity.text,
                                            @"State"          :self.txtState.text,
                                            @"Country"        :self.txtCountry.text,
                                            @"GroupID"        :self.objUser.strGroupID,
                                            @"SubGroupID"     :self.objUser.strSubGroupID,
                                            @"BlobID"         :self.objUser.strBlobID,
                                            @"QuickbloxUserID":self.objUser.strQuickbloxUserID,
                                            @"FbID"           :APPDELEGATE.strFBID,
                                            };
    
    
    [UP updateUserWithSuccess:RequestDataDictionary withSuccess:^(NSDictionary *dictResult) {
        
        UserDataController *userOBJ = [[UserDataController alloc]initWithDictionary:dictResult];
        [[DataModel sharedInstance]setUserID:userOBJ.strUserId];
        APPDELEGATE.isIsEligible = [userOBJ.strIsEligible boolValue];
        APPDELEGATE.strGroupID   = userOBJ.strGroupID;
        [DataModel sharedInstance].objUser = userOBJ;
        
        NSData *userProfielData = [NSKeyedArchiver archivedDataWithRootObject:dictResult];
        [[DataModel sharedInstance]setProfileData:userProfielData];
        
        [self performSegueWithIdentifier:kQMSceneSegueMain sender:nil];
        
        [SVProgressHUD dismiss];
        
    } failure:^(NSError *__unused error) {
        
        [self showAlertMessageWithMessage:@"Error" mesage:CommanErrorMessage];
        [SVProgressHUD dismiss];
    }];
}
@end

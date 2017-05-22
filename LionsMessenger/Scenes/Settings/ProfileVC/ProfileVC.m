//
//  ProfileVC.m
//  LionsMessenger
//
//  Created by Administrator on 2/16/17.
//  Copyright © 2017 Quickblox. All rights reserved.
//

#import "ProfileVC.h"
#import "DataModel.h"
#import "UserDataController.h"
#import "UserProfile.h"
#import "GlobalSearchVC.h"

@interface ProfileVC ()<QMImageViewDelegate,QMImagePickerResultHandler,NYTPhotosViewControllerDelegate>
{
    
    UserDataController *userDC;
}
@end

@implementation ProfileVC

#pragma mark View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self Initialization];
    
    userDC = [UserDataController new];
    
    [self.btnClubs setTitle:NSLocalizedString(@"str_select_club", nil) forState:UIControlStateNormal];
    [self.btnDistricts setTitle:NSLocalizedString(@"str_select_district", nil) forState:UIControlStateNormal];
    self.txtFullName.placeholder = NSLocalizedString(@"auth_hint_full_name", nil);
    self.txtPhoneNumber.placeholder = NSLocalizedString(@"auth_hint_phone", nil);
    [self.btnDOB setTitle:NSLocalizedString(@"auth_hint_dob", nil) forState:UIControlStateNormal];
    self.txtLionsTitle.placeholder = NSLocalizedString(@"auth_hint_present_title", nil);
    self.txtDistrict.placeholder = NSLocalizedString(@"auth_hint_group_multiple", nil);
    self.txtAchivement.placeholder = NSLocalizedString(@"auth_hint_achievement", nil);
    self.txtCareer.placeholder = NSLocalizedString(@"auth_hint_career", nil);
    self.txtCity.placeholder = NSLocalizedString(@"auth_hint_city", nil);
    self.txtState.placeholder = NSLocalizedString(@"auth_hint_state", nil);
    self.txtCountry.placeholder = NSLocalizedString(@"auth_hint_country", nil);

    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if(userDC.isBack == true)
    {
        [self.btnDistricts setTitle:userDC.strGroupName forState:UIControlStateNormal];
        [self.btnClubs setTitle:NSLocalizedString(@"str_select_club", nil) forState:UIControlStateNormal];
        self.strGroupId  = userDC.strGroupID;
        if(self.isClubs == true)
        {
            self.strSubGroupID = userDC.strSubGroupID;
            [self.btnClubs setTitle:userDC.strSubGroupName forState:UIControlStateNormal];
        }
        userDC.isBack = false;
    }
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Privete Methods
-(void)Initialization
{
    [self profileEditable:false];
    self.NavigationTitle.title = NSLocalizedString(@"dialog_ctx_menu_profile", nil);
    [self.viewDatePicker setHidden:true];
    
    [self setNavigationLeftMenu];
    
    // [self.tabBarController.tabBar setHidden:YES];
    
    self.imageProfile.imageViewType = QMImageViewTypeCircle;
    self.imageProfile.delegate = self;
    self.imageProfile.layer.cornerRadius = self.imageProfile.frame.size.width/2;
    self.imageProfile.clipsToBounds = YES;
    
    
    //for update latest feed
    NSDictionary *userProfileDataDictionary = [NSKeyedUnarchiver unarchiveObjectWithData:[[DataModel sharedInstance]getProfileData]];
    if (userProfileDataDictionary != nil) {
        
        //load previous data
        [self bindProfileData:userProfileDataDictionary];
        
        //service call get User
        if([DataModel sharedInstance].isInternetConnected)
            
            [self getUserProfile];
        
        else
            [self showAlertMessageWithMessage:@"Connection error" mesage:NSLocalizedString(@"QM_STR_LOST_INTERNET_CONNECTION", nil)];
    }
    
}
-(void)setNavigationLeftMenu
{
    
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.title = NSLocalizedString(@"dialog_ctx_menu_profile", nil);
    [self.navigationController.navigationBar setBackgroundColor:RGBCommanColor];
    [self.navigationController.navigationBar setBarTintColor:RGBCommanColor];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor blackColor],
       NSFontAttributeName:[UIFont systemFontOfSize:17.0]}];
    
}

-(void)profileEditable:(BOOL)isEditable
{
    self.txtFullName.userInteractionEnabled    = isEditable;
    self.txtPhoneNumber.userInteractionEnabled = isEditable;
    self.txtDistrict.userInteractionEnabled    = isEditable;
    self.txtLionsTitle.userInteractionEnabled  = isEditable;
    self.txtAchivement.userInteractionEnabled  = isEditable;
    self.txtCareer.userInteractionEnabled      = isEditable;
    self.txtCity.userInteractionEnabled        = isEditable;
    self.txtState.userInteractionEnabled       = isEditable;
    self.txtCountry.userInteractionEnabled     = isEditable;
    self.btnDOB.userInteractionEnabled         = isEditable;
    self.imageProfile.userInteractionEnabled   = isEditable;
    self.btnDistricts.userInteractionEnabled   = isEditable;
    self.btnClubs.userInteractionEnabled       = isEditable;
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
    
    if([self.txtFullName isFirstResponder])
        
        [self.txtPhoneNumber becomeFirstResponder];
    
    else   if([self.txtPhoneNumber isFirstResponder])
        
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
    if (textField == self.txtPhoneNumber)
    {
        scrollPoint = CGPointMake(0.0, 50);
    }
    
    else if(textField == self.txtLionsTitle)
    {
        scrollPoint = CGPointMake(0.0, 110);
        
    }
    else if (textField == self.txtDistrict)
    {
        scrollPoint = CGPointMake(0.0, 180);
    }
    else if(textField == self.txtAchivement)
    {
        scrollPoint = CGPointMake(0.0, 240);
        
    }
    else if(textField == self.txtCareer) {
        scrollPoint = CGPointMake(0.0, 310);
        
    }
    else if(textField == self.txtCity) {
        scrollPoint = CGPointMake(0.0, 380);
        
    }
    else if(textField == self.txtState) {
        scrollPoint = CGPointMake(0.0, 430);
        
    }
    else if(textField == self.txtCountry) {
        scrollPoint = CGPointMake(0.0, 460);
        
    }
    else
    {
        scrollPoint = CGPointMake(0.0, 0.0);
    }
    
    // self.constraintViewContenHeight.constant = 770 + scrollPoint.y;
    
    [self.scroll_Main setContentOffset:scrollPoint animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)__unused textField {
    
    // self.constraintViewContenHeight.constant = 770;
    
    [self.scroll_Main setContentOffset:CGPointZero animated:YES];
    
}

-(void)KeybordClose
{
    [self.txtFullName resignFirstResponder];
    [self.txtPhoneNumber resignFirstResponder];
    [self.txtLionsTitle resignFirstResponder];
    [self.txtDistrict resignFirstResponder];
    [self.txtAchivement resignFirstResponder];
    [self.txtCareer resignFirstResponder];
    [self.txtCity resignFirstResponder];
    [self.txtState resignFirstResponder];
    [self.txtCountry resignFirstResponder];
    
}

#pragma mark - QMImageViewDelegate

- (void)imageViewDidTap:(QMImageView *)imageView {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"QM_STR_TAKE_IMAGE", nil)
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull __unused action) {
                                                          
                                                          [QMImagePicker takePhotoInViewController:self resultHandler:self];
                                                      }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"QM_STR_CHOOSE_IMAGE", nil)
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull __unused action) {
                                                          
                                                          [QMImagePicker choosePhotoInViewController:self resultHandler:self];
                                                      }]];
    
    
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"QM_STR_CANCEL", nil)
                                                        style:UIAlertActionStyleCancel
                                                      handler:nil]];
    
    if (alertController.popoverPresentationController) {
        // iPad support
        alertController.popoverPresentationController.sourceView = imageView;
        alertController.popoverPresentationController.sourceRect = imageView.bounds;
    }
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

#pragma mark - QMImagePickerResultHandler

- (void)imagePicker:(QMImagePicker *)__unused imagePicker didFinishPickingPhoto:(UIImage *)photo {
    
    if (![[QMCore instance] isInternetConnected]) {
        
        [self.navigationController showNotificationWithType:QMNotificationPanelTypeWarning message:NSLocalizedString(@"QM_STR_CHECK_INTERNET_CONNECTION", nil) duration:kQMDefaultNotificationDismissTime];
        return;
    }
    
    [self.navigationController showNotificationWithType:QMNotificationPanelTypeLoading message:NSLocalizedString(@"QM_STR_LOADING", nil) duration:0];
    
    __weak UINavigationController *navigationController = self.navigationController;
    
    @weakify(self);
    [[QMTasks taskUpdateCurrentUserImage:photo progress:nil] continueWithBlock:^id _Nullable(BFTask<QBUUser *> * _Nonnull task) {
        
        @strongify(self);
        
        [navigationController dismissNotificationPanel];
        
        if (!task.isFaulted) {
            
            [self.imageProfile setImage:photo withKey:task.result.avatarUrl];
        }
        
        return nil;
    }];
}

#pragma mark - NYTPhotosViewControllerDelegate

- (UIView *)photosViewController:(NYTPhotosViewController *)__unused photosViewController referenceViewForPhoto:(id<NYTPhoto>)__unused photo {
    
    return self.imageProfile;
}


#pragma mark IBAction Methods
- (IBAction)btnDateOfBirth_Click:(UIButton *)__unused sender {
    
    [self KeybordClose];
    self.pickerDOB.backgroundColor = [UIColor lightGrayColor];
    [self.viewDatePicker setHidden:false];
    
}

- (IBAction)btnEdit:(id)__unused sender {
    
    [self KeybordClose];
    if([self.btnEdit.title isEqualToString:@"Edit"])
    {
        self.btnEdit.title = @"Save";
        self.NavigationTitle.title = @"Edit Profile";
        [self profileEditable:true];
    }
    else
    {
        
        if([self.btnDistricts.titleLabel.text isEqualToString:@"SELECT DISTRICT"] || self.btnDistricts.titleLabel.text.length == 0)
        {
            [self.navigationController showNotificationWithType:QMNotificationPanelTypeWarning message:NSLocalizedString(@"QM_STR_GROUPS", nil) duration:kQMDefaultNotificationDismissTime];
        }
        else  if([self.btnClubs.titleLabel.text isEqualToString:@"SELECT CLUB"] || self.btnClubs.titleLabel.text.length == 0)
        {
            [self.navigationController showNotificationWithType:QMNotificationPanelTypeWarning message:NSLocalizedString(@"QM_STR_SUB_GROUPS", nil) duration:kQMDefaultNotificationDismissTime];
        }
        else  if(self.txtFullName.text.length == 0)
        {
            [self.navigationController showNotificationWithType:QMNotificationPanelTypeWarning message:NSLocalizedString(@"QM_STR_FULLNAME", nil) duration:kQMDefaultNotificationDismissTime];
        }
        else
        {
            
            self.btnEdit.title = @"Edit";
            self.NavigationTitle.title = NSLocalizedString(@"dialog_ctx_menu_profile", nil);
            [self profileEditable:false];
            
            //service call Update User
            if([DataModel sharedInstance].isInternetConnected)
                
                [self updateUser];
            
            else
                [self showAlertMessageWithMessage:@"Connection error" mesage:NSLocalizedString(@"QM_STR_LOST_INTERNET_CONNECTION", nil)];        }
    }
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

- (IBAction)btnDistricts_Click:(UIButton *)__unused sender {
    
    self.isClubs = false;
    GlobalSearchVC *gsVC=(GlobalSearchVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"GlobalSearchID"];
    gsVC.isClubs = false;
    gsVC.isFromSignUp = true;
    gsVC.userOBJ = userDC;
    [self.navigationController pushViewController:gsVC animated:YES];
}

- (IBAction)btnClub_Click:(UIButton *)__unused sender {
    
    self.isClubs = true;
    GlobalSearchVC *gsVC=(GlobalSearchVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"GlobalSearchID"];
    gsVC.userOBJ = userDC;
    gsVC.isClubs = true;
    gsVC.isFromSignUp = true;
    [self.navigationController pushViewController:gsVC animated:YES];
    
}

#pragma mark Service Call
-(void)updateUser
{
    [SVProgressHUD show];
    UserProfile *UP = [UserProfile new];
    
    NSString *strQBUserId  = [NSString stringWithFormat:@"%lu",[QMCore instance].currentProfile.userData.ID];
    
    NSDictionary *RequestDataDictionary = @{
                                            @"Fullname"       :self.txtFullName.text,
                                            @"Email"          :self.strEmailId,
                                            @"Password"       :self.strPassword,
                                            @"Picture"        :self.strProfileImage,
                                            @"BirthDate"      :self.strDOB,
                                            @"GroupMultiple"  :self.txtDistrict.text,
                                            @"PresentTitle"   :self.txtLionsTitle.text,
                                            @"Phone"          :self.txtPhoneNumber.text,
                                            @"Achivements"    :self.txtAchivement.text,
                                            @"Career"         :self.txtCareer.text,
                                            @"City"           :self.txtCity.text,
                                            @"State"          :self.txtState.text,
                                            @"Country"        :self.txtCountry.text,
                                            @"GroupID"        :self.strGroupId,
                                            @"SubGroupID"     :self.strSubGroupID,
                                            @"BlobID"         :self.blobID,
                                            @"QuickbloxUserID":strQBUserId,
                                            @"FbID"           :APPDELEGATE.strFBID,
                                            };
    
    
    [UP updateUserWithSuccess:RequestDataDictionary withSuccess:^(NSDictionary *dictResult) {
        
        
        //[DataModel sharedInstance].objUser = [[UserDataController alloc]initWithDictionary:dictResult];
        
        NSData *userProfielData = [NSKeyedArchiver archivedDataWithRootObject:dictResult];
        [[DataModel sharedInstance]setProfileData:userProfielData];
        
        [self bindProfileData:dictResult];
        
        [SVProgressHUD dismiss];
        
    } failure:^(NSError *__unused error) {
        
        [self showAlertMessageWithMessage:@"Error" mesage:CommanErrorMessage];
        [SVProgressHUD dismiss];
    }];
}

-(void)getUserProfile
{
    UserProfile *UP = [UserProfile new];
    [self.navigationController showNotificationWithType:QMNotificationPanelTypeLoading message:NSLocalizedString(@"QM_STR_LOADING", nil) duration:0];
    
    __weak UINavigationController *navigationController = self.navigationController;
    
    NSString *strQBUserId  = [NSString stringWithFormat:@"%lu",[QMCore instance].currentProfile.userData.ID];
    
    [UP getUserProfileByIdWithSuccess:strQBUserId withSuccess:^(NSDictionary *dictResult) {
        
        [navigationController dismissNotificationPanel];
        
        NSData *userProfielData = [NSKeyedArchiver archivedDataWithRootObject:dictResult];
        [[DataModel sharedInstance]setProfileData:userProfielData];
        
        [self bindProfileData:dictResult];
        
    } failure:^(NSError *__unused error) {
        
        [navigationController dismissNotificationPanel];
        
    }];
    
    
}
-(void)bindProfileData:(NSDictionary *)dictData
{
    UserDataController *UDC     = [[UserDataController alloc]initWithDictionary:dictData];
    self.txtFullName.text       = UDC.strFullName;
    self.txtPhoneNumber.text    = UDC.strPhoneNo;
    self.txtDistrict.text       = UDC.strDistrict;
    self.txtLionsTitle.text     = UDC.strLionsTitle;
    self.txtAchivement.text     = UDC.strAchievement;
    self.txtCareer.text         = UDC.strCareer;
    self.txtCity.text           = UDC.strCity;
    self.txtState.text          = UDC.strState;
    self.txtCountry.text        = UDC.strCountry;
    self.strEmailId             = UDC.strEmail;
    self.strPassword            = UDC.strPassword;
    self.strProfileImage        = UDC.strProfileImage;
    self.strGroupId             = UDC.strGroupID;
    self.strSubGroupID          = UDC.strSubGroupID;
    self.strDOB                 = UDC.strDOB;
    self.blobID                 = UDC.strBlobID;
    self.strUserID              = UDC.strUserId;
    [[DataModel sharedInstance]setUserID:self.strUserID];
    [self.btnDOB setTitle:UDC.strDOB forState:UIControlStateNormal];
    [self.btnDistricts setTitle:UDC.strGroupName forState:UIControlStateNormal];
    [self.btnClubs setTitle:UDC.strSubGroupName forState:UIControlStateNormal];
    [self.imageProfile setImageWithURL:[NSURL URLWithString:UDC.strProfileImage]
                           placeholder:[UIImage imageNamed:@"upic_avatarholder"]
                               options:SDWebImageHighPriority
                              progress:nil
                        completedBlock:nil];
    
    APPDELEGATE.strFBID      = UDC.strFbID;
    APPDELEGATE.strGroupID   = UDC.strGroupID;
    APPDELEGATE.isIsEligible = [UDC.strIsEligible boolValue];
   
    if(self.strDOB != nil)
    {
        [self.btnDOB setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}
@end

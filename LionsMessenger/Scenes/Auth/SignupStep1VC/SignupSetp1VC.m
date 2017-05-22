//
//  SignupSetp1VC.m
//  LionsMessenger
//
//  Created by Administrator on 2/13/17.
//  Copyright © 2017 Quickblox. All rights reserved.
//

#import "SignupSetp1VC.h"
#import "GlobalSearchVC.h"
#import "SignupStep2VC.h"
#import "UserProfile.h"
#import "QMConstants.h"
#import "UserDataController.h"
#import "QMLicenseAgreementViewController.h"


#import "QMCore.h"
#import "QMContent.h"
#import "QMTasks.h"
#import "UINavigationController+QMNotification.h"

@interface SignupSetp1VC ()<QMImageViewDelegate,QMImagePickerResultHandler,NYTPhotosViewControllerDelegate>
{
    UserDataController *UDC;
    
}

@end

@implementation SignupSetp1VC

#pragma mark View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self Initialization];
    
    UDC = [UserDataController new];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self setNavigationLeftMenu];
    
    
    if(UDC.isBack == true)
    {
        [self.btnDistricts setTitle:UDC.strGroupName forState:UIControlStateNormal];
        [self.btnClubs setTitle:NSLocalizedString(@"str_select_club", nil) forState:UIControlStateNormal];
        if(self.isClubs == true)
        {
            [self.btnClubs setTitle:UDC.strSubGroupName forState:UIControlStateNormal];
        }
        UDC.isBack = false;
    }
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if([self.btnDistricts.titleLabel.text isEqualToString:NSLocalizedString(@"str_select_district", nil)])
    {
        self.btnClubs.userInteractionEnabled = false;
    }
    else
    {
        self.btnClubs.userInteractionEnabled = true;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Privete Methods
-(void)Initialization
{
    
    self.imageProfile.imageViewType = QMImageViewTypeCircle;
    self.imageProfile.delegate = self;
    self.imageProfile.layer.cornerRadius = self.imageProfile.frame.size.width/2;
    self.imageProfile.clipsToBounds = YES;
    
    [self.btnClubs setTitle:NSLocalizedString(@"str_select_club", nil) forState:UIControlStateNormal];
    [self.btnDistricts setTitle:NSLocalizedString(@"str_select_district", nil) forState:UIControlStateNormal];
    self.lblProfilePicture.text = NSLocalizedString(@"auth_select_user_picture", nil);
    self.txtFullName.placeholder = NSLocalizedString(@"auth_hint_full_name", nil);
    self.txtEmail.placeholder = NSLocalizedString(@"auth_hint_email", nil);
    self.txtPassword.placeholder = NSLocalizedString(@"auth_hint_password", nil);
    self.lblTermsandCounditions.text  = NSLocalizedString(@"user_agreement_label", nil);
    //    self.imageProfile.userInteractionEnabled  = YES;
    //    UITapGestureRecognizer *UserProfilePicture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ProfileGestureMethod:)];
    //    [self.imageProfile addGestureRecognizer:UserProfilePicture];
    
    self.lblTermsandCounditions.userInteractionEnabled  = YES;
    UITapGestureRecognizer *tearmsANDservice = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tearmsGestureMethod:)];
    [self.lblTermsandCounditions addGestureRecognizer:tearmsANDservice];
}

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
    [btnDone addTarget:self action:@selector(btnNext_Click:) forControlEvents:UIControlEventTouchUpInside];
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
    
    if([self.txtFullName isFirstResponder])
        
        [self.txtEmail becomeFirstResponder];
    
    else   if([self.txtEmail isFirstResponder])
        
        [self.txtPassword becomeFirstResponder];
    
    else
        [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)__unused textField {
    
    
}

- (void)textFieldDidEndEditing:(UITextField *)__unused textField {
    
    
}

-(void)keyBordClose
{
    [self.txtFullName resignFirstResponder];
    [self.txtEmail resignFirstResponder];
    [self.txtPassword resignFirstResponder];
}
#pragma mark IBAction Methods


- (IBAction)btnBack_Click:(id)__unused sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnNext_Click:(id)__unused sender {
    
    [self keyBordClose];
    if (self.txtEmail.text.length == 0 || self.txtPassword.text.length == 0 || self.txtFullName.text.length ==0) {
        
        [self.navigationController showNotificationWithType:QMNotificationPanelTypeWarning message:NSLocalizedString(@"QM_STR_FILL_IN_ALL_THE_FIELDS", nil) duration:kQMDefaultNotificationDismissTime];
    }
    else if (![[DataModel sharedInstance] validateEmailWithString:self.txtEmail.text]){
        
        [self.navigationController showNotificationWithType:QMNotificationPanelTypeWarning message:NSLocalizedString(@"QM_STR_VERIFY_EMAIL", nil) duration:kQMDefaultNotificationDismissTime];
        
    }
    else if (self.txtPassword.text.length < 8 || self.txtPassword.text.length > 40 )
    {
        [self.navigationController showNotificationWithType:QMNotificationPanelTypeWarning message:NSLocalizedString(@"QM_STR_PASSWORD_LENGTH", nil) duration:kQMDefaultNotificationDismissTime];
    }
    else  if([self.btnDistricts.titleLabel.text isEqualToString:NSLocalizedString(@"str_select_district", nil)] || self.btnDistricts.titleLabel.text.length == 0)
    {
        [self.navigationController showNotificationWithType:QMNotificationPanelTypeWarning message:NSLocalizedString(@"QM_STR_GROUPS", nil) duration:kQMDefaultNotificationDismissTime];
    }
    else  if([self.btnClubs.titleLabel.text isEqualToString:NSLocalizedString(@"str_select_club", nil)] || self.btnClubs.titleLabel.text.length == 0)
    {
        [self.navigationController showNotificationWithType:QMNotificationPanelTypeWarning message:NSLocalizedString(@"QM_STR_SUB_GROUPS", nil) duration:kQMDefaultNotificationDismissTime];
    }
    else {
        
        [self createQBUser];
        
    }
    
}

- (IBAction)btnSelectDistriction:(id)__unused sender {
    
    [self keyBordClose];
    
    self.isClubs = false;
    GlobalSearchVC *gsVC=(GlobalSearchVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"GlobalSearchID"];
    gsVC.isClubs = false;
    gsVC.isFromSignUp = true;
    gsVC.userOBJ = UDC;
    [self.navigationController pushViewController:gsVC animated:YES];
}

- (IBAction)btnSelectClub_Click:(id)__unused sender {
    
    [self keyBordClose];
    
    self.isClubs = true;
    GlobalSearchVC *gsVC=(GlobalSearchVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"GlobalSearchID"];
    gsVC.userOBJ = UDC;
    APPDELEGATE.strGroupID = UDC.strGroupID;
    gsVC.isClubs = true;
    gsVC.isFromSignUp = true;
    [self.navigationController pushViewController:gsVC animated:YES];
}


#pragma mark - Tap GestureRecognizer Methods
-(void)tearmsGestureMethod:(UIGestureRecognizer *)__unused sender
{
    QMLicenseAgreementViewController *QMLAVC = (QMLicenseAgreementViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"QMLicenceAgreementControllerID"];
    [self.navigationController pushViewController:QMLAVC animated:YES];
    
    
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
    
    self.imageProfile.image = photo;
    
}

#pragma mark - NYTPhotosViewControllerDelegate

- (UIView *)photosViewController:(NYTPhotosViewController *)__unused photosViewController referenceViewForPhoto:(id<NYTPhoto>)__unused photo {
    
    return self.imageProfile;
}
#pragma mark Quickblox CAll
-(void)createQBUser
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    
    QBUUser *user = [QBUUser user];
    user.email    = self.txtEmail.text;
    user.fullName = self.txtFullName.text;
    user.password = self.txtPassword.text;
    [user.tags addObject: @"iOS"];
    
    [self.navigationController showNotificationWithType:QMNotificationPanelTypeLoading message:NSLocalizedString(@"QM_STR_SIGNING_IN", nil) duration:0];
    
    __weak UINavigationController *navigationController = self.navigationController;
    
    @weakify(self);
    
    [[QMCore instance].authService signUpAndLoginWithUser:user completion:^(QBResponse * _Nonnull response, QBUUser * _Nullable userProfile) {
        
        @strongify(self);
        [navigationController dismissNotificationPanel];
        
        if (response.status == QBResponseStatusCodeAccepted) {
            
            
            [QMCore instance].currentProfile.accountType = QMAccountTypeEmail;
            [[QMCore instance].currentProfile synchronizeWithUserData:userProfile];
            
            [[QMCore instance].pushNotificationManager subscribeForPushNotifications];
            
            [self uploadQBImage];
            
        }
        else
        {
            NSLog(@"%@",@"test");
        }
        
        
    }];
    
    
    
}
-(void)uploadQBImage
{
    
    if (![[QMCore instance] isInternetConnected]) {
        
        [self.navigationController showNotificationWithType:QMNotificationPanelTypeWarning message:NSLocalizedString(@"QM_STR_CHECK_INTERNET_CONNECTION", nil) duration:kQMDefaultNotificationDismissTime];
        return;
    }
    
    [self.navigationController showNotificationWithType:QMNotificationPanelTypeLoading message:NSLocalizedString(@"QM_STR_SIGNING_IN", nil) duration:0];
    
    __weak UINavigationController *navigationController = self.navigationController;
    
    @weakify(self);
    [[QMTasks taskUpdateCurrentUserImage:self.imageProfile.image progress:nil] continueWithBlock:^id _Nullable(BFTask<QBUUser *> * _Nonnull task) {
        
        @strongify(self);
        
        [navigationController dismissNotificationPanel];
        
        if (!task.isFaulted) {
            
            [self.imageProfile setImage:self.imageProfile.image withKey:task.result.avatarUrl];
            self.strimgProfile = [NSString stringWithFormat:@"%@",task.result.avatarUrl];
            self.blobID = [NSString stringWithFormat:@"%lu",(unsigned long)task.result.blobID];
            //service call Register User
            if([DataModel sharedInstance].isInternetConnected)
                
                [self registration];
            
            else
                [self showAlertMessageWithMessage:@"Connection error" mesage:NSLocalizedString(@"QM_STR_LOST_INTERNET_CONNECTION", nil)];
            // [self getUserData];
        }
        
        return nil;
    }];
    
    //    NSDictionary *dictFile = [[DataModel sharedInstance]getImageFileUrl:self.imageProfile.image];
    //    NSData *avatar         = UIImagePNGRepresentation(self.imageProfile.image);
    //
    //    [QBRequest TUploadFile:avatar fileName:[dictFile objectForKey:FILE_NAME] contentType:@"image/png" isPublic:YES
    //              successBlock:^(QBResponse *imgResponse, QBCBlob *blob){
    //
    //                  if (imgResponse.status == QBResponseStatusCodeOK) {
    //
    //                      NSLog(@"public %@", blob.publicUrl);
    //                          NSLog(@"%@", blob.privateUrl);
    //                      self.blobID = [NSString stringWithFormat:@"%lu",(unsigned long)blob.ID];
    //
    //                      [self getUserData];
    //
    //
    //                  }
    //              }statusBlock:nil errorBlock:nil];
}
//-(void)getUserData
//{
//    NSInteger qbUserID = [QMCore instance].currentProfile.userData.ID;
//
//    [QBRequest userWithID:qbUserID successBlock:^(QBResponse *response, QBUUser *user) {
//
//        if (response.status == QBResponseStatusCodeOK) {
//
//            self.strimgProfile = [NSString stringWithFormat:@"%@",user.avatarUrl];
//            self.blobID = [NSString stringWithFormat:@"%lu",(unsigned long)user.blobID];
//            //service call Register User
//            if([DataModel sharedInstance].isInternetConnected)
//
//                [self registration];
//
//            else
//                [self showAlertMessageWithMessage:@"Connection error" mesage:ConnectionError];
//        }
//
//    } errorBlock:^(QBResponse *__unused response) {
//        // Handle error
//    }];
//
//}
#pragma mark Service CAll
-(void)registration
{
    
    UserProfile *UP = [UserProfile new];
    NSString *strQBUserId  = [NSString stringWithFormat:@"%lu",[QMCore instance].currentProfile.userData.ID];
    NSDictionary *RequestDataDictionary = @{
                                            @"Name"           :self.txtFullName.text,
                                            @"Email"          :self.txtEmail.text,
                                            @"Password"       :self.txtPassword.text,
                                            @"Picture"        :self.strimgProfile,
                                            @"BirthDate"      :@"",
                                            @"GroupMultiple"  :@"",
                                            @"PresentTitle"   :@"",
                                            @"Phone"          :@"",
                                            @"Achivements"    :@"",
                                            @"Career"         :@"",
                                            @"City"           :@"",
                                            @"State"          :@"",
                                            @"Country"        :@"",
                                            @"GroupID"        :UDC.strGroupID,
                                            @"SubGroupID"     :UDC.strSubGroupID,
                                            @"BlobID"         :self.blobID,
                                            @"QuickbloxUserID":strQBUserId,
                                            @"FbID"           :APPDELEGATE.strFBID,
                                            };
    
    
    [UP registerUserWithSuccess:RequestDataDictionary withSuccess:^(NSDictionary *dictResult) {
        
        UserDataController *objUDC = [[UserDataController alloc]initWithDictionary:dictResult];
        
        [[DataModel sharedInstance]setUserID:objUDC.strUserId];
        
        SignupStep2VC *Signup2 = (SignupStep2VC *)[self.storyboard instantiateViewControllerWithIdentifier:@"SignupStep2"];
        Signup2.objUser = objUDC;
        [self.navigationController pushViewController:Signup2 animated:YES];
        
        
        [SVProgressHUD dismiss];
        
    } failure:^(NSError *__unused error) {
        
        [self showAlertMessageWithMessage:@"Error" mesage:CommanErrorMessage];
        [SVProgressHUD dismiss];
    }];
}


@end

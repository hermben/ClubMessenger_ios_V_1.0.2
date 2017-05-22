//
//  QMLogInViewController.m
//  Q-municate
//
//  Created by Igor Alefirenko on 13/02/2014.
//  Copyright (c) 2014 Quickblox. All rights reserved.
//

#import "QMLogInViewController.h"
#import "QMCore.h"
#import "QMFacebook.h"
#import "QMContent.h"
#import "QMTasks.h"
#import "UINavigationController+QMNotification.h"
#import <SVProgressHUD.h>
#import "UserProfile.h"
#import "UserDataController.h"
#import "GlobalSearchVC.h"
#import "QMLicenseAgreement.h"

static NSString * const kQMFacebookIDField = @"id";
static NSString * const kQMFacebookEmailField = @"email";

@interface QMLogInViewController ()
{
    
}

@property (weak, nonatomic) BFTask *task;
@end

@implementation QMLogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationLeftMenu];

    [self.btnLogin setTitle:NSLocalizedString(@"auth_login_title", nil) forState:UIControlStateNormal];
    [self.btnFaceBook setTitle:NSLocalizedString(@"QM_STR_LOGIN_WITH_FACEBOOK", nil) forState:UIControlStateNormal];
    [self.btnForgot setTitle:NSLocalizedString(@"auth_forgot_password", nil) forState:UIControlStateNormal];
    self.txtEmail.placeholder = NSLocalizedString(@"auth_hint_email", nil);
    self.txtPassword.placeholder = NSLocalizedString(@"auth_hint_password", nil);
    
}

- (void)dealloc {
    ILog(@"%@ - %@",  NSStringFromSelector(_cmd), self);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //[self.txtEmail becomeFirstResponder];
}

-(void)setNavigationLeftMenu
{
    
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.title = NSLocalizedString(@"auth_login_title", nil);
    [self.navigationController.navigationBar setBackgroundColor:RGBCommanColor];
    [self.navigationController.navigationBar setBarTintColor:RGBCommanColor];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor blackColor],
       NSFontAttributeName:[UIFont systemFontOfSize:17.0]}];
}

# pragma mark - UITextField Delegate Method

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if([self.txtEmail isFirstResponder])
        
        [self.txtPassword becomeFirstResponder];
    
    else
        [textField resignFirstResponder];
    
    return YES;
}

-(void)touchesEnded:(NSSet *)__unused touches withEvent:(UIEvent *)__unused event{
   
    [self.txtEmail resignFirstResponder];
    [self.txtPassword resignFirstResponder];
    [self.view endEditing:YES];
    
}
#pragma mark Private Methods

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


- (void)doFacebookConnect {
    
    @weakify(self);
    [[[QMFacebook connect] continueWithBlock:^id _Nullable(BFTask<NSString *> * _Nonnull task) {
        // Facebook connect
        if (task.isFaulted || task.isCancelled) {
            
            return nil;
        }
        
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        
        return [[QMCore instance].authService loginWithFacebookSessionToken:task.result];
        
    }] continueWithBlock:^id _Nullable(BFTask<QBUUser *> * _Nonnull task) {
        
        if (task.isFaulted) {
            
            [QMFacebook logout];
        }
        else if (task.result != nil) {
            
            @strongify(self);
          //  [SVProgressHUD dismiss];
            [QMCore instance].currentProfile.accountType = QMAccountTypeFacebook;
            [[QMCore instance].currentProfile synchronizeWithUserData:task.result];
            APPDELEGATE.strFBID = task.result.facebookID ;
            
            if (task.result.email.length == 0) {
                
                return [[QMFacebook loadMe] continueWithSuccessBlock:^id _Nullable(BFTask<NSDictionary *> * _Nonnull loadTask) {
                   
                    QBUpdateUserParameters *params = [QBUpdateUserParameters new];
                    params.email = [loadTask.result objectForKey:kQMFacebookEmailField];

                    @weakify(self);
                    [[QMTasks taskUpdateCurrentUser:params] continueWithBlock:^id _Nullable(BFTask<QBUUser *> * _Nonnull task) {
                        
                        @strongify(self);
                       

                        if (!task.isFaulted) {
                            
                            [QMCore instance].currentProfile.accountType = QMAccountTypeFacebook;
                            [[QMCore instance].currentProfile synchronizeWithUserData:task.result];
                            APPDELEGATE.strFBID = task.result.facebookID ;
                            
                            //service callgetEmailPasswordByFBID
                            if([DataModel sharedInstance].isInternetConnected)
                                
                                [self getEmailPasswordByFBID];
                            
                            else
                                [self showAlertMessageWithMessage:@"Connection error" mesage:NSLocalizedString(@"QM_STR_LOST_INTERNET_CONNECTION", nil)];
                        }
                        
                        return nil;
                    }];
                    
                    return nil;
                    
                }];
            }
            else
            {
                //service callgetEmailPasswordByFBID
                if([DataModel sharedInstance].isInternetConnected)
                    
                    [self getEmailPasswordByFBID];
                
                else
                     [self showAlertMessageWithMessage:@"Connection error" mesage:NSLocalizedString(@"QM_STR_LOST_INTERNET_CONNECTION", nil)];
            }
            
            return [[QMCore instance].pushNotificationManager subscribeForPushNotifications];
        }
        
        return nil;
    }];
}

#pragma mark - IBActions Methods

- (IBAction)btnLogin_Click:(UIButton *)__unused sender {
    
    if (self.task != nil) {
        // task in progress
        return;
    }
    
    if (self.txtEmail.text.length == 0 || self.txtPassword.text.length == 0) {
        
        [self.navigationController showNotificationWithType:QMNotificationPanelTypeWarning message:NSLocalizedString(@"QM_STR_FILL_IN_ALL_THE_FIELDS", nil) duration:kQMDefaultNotificationDismissTime];
    }
    else {
        
        QBUUser *user = [QBUUser user];
        user.email = self.txtEmail.text;
        user.password = self.txtPassword.text;
        
        [self.navigationController showNotificationWithType:QMNotificationPanelTypeLoading message:NSLocalizedString(@"QM_STR_SIGNING_IN", nil) duration:0];
        
        __weak UINavigationController *navigationController = self.navigationController;
        
        @weakify(self);
        self.task = [[[QMCore instance].authService loginWithUser:user] continueWithBlock:^id _Nullable(BFTask<QBUUser *> * _Nonnull task) {
            
            @strongify(self);
            [navigationController dismissNotificationPanel];
            
            if (!task.isFaulted) {
                
                [self performSegueWithIdentifier:kQMSceneSegueMain sender:nil];
                [QMCore instance].currentProfile.accountType = QMAccountTypeEmail;
                [[QMCore instance].currentProfile synchronizeWithUserData:task.result];
                               
                return [[QMCore instance].pushNotificationManager subscribeForPushNotifications];
            }
            
            return nil;
        }];
    }
    
}

- (IBAction)btnFaceBook_Click:(UIButton *)__unused sender {
    
//    [QMLicenseAgreement checkAcceptedUserAgreementInViewController:self completion:^(BOOL success) {
//        // License agreement check
//        if (success) {
    
            [self doFacebookConnect];
//        }
//    }];
    
    
}

- (IBAction)btnBack_Click:(id)__unused sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Service CAll
-(void)getEmailPasswordByFBID
{
    
    UserProfile *UP = [UserProfile new];
    
    
    [UP getEmailPasswordByFbIdWithSuccess:APPDELEGATE.strFBID withSuccess:^(NSDictionary *dictResult) {
        
        if(dictResult != nil)
        {
            [self performSegueWithIdentifier:kQMSceneSegueMain sender:nil];
        }
        else
        {
            GlobalSearchVC *gsVC=(GlobalSearchVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"GlobalSearchID"];
            gsVC.isClubs = false;
            gsVC.isFromFBSignUp = true;
            gsVC.hidesBottomBarWhenPushed = true;
            [self.navigationController pushViewController:gsVC animated:YES];
        }
        [SVProgressHUD dismiss];
        
    } failure:^(NSError *__unused error) {
        
        [self showAlertMessageWithMessage:@"Error" mesage:CommanErrorMessage];
        [SVProgressHUD dismiss];
    }];
}

@end

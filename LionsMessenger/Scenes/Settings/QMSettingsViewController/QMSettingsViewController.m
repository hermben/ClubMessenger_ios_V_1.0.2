//
//  QMSettingsViewController.m
//  Q-municate
//
//  Created by Vitaliy Gorbachov on 5/4/16.
//  Copyright © 2016 Quickblox. All rights reserved.
//

#import "QMSettingsViewController.h"
#import "QMTableSectionHeaderView.h"
#import "QMColors.h"
#import "QMUpdateUserViewController.h"
#import "QMImagePicker.h"
#import "QMTasks.h"
#import "QMCore.h"
#import "QMProfile.h"
#import <QMImageView.h>
#import "UINavigationController+QMNotification.h"
#import "QMSettingsFooterView.h"
#import "QMFacebook.h"
#import <NYTPhotoViewer/NYTPhotosViewController.h>
#import "QMImagePreview.h"

#import "UserDataController.h"
#import "UserProfile.h"

#import "DonateFundVC.h"
#import "ProfileVC.h"
#import "AboutVC.h"

static const CGFloat kQMDefaultSectionHeaderHeight = 24.0f;
static const CGFloat kQMStatusSectionHeaderHeight = 40.0f;

typedef NS_ENUM(NSUInteger, QMSettingsSection) {
    
    QMSettingsSectionProfile,
    QMSettingsSectionStatus,
    QMSettingsSectionUserInfo,
    QMSettingsSectionExtra,
    QMSettingsSectionSocial,
    QMSettingsSectionLogout
};

typedef NS_ENUM(NSUInteger, QMUserInfoSection) {
    
    QMUserInfoSectionDonateFund,
    QMUserInfoSectionChangePassword
};

typedef NS_ENUM(NSUInteger, QMUserAlertSection) {
    
    QMUserAlertSectionNotification,
    QMUserAlertSectionExtendedSearch
    
};

typedef NS_ENUM(NSUInteger, QMSocialSection) {
    
    QMSocialSectionTellFriend,
    QMSocialSectionGiveFeedback,
    QMSocialSectionAbout
};

typedef NS_ENUM(NSUInteger, QMLogoutSection) {
    
    QMLogoutSectionLogout,
    QMLogoutSectionDeleteAccount
};

@interface QMSettingsViewController ()

<
QMProfileDelegate,
QMImageViewDelegate,
QMImagePickerResultHandler,

NYTPhotosViewControllerDelegate
>

@property (weak, nonatomic) IBOutlet QMImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (weak, nonatomic) IBOutlet UISwitch *pushNotificationSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *extendedSearchSwitch;


@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) BFTask *subscribeTask;
@property (weak, nonatomic) BFTask *logoutTask;
@property (weak, nonatomic) BFTask *task;

@property (strong, nonatomic) NSMutableIndexSet *hiddenUserInfoCells;
@property (strong, nonatomic) NSMutableIndexSet *hiddenUserAlertCells;
@end

@implementation QMSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationMenu];
    self.hiddenUserInfoCells = [NSMutableIndexSet indexSet];
    self.hiddenUserAlertCells = [NSMutableIndexSet indexSet];
    self.avatarImageView.imageViewType = QMImageViewTypeCircle;
    
    // Hide empty separators
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // Set tableview background color
    self.tableView.backgroundColor = QMTableViewBackgroundColor();
    
    // configure user data
    [self configureUserData:[QMCore instance].currentProfile.userData];
    self.pushNotificationSwitch.on = [QMCore instance].currentProfile.pushNotificationsEnabled;
    
    if(APPDELEGATE.isIsEligible == false)
    {
        [self.hiddenUserAlertCells addIndex:QMUserAlertSectionExtendedSearch];
    }
    if ([[DataModel sharedInstance]isExtendSearch] == false) {
        
        self.extendedSearchSwitch.on = false;
    }
    else
    {
        self.extendedSearchSwitch.on = true;
    }
    // determine account type
    if ([QMCore instance].currentProfile.accountType != QMAccountTypeEmail) {
        
       
        [self.hiddenUserInfoCells addIndex:QMUserInfoSectionChangePassword];
        
    }
     [self.hiddenUserInfoCells addIndex:QMUserInfoSectionDonateFund];
    // subscribe to delegates
    [QMCore instance].currentProfile.delegate = self;
    self.avatarImageView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.lblLogout.text             = NSLocalizedString(@"settings_logout", nil);
    self.lblChangePassword.text     = NSLocalizedString(@"settings_change_password", nil);
    self.lblPuchNotification.text   = NSLocalizedString(@"settings_push_notifications", nil);
    self.lblGiveFeedBack.text       = NSLocalizedString(@"settings_give_feedback", nil);
    self.lblDeleteAccount.text      = NSLocalizedString(@"settings_delete_my_account", nil);
    self.inviteFriends.text         = NSLocalizedString(@"settings_invite_friends", nil);
    
    // smooth rows deselection
    [self qm_smoothlyDeselectRowsForTableView:self.tableView];
}

#pragma mark Privete Methods

-(void)setNavigationMenu
{
    self.navigationItem.title = NSLocalizedString(@"action_bar_settings", nil);
    [self.navigationController.navigationBar setBackgroundColor:RGBCommanColor];
    [self.navigationController.navigationBar setBarTintColor:RGBCommanColor];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor blackColor],
       NSFontAttributeName:[UIFont systemFontOfSize:17.0]}];
}
- (void)configureUserData:(QBUUser *)userData {
    
    [self.avatarImageView setImageWithURL:[NSURL URLWithString:userData.avatarUrl]
                              placeholder:[UIImage imageNamed:@"upic_avatarholder"]
                                  options:SDWebImageHighPriority
                                 progress:nil
                           completedBlock:nil];
    
    self.fullNameLabel.text = userData.fullName;
    
    //    if (userData.phone.length > 0) {
    //
    //        self.phoneLabel.text = userData.phone;
    //    }
    //    else {
    //
    //        [self.hiddenUserInfoCells addIndex:QMUserInfoSectionPhone];
    //    }
    //
    //    self.emailLabel.text = userData.email.length > 0 ? userData.email : NSLocalizedString(@"QM_STR_NONE", nil);
    //
    self.statusLabel.text = userData.status.length > 0 ? userData.status : NSLocalizedString(@"QM_STR_NONE", nil);
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

#pragma mark - Actions

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:kQMSceneSegueUpdateUser]) {
        
        UINavigationController *navigationController = segue.destinationViewController;
        QMUpdateUserViewController *updateUserVC = navigationController.viewControllers.firstObject;
        updateUserVC.updateUserField = [sender unsignedIntegerValue];
    }
}
- (IBAction)extendedSearchSwitchPressed:(UISwitch *)__unused  sender {
    
    if (sender.isOn) {
        
        [[DataModel sharedInstance]setIsExtendSearch:true];
    }
    else
    {
        [[DataModel sharedInstance]setIsExtendSearch:false];
    }
}

- (IBAction)pushNotificationSwitchPressed:(UISwitch *)sender {
    
    if (self.subscribeTask) {
        // task is in progress
        return;
    }
    
    [self.navigationController showNotificationWithType:QMNotificationPanelTypeLoading message:NSLocalizedString(@"QM_STR_LOADING", nil) duration:0];
    
    __weak UINavigationController *navigationController = self.navigationController;
    BFContinuationBlock completionBlock = ^id _Nullable(BFTask * _Nonnull __unused task) {
        
        [navigationController dismissNotificationPanel];
        
        return nil;
    };
    
    if (sender.isOn) {
        
        self.subscribeTask = [[[QMCore instance].pushNotificationManager subscribeForPushNotifications] continueWithBlock:completionBlock];
    }
    else {
        
        self.subscribeTask = [[[QMCore instance].pushNotificationManager unSubscribeFromPushNotifications] continueWithBlock:completionBlock];
    }
}

- (void)logout {
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:nil
                                          message:NSLocalizedString(@"QM_STR_LOGOUT_CONFIRMATION", nil)
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"QM_STR_CANCEL", nil)
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction * _Nonnull __unused action) {
                                                      }]];
    
    __weak UINavigationController *navigationController = self.navigationController;
    
    @weakify(self);
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"QM_STR_LOGOUT", nil)
                                                        style:UIAlertActionStyleDestructive
                                                      handler:^(UIAlertAction * _Nonnull __unused action) {
                                                          
//                                                          @strongify(self);
//                                                          if (self.logoutTask) {
//                                                              // task is in progress
//                                                              return;
//                                                          }
//                                                          
//                                                          [self.navigationController showNotificationWithType:QMNotificationPanelTypeLoading message:NSLocalizedString(@"QM_STR_LOADING", nil) duration:0];
//                                                          
//                                                          self.logoutTask = [[[QMCore instance] logout] continueWithBlock:^id _Nullable(BFTask * _Nonnull __unused logoutTask) {
                                                          [QBRequest logOutWithSuccessBlock:^(QBResponse *response) {
                                                              
                                                               // Successful logout
                                                              
                                                              if (response.status == QBResponseStatusCodeOK) {
                                                              BFTaskCompletionSource *source = [BFTaskCompletionSource taskCompletionSource];
                                                              @strongify(self);
                                                              if ([QMCore instance].currentProfile.accountType == QMAccountTypeFacebook) {
                                                                  
                                                                  [QMFacebook logout];
                                                              }
                                                              else if ([QMCore instance].currentProfile.accountType == QMAccountTypeDigits) {
                                                                  
                                                                  [[Digits sharedInstance] logOut];
                                                              }
                                                              
                                                              [[SDWebImageManager sharedManager].imageCache clearMemory];
                                                              [[SDWebImageManager sharedManager].imageCache clearDisk];
                                                              
                                                              // clearing contact list cache and memory storage
                                                              [[QMContactListCache instance] deleteContactList:nil];
                                                              [[QMCore instance].contactListService.contactListMemoryStorage free];
                                                              
                                                              [[QMCore instance].currentProfile clearProfile];
                                                              [source setResult:nil];
                                                              
                                                              [navigationController dismissNotificationPanel];
                                                              [[DataModel sharedInstance]removeAllCredentials];
                                                              [self performSegueWithIdentifier:kQMSceneSegueAuth sender:nil];
                                                              }
                                                             
                                                          } errorBlock:^(QBResponse * __unused response) {
                                                              // Handle error
                                                          }];
                                                          
//                                                              return nil;
//                                                          }];
                                                      }]];

                                                              
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)deleteUser {
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:nil
                                          message:NSLocalizedString(@"QM_STR_DELETE_CONFIRMATION", nil)
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"QM_STR_CANCEL", nil)
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction * _Nonnull __unused action) {
                                                      }]];
    
    //__weak UINavigationController *navigationController = self.navigationController;
    
    
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"QM_STR_DELETE", nil)
                                                        style:UIAlertActionStyleDestructive
                                                      handler:^(UIAlertAction * _Nonnull __unused action) {
                                                          
                                                          
                                                          [self.navigationController showNotificationWithType:QMNotificationPanelTypeLoading message:NSLocalizedString(@"QM_STR_LOADING", nil) duration:0];
                                                          
                                                        
                                                              
                                                              [QBRequest deleteCurrentUserWithSuccessBlock:^(QBResponse * _Nonnull __unused response) {
                                                                  
                                                                  if (response.status == QBResponseStatusCodeOK) {
                                                                      
                                                                      if([DataModel sharedInstance].isInternetConnected)
                                                                          
                                                                          [self deleteUserAccount];
                                                                      
                                                                      else
                                                                          [self showAlertMessageWithMessage:@"Connection error" mesage:NSLocalizedString(@"QM_STR_LOST_INTERNET_CONNECTION", nil)];
                                                                  }
                                                              } errorBlock:^(QBResponse * _Nonnull __unused response) {
                                                                  
                                                              }];
                                                              
                                                                                                                     
                                                      }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == QMSettingsSectionUserInfo
        && [self.hiddenUserInfoCells containsIndex:indexPath.row]) {
        
        return CGFLOAT_MIN;
    }
    if (indexPath.section == QMSettingsSectionExtra
        && [self.hiddenUserAlertCells containsIndex:indexPath.row]) {
        
        return CGFLOAT_MIN;
    }
    
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
            
        case QMSettingsSectionProfile:
        {
            ProfileVC *pVC = (ProfileVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"ProfileID"];
            pVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:pVC animated:YES];
            
            break;
        }
        case QMSettingsSectionStatus:
            [self performSegueWithIdentifier:kQMSceneSegueUpdateUser sender:@(QMUpdateUserFieldStatus)];
            break;
            
        case QMSettingsSectionUserInfo:
            
            switch (indexPath.row) {
                    
                case QMUserInfoSectionDonateFund:
//                {
//                    DonateFundVC *dfVC = (DonateFundVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"DonateFundID"];
//                    dfVC.hidesBottomBarWhenPushed = YES;
//                    [self.navigationController pushViewController:dfVC animated:YES];
//                    
//                    break;
//                }
                    
                case QMUserInfoSectionChangePassword:
                    [self performSegueWithIdentifier:kQMSceneSeguePassword sender:nil];
                    break;
            }
            
            break;
            
        case QMSettingsSectionExtra:
            
            break;
            
        case QMSettingsSectionSocial:
            
            switch (indexPath.row) {
                    
                case QMSocialSectionTellFriend: {
                    [tableView deselectRowAtIndexPath:indexPath animated:YES];
                    
                    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                    [self showShareControllerInCell:cell];
                    break;
                }
                    
                case QMSocialSectionGiveFeedback:
                    [self performSegueWithIdentifier:kQMSceneSegueFeedback sender:nil];
                    break;
                    
                case QMSocialSectionAbout:
                {
                    AboutVC *aVC = (AboutVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"AboutID"];
                    aVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:aVC animated:YES];
                    
                    break;
                }
            }
            
            break;
            
        case QMSettingsSectionLogout:
            
            switch (indexPath.row) {
                    
                case QMLogoutSectionLogout: {
                    [tableView deselectRowAtIndexPath:indexPath animated:YES];
                    [self logout];
                    break;
                }
                case QMLogoutSectionDeleteAccount:{
                    [tableView deselectRowAtIndexPath:indexPath animated:YES];
                    [self deleteUser];
                    break;
                }
                    
            }
            
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == QMSettingsSectionStatus) {
        
        QMTableSectionHeaderView *headerView = [[QMTableSectionHeaderView alloc]
                                                initWithFrame:CGRectMake(0,
                                                                         0,
                                                                         CGRectGetWidth(tableView.frame),
                                                                         kQMStatusSectionHeaderHeight)];
        headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        headerView.title = [NSLocalizedString(@"QM_STR_STATUS", nil) uppercaseString];;
        
        return headerView;
    }
    
    return [super tableView:tableView viewForHeaderInSection:section];
}

- (CGFloat)tableView:(UITableView *)__unused tableView heightForHeaderInSection:(NSInteger)section {
    
    if (![self shouldShowHeaderForSection:section]) {
        
        return CGFLOAT_MIN;
    }
    
    if (section == QMSettingsSectionStatus) {
        
        return kQMStatusSectionHeaderHeight;
    }
    
    return kQMDefaultSectionHeaderHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (section == QMSettingsSectionLogout) {
        
        QMSettingsFooterView *footerView = [[QMSettingsFooterView alloc]
                                            initWithFrame:CGRectMake(0,
                                                                     0,
                                                                     CGRectGetWidth(tableView.frame),
                                                                     [QMSettingsFooterView preferredHeight])];
        
        return footerView;
    }
    
    return [super tableView:tableView viewForFooterInSection:section];
}

- (CGFloat)tableView:(UITableView *)__unused tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == QMSettingsSectionLogout) {
        
        return [QMSettingsFooterView preferredHeight];
    }
    
    return CGFLOAT_MIN;
}

#pragma mark - QMProfileDelegate

- (void)profile:(QMProfile *)__unused currentProfile didUpdateUserData:(QBUUser *)userData {
    
    [self configureUserData:userData];
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
    
    NSString *avatarURL = [QMCore instance].currentProfile.userData.avatarUrl;
    if (avatarURL.length > 0) {
        
        [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"QM_STR_OPEN_IMAGE", nil)
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull __unused action) {
                                                              
                                                              [QMImagePreview previewImageWithURL:[NSURL URLWithString:avatarURL] inViewController:self];
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
            
            [self.avatarImageView setImage:photo withKey:task.result.avatarUrl];
        }
        
        return nil;
    }];
}

#pragma mark - NYTPhotosViewControllerDelegate

- (UIView *)photosViewController:(NYTPhotosViewController *)__unused photosViewController referenceViewForPhoto:(id<NYTPhoto>)__unused photo {
    
    return self.avatarImageView;
}

#pragma mark - Share View Controller

- (void)showShareControllerInCell:(UITableViewCell *)cell {
    
    NSArray *items = @[NSLocalizedString(@"QM_STR_SHARE_TEXT", nil)];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
    activityViewController.excludedActivityTypes = @[UIActivityTypeAirDrop, UIActivityTypeCopyToPasteboard];
    
    if (activityViewController.popoverPresentationController) {
        // iPad support
        activityViewController.popoverPresentationController.sourceView = cell;
        activityViewController.popoverPresentationController.sourceRect = cell.bounds;
    }
    
    [self presentViewController:activityViewController animated:YES completion:nil];
}

#pragma mark - Helpers

- (BOOL)shouldShowHeaderForSection:(NSInteger)section {
    
    if (section == QMSettingsSectionProfile) {
        
        return NO;
    }
    
    if (section == QMSettingsSectionUserInfo
        && [self.hiddenUserInfoCells containsIndex:QMUserInfoSectionDonateFund])
    {
        
        return NO;
    }
    
    //    if (section == QMSettingsSectionExtra
    //        && [self.hiddenUserAlertCells containsIndex:QMUserAlertSectionExtendedSearch])
    //    {
    //
    //        return NO;
    //    }
    
    return YES;
}

#pragma mark Service Call
-(void)deleteUserAccount
{
    __weak UINavigationController *navigationController = self.navigationController;
    
    UserProfile *UP = [UserProfile new];
    
    NSString *strUserId  = [[DataModel sharedInstance]getUserID];
    
    [UP deleteUSerByIdWithSuccess:strUserId withSuccess:^(NSDictionary *dictResult) {
        
        if([[dictResult objectForKey:@"Message"] isEqualToString:@"User has been deleted successfully"])
        {
            [navigationController dismissNotificationPanel];
            
            [[DataModel sharedInstance]removeAllCredentials];
            [self performSegueWithIdentifier:kQMSceneSegueAuth sender:nil];
        }
        
        
    } failure:^(NSError *__unused error) {
        
        [self showAlertMessageWithMessage:@"Error" mesage:CommanErrorMessage];
        [SVProgressHUD dismiss];
    }];
}

@end

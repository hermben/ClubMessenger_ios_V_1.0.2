//
//  QMSettingsViewController.h
//  Q-municate
//
//  Created by Vitaliy Gorbachov on 5/4/16.
//  Copyright © 2016 Quickblox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QMSettingsViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UILabel *lblDonateFund;
@property (weak, nonatomic) IBOutlet UILabel *lblChangePassword;
@property (weak, nonatomic) IBOutlet UILabel *lblPuchNotification;
@property (weak, nonatomic) IBOutlet UILabel *lblExtendSearch;
@property (weak, nonatomic) IBOutlet UILabel *inviteFriends;
@property (weak, nonatomic) IBOutlet UILabel *lblGiveFeedBack;
@property (weak, nonatomic) IBOutlet UILabel *lblAbout;
@property (weak, nonatomic) IBOutlet UILabel *lblLogout;
@property (weak, nonatomic) IBOutlet UILabel *lblDeleteAccount;

@end

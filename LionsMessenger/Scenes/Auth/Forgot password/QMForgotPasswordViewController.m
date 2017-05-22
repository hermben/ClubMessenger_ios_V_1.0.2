//
//  QMForgotPasswordTVC.m
//  Qmunicate
//
//  Created by Andrey Ivanov on 30.06.14.
//  Copyright (c) 2014 Quickblox. All rights reserved.
//

#import "QMForgotPasswordViewController.h"
#import "QMTasks.h"
#import "UINavigationController+QMNotification.h"

@interface QMForgotPasswordViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

@property (weak, nonatomic) BFTask *task;

@end

@implementation QMForgotPasswordViewController

- (void)dealloc {
    ILog(@"%@ - %@",  NSStringFromSelector(_cmd), self);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationLeftMenu];
    
   
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.emailTextField becomeFirstResponder];
}



-(void)setNavigationLeftMenu
{
 
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.title = @"Forgot Password";
    [self.navigationController.navigationBar setBackgroundColor:RGBCommanColor];
    [self.navigationController.navigationBar setBarTintColor:RGBCommanColor];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor blackColor],
       NSFontAttributeName:[UIFont systemFontOfSize:17.0]}];

    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button setTitle:@"Back" forState:UIControlStateNormal];
//    button.titleLabel.font = [UIFont systemFontOfSize:15];
//    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    button.frame = CGRectMake(10, 22, 40, 40);
//    [button addTarget:self action:@selector(btnBack_Click:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *customBarItemHome = [[UIBarButtonItem alloc] initWithCustomView:button];
//    
//    
//    UIButton *btnReset = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btnReset setTitle:@"Reset" forState:UIControlStateNormal];
//    btnReset.titleLabel.font = [UIFont systemFontOfSize:15];
//    [btnReset setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//    btnReset.frame = CGRectMake(270, 22, 40, 40);
//    [btnReset addTarget:self action:@selector(pressResetPasswordBtn:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:btnReset];
//    
//    self.navigationItem.rightBarButtonItem = customBarItem;
//    self.navigationItem.leftBarButtonItem = customBarItemHome;
    
}

#pragma mark - actions

- (IBAction)btnBack_Click:(id)__unused sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)pressResetPasswordBtn:(id)__unused sender {
    
    if (self.task != nil) {
        // task in progress
        return;
    }
    
    NSString *email = self.emailTextField.text;
    
    if (email.length > 0) {
        
        [self resetPasswordForMail:email];
    }
    else {
        
        [self.navigationController showNotificationWithType:QMNotificationPanelTypeWarning message:NSLocalizedString(@"QM_STR_EMAIL_FIELD_IS_EMPTY", nil) duration:kQMDefaultNotificationDismissTime];
    }
}

- (void)resetPasswordForMail:(NSString *)emailString {

    [self.navigationController showNotificationWithType:QMNotificationPanelTypeLoading
                                                message:NSLocalizedString(@"QM_STR_LOADING", nil)
                                               duration:0];
    
    __weak UINavigationController *navigationController = self.navigationController;
    
    @weakify(self);
    self.task = [[QMTasks taskResetPasswordForEmail:emailString] continueWithBlock:^id _Nullable(BFTask * _Nonnull task) {
        
        @strongify(self);
        if (task.isFaulted) {
            
            [navigationController showNotificationWithType:QMNotificationPanelTypeFailed message:NSLocalizedString(@"QM_STR_USER_WITH_EMAIL_WASNT_FOUND", nil) duration:kQMDefaultNotificationDismissTime];
        }
        else {
            
            [navigationController showNotificationWithType:QMNotificationPanelTypeSuccess message:NSLocalizedString(@"QM_STR_MESSAGE_WAS_SENT_TO_YOUR_EMAIL", nil) duration:kQMDefaultNotificationDismissTime];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        return nil;
    }];
}

@end

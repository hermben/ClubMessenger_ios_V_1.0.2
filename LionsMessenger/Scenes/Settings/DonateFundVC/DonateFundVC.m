//
//  DonateFundVC.m
//  LionsMessenger
//
//  Created by Administrator on 2/21/17.
//  Copyright © 2017 Quickblox. All rights reserved.
//

#import "DonateFundVC.h"
#import "PaymentVC.h"

#import "REMessageUI.h"

@interface DonateFundVC ()

@end

@implementation DonateFundVC

#pragma mark View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self Initialization];
    
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Privete Methods
-(void)Initialization
{
    [self setNavigationLeftMenu];
    
    self.btnPayViaCard.layer.shadowColor = RGBColor(227, 277, 277).CGColor;
    self.btnPayViaCard.layer.shadowOpacity = 0.5;
    self.btnPayViaCard.layer.shadowOffset = CGSizeMake(2, 2);
    self.btnPayViaCard.layer.shadowRadius = 2;
    
    self.lblContact.text = NSLocalizedString(@"contact_us", nil);
    self.lblDescription.text = NSLocalizedString(@"donate_fund_layout_text", nil);
    [self.btnContactUs setTitle:NSLocalizedString(@"donate_fund_layout_text_contact_us", nil) forState:UIControlStateNormal];
    [self.btnPayViaCard setTitle:NSLocalizedString(@"donate_fund_text_pay_stripe", nil) forState:UIControlStateNormal];

}
-(void)setNavigationLeftMenu
{
    
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.title = NSLocalizedString(@"settings_donate_fund", nil);
    [self.navigationController.navigationBar setBackgroundColor:RGBCommanColor];
    [self.navigationController.navigationBar setBarTintColor:RGBCommanColor];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor blackColor],
       NSFontAttributeName:[UIFont systemFontOfSize:17.0]}];
    
}

- (void)writeEmail {
    
    @weakify(self);
    [REMailComposeViewController present:^(REMailComposeViewController *mailVC) {
        
        @strongify(self);
        NSString *recipient = @"info@clubmessengers.org";
        
        NSString *subject = @"Conatct";
        NSString *messageBody = @"";
        
        [mailVC setSubject:subject];
        [mailVC setToRecipients:@[recipient]];
        [mailVC setMessageBody:messageBody isHTML:NO];
        
        [self presentViewController:mailVC animated:YES completion:nil];
        
    } finish:^(MFMailComposeResult result, NSError * __unused error) {
        
        if (result == MFMailComposeResultSent) {
            
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"QM_STR_THANKS", nil)];
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        else if (result == MFMailComposeResultFailed) {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"QM_STR_MAIL_COMPOSER_ERROR_DESCRIPTION", nil) preferredStyle:UIAlertControllerStyleAlert];
            
            [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"QM_STR_CANCEL", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull __unused action) {
                
            }]];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
}
    
- (IBAction)btnContactUs_Click:(UIButton *)__unused sender {
    
    [self writeEmail];
}

- (IBAction)btnPAyViaCard_Click:(UIButton *)__unused sender {
    
    PaymentVC  *pVC = (PaymentVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"PaymentID"];
    [self.navigationController pushViewController:pVC animated:YES];
}
@end

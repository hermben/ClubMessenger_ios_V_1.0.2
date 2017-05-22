//
//  QMLogInViewController.h
//  Q-municate
//
//  Created by Igor Alefirenko on 13/02/2014.
//  Copyright (c) 2014 Quickblox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QMLogInViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *NavigationTitle;

@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UISwitch *switchRemember;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnFaceBook;
@property (weak, nonatomic) IBOutlet UIButton *btnForgot;
- (IBAction)btnLogin_Click:(UIButton *)sender;
- (IBAction)btnFaceBook_Click:(UIButton *)sender;
- (IBAction)btnBack_Click:(id)sender;


@end

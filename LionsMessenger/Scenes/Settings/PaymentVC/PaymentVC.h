//
//  PaymentVC.h
//  LionsMessenger
//
//  Created by Administrator on 2/21/17.
//  Copyright © 2017 Quickblox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentVC : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lblmail;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblCardNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblExpireDate;
@property (weak, nonatomic) IBOutlet UILabel *lblCVC;
@property (weak, nonatomic) IBOutlet UILabel *lblAmount;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;


//@property(nonatomic) STPPaymentCardTextField *paymentTextField;
//@property (strong, nonatomic) STPCardParams* stripeCard;
@property (nonatomic, assign) NSInteger paymentType;
@property (nonatomic, assign) BOOL     isMonth;
@property (weak, nonatomic) IBOutlet UITextField  *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField  *txtName;
@property (weak, nonatomic) IBOutlet UITextField  *txtCardNumber;
@property (weak, nonatomic) IBOutlet UITextField  *txtCvvNumber;
@property (weak, nonatomic) IBOutlet UITextField  *txtAmount;
@property (weak, nonatomic) IBOutlet UITextView   *txtViewDescription;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView_Main;
@property (weak, nonatomic) IBOutlet UIView       *viewContent;

@property (weak, nonatomic) IBOutlet UIButton     *btnExpiryMonth;
@property (weak, nonatomic) IBOutlet UIButton     *btnExpiryYear;
@property (strong, nonatomic) IBOutlet UIView     *datePickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *expiryDatePicker;
@property (weak, nonatomic) IBOutlet UIButton     *btnSendPayment;

- (IBAction)btnMonth_Click:(UIButton *)sender;
- (IBAction)btnYear_Click:(UIButton *)sender;
- (IBAction)btnDone_Click:(UIButton *)sender;
- (IBAction)btnSendPayment_Click:(UIButton *)sender;
- (IBAction)handleTabGestureMethods:(UITapGestureRecognizer *)sender;

#pragma mark NSLayout Property
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constratintViewContentHeight;

@end

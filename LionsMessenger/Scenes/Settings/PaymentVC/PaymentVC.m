//
//  PaymentVC.m
//  LionsMessenger
//
//  Created by Administrator on 2/21/17.
//  Copyright © 2017 Quickblox. All rights reserved.
//

#import "PaymentVC.h"
#import "UserProfile.h"
#import "UserDataController.h"

@interface PaymentVC ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSString* validationMessage;
    NSMutableArray *arrMonth;
    NSMutableArray *arrYear;
    CGFloat animateHeight;
}
@end

@implementation PaymentVC

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
    
    self.lblmail.text = NSLocalizedString(@"payment_email", nil);
    self.lblName.text  = NSLocalizedString(@"payment_name_of_Card", nil);
    self.lblCardNumber.text  = NSLocalizedString(@"payment_card_number", nil);
    self.lblExpireDate.text  = NSLocalizedString(@"payment_ex_date", nil);
    self.lblCVC.text  = NSLocalizedString(@"payment_cvc", nil);
    self.lblAmount.text  = NSLocalizedString(@"payment_amount", nil);
    self.lblDescription.text  = NSLocalizedString(@"payment_desc", nil);
    [self.btnSendPayment setTitle:NSLocalizedString(@"payment_btn_send_payment", nil) forState:UIControlStateNormal];
    
    UIColor *color = UIColorFromRGB(0xb4bdf0);
    self.txtName.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:NSLocalizedString(@"payment_card_number", nil)
                                    attributes:@{
                                                 NSForegroundColorAttributeName: color
                                                 }
     ];
    
    self.txtEmail.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:NSLocalizedString(@"payment_email", nil)
                                    attributes:@{
                                                 NSForegroundColorAttributeName: color
                                                 }
     ];
    
    self.txtCardNumber.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:NSLocalizedString(@"payment_card_number", nil)
                                    attributes:@{
                                                 NSForegroundColorAttributeName: color
                                                 }
     ];
    
    self.txtCvvNumber.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:NSLocalizedString(@"payment_cvv_no", nil)
                                    attributes:@{
                                                 NSForegroundColorAttributeName: color
                                                 }
     ];
    
    self.txtAmount.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:NSLocalizedString(@"payment_amount", nil)
                                    attributes:@{
                                                 NSForegroundColorAttributeName: color
                                                 }
     ];
    
    self.txtViewDescription.text = NSLocalizedString(@"payment_desc", nil);
    self.txtViewDescription.textColor = color;
    
    [self.txtCardNumber setTag:1];
    
    
    [self.datePickerView setHidden:YES];
    
    arrMonth = [[NSMutableArray alloc]initWithObjects:
                @"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10", @"11", @"12",nil];
    
    arrYear = [[NSMutableArray alloc]initWithObjects:
               @"15", @"16", @"17", @"18", @"19", @"20", @"21", @"22", @"23", @"24", @"25", @"26", @"27",
               @"28", @"29", @"30", @"31", @"32", @"33", @"34", @"35", @"36", @"37", @"38", @"38", @"39", @"40", @"41", @"42", @"43",
               @"44", @"45", @"46", @"47", @"48", @"49", @"50", @"51", @"52", @"53", nil];
    
   // [Stripe setDefaultPublishableKey:PUBLISHABLE_KEY];
    
    self.txtAmount.text = @"12";
}
-(void)setNavigationLeftMenu
{
    
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.title = @"Add Payment";
    [self.navigationController.navigationBar setBackgroundColor:RGBCommanColor];
    [self.navigationController.navigationBar setBarTintColor:RGBCommanColor];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor blackColor],
       NSFontAttributeName:[UIFont systemFontOfSize:17.0]}];
    
}

- (BOOL)isDataValid {
    
    if(self.txtEmail.text.length == 0)
    {
        validationMessage = NSLocalizedString(@"reg_error_MSG_ENTER_MAIL", nil);
        return FALSE;
    }
    
    if(![[DataModel sharedInstance] validateEmailWithString:self.txtEmail.text])
    {
        validationMessage = NSLocalizedString(@"reg_error_MSG_ENTER_VALID_MAIL", nil);
        return FALSE;
    }
    
    if(self.txtName.text.length == 0)
    {
        validationMessage = NSLocalizedString(@"reg_error_MSG_ENTER_NAME", nil);
        return FALSE;
    }
    
    if(self.txtCardNumber.text.length == 0)
    {
        validationMessage = NSLocalizedString(@"reg_error_enter_card_number", nil);
        return FALSE;
    }
    
    if([self.btnExpiryMonth.titleLabel.text isEqualToString:@"Month"])
    {
        validationMessage = NSLocalizedString(@"reg_error_plz_select_month", nil);
        return FALSE;
    }
    if([self.btnExpiryYear.titleLabel.text isEqualToString:@"Year"])
    {
        validationMessage = NSLocalizedString(@"reg_error_plz_select_year", nil);
        return FALSE;
    }
    if(self.txtCvvNumber.text.length == 0)
    {
        validationMessage = NSLocalizedString(@"reg_error_enter_card_CVC", nil);
        return FALSE;
    }
    if([self.txtAmount.text intValue] < 12)
    {
        validationMessage = NSLocalizedString(@"reg_error_MSG_ENTER_AMOUNT_VALUE", nil);
        return FALSE;
    }
    //2. Validate card number, CVC, expMonth, expYear
    NSError* error = nil;
    //[self.stripeCard validateCardReturningError:&error];
    
    //3
    if (error) {
        validationMessage = [error localizedDescription];
        
        return FALSE;
    }
    return TRUE;
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


#pragma mark TextFild Delegate
-(BOOL) textFieldShouldReturn:(UITextField *)__unused textField {
    
    if([self.txtEmail isFirstResponder])
    {
        [self.txtName becomeFirstResponder];
    }
    else if([self.txtName isFirstResponder])
    {
        [self.txtCardNumber becomeFirstResponder];
    }
    else if ([self.txtCardNumber isFirstResponder])
    {
        [self.txtCvvNumber becomeFirstResponder];
    }
    else if ([self.txtCvvNumber isFirstResponder])
    {
        [self.txtAmount becomeFirstResponder];
    }
    else
    {
        [self.txtAmount resignFirstResponder];
    }
    
    return YES;
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    //    [self.datePickerView setHidden:YES];
    //    if(textField == self.txtEmail)
    //    {
    //        [self.scrollView_Main setContentOffset:CGPointMake(0, - 50) animated:YES];
    //    }
    //    else if(textField == self.txtCardNumber)
    //    {
    //        [self.scrollView_Main setContentOffset:CGPointMake(0, 80) animated:YES];
    //    }
    //    else if (textField == self.txtCvvNumber)
    //    {
    //        [self.scrollView_Main setContentOffset:CGPointMake(0, 130) animated:YES];
    //    }
    //    else if (textField == self.txtAmount)
    //    {
    //        [self.scrollView_Main setContentOffset:CGPointMake(0, 180) animated:YES];
    //    }
    //    else
    //    {
    //        [self.scrollView_Main setContentOffset:CGPointMake(0, 0) animated:YES];
    //    }
    //    self.constratintViewContentHeight.constant = 517 + 245;
    
    [self.datePickerView setHidden:YES];
    CGRect textFieldRect = [self.view.window convertRect:textField.bounds fromView:textField];
    [self keyBordShow:textFieldRect];
    
}

- (void)textFieldDidEndEditing:(UITextField *)__unused textField
{
    [self keyBordHide];
    
}


-(void)textViewDidBeginEditing:(UITextView *)textView{
    
    textView.text = @"";
    textView.textColor = UIColorFromRGB(0x303AA6);
    // CGPoint scrollPoint = CGPointMake(0.0, 230);
    //     [self.scrollView_Main setContentOffset:scrollPoint animated:YES];
    //     self.constratintViewContentHeight.constant = 517 + 245;
    
    CGRect textFieldRect = [self.view.window convertRect:textView.bounds fromView:textView];
    [self keyBordShow:textFieldRect];
    
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self.datePickerView setHidden:YES];
    if([textView.text  isEqual: @""])
    {
        textView.text = NSLocalizedString(@"payment_desc", nil);
        textView.textColor = UIColorFromRGB(0xb4bdf0);
    }
    //   self.constratintViewContentHeight.constant = 517;
    //   [self.scrollView_Main setContentOffset:CGPointMake(0, 0) animated:YES];
    
    [self keyBordHide];
}



-(void)touchesEnded:(NSSet *)__unused touches withEvent:(UIEvent *)__unused event{
    
    [self.view endEditing:YES];
    
}
-(void)keyBordShow:(CGRect)textFieldRect
{
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    
    CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
    
    CGFloat heightFraction = numerator / denominator;
    
    if (heightFraction < 0.0)
        heightFraction = 0.0;
    else if (heightFraction > 1.0)
        heightFraction = 1.0;
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
        animateHeight = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    
    CGRect viewFrame = self.view.frame;
    
    viewFrame.origin.y -= animateHeight;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
    
}
-(void)keyBordHide
{
    CGRect viewFrame = self.view.frame;
    
    viewFrame.origin.y += animateHeight;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}
-(void)keyBordClose
{
    [self.txtEmail resignFirstResponder];
    [self.txtName resignFirstResponder];
    [self.txtCvvNumber resignFirstResponder];
    [self.txtCardNumber resignFirstResponder];
    [self.txtAmount resignFirstResponder];
    [self.txtViewDescription resignFirstResponder];
}

-(void)textReset
{
    self.txtEmail.text = @"";
    self.txtName.text = @"";
    self.txtCardNumber.text = @"";
    self.txtAmount.text = @"";
    self.txtCvvNumber.text = @"";
    self.txtViewDescription.text = @"";
    [self.btnExpiryMonth setTitle:@"Month" forState:UIControlStateNormal];
    [self.btnExpiryYear setTitle:@"Year" forState:UIControlStateNormal];
}
#pragma mark Credit Card Number Formatting Methods

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField.tag == 1)
    {
        // Backspace
        if ([string length] == 0)
            return YES;
        
        if ((range.location == 4) || (range.location == 9) || (range.location == 14))
        {
            
            NSString *str    = [NSString stringWithFormat:@"%@-",textField.text];
            textField.text   = str;
        }
        
        if (textField.text.length >= 19 && range.length == 0)
            return NO;
        else
            return YES;
    }
    
    return YES;
    
}

# pragma mark UIPickerViewDataSource

//Columns in picker views

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
//Rows in each Column

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (self.isMonth == true) {
        return [arrMonth count];
    }
    else {
        return [arrYear count];
    }
}

# pragma mark UIPickerViewDelegate
// these methods return either a plain NSString, a NSAttributedString, or a view (e.g UILabel) to display the row for the component.
-(NSString*) pickerView:(UIPickerView*)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (self.isMonth == true) {
        
        [self.btnExpiryMonth setTitle:[arrMonth objectAtIndex:row] forState:UIControlStateNormal];
        return [arrMonth objectAtIndex:row];
        
    }
    else {
        [self.btnExpiryYear setTitle:[arrYear objectAtIndex:row] forState:UIControlStateNormal];
        return [arrYear objectAtIndex:row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (self.isMonth == true) {
        
        [self.btnExpiryMonth setTitle:[arrMonth objectAtIndex:row] forState:UIControlStateNormal];
    }
    else {
        [self.btnExpiryYear setTitle:[arrYear objectAtIndex:row] forState:UIControlStateNormal];
    }
}


#pragma mark IBAction Methods
- (IBAction)btnMonth_Click:(UIButton *)__unused sender {
    [self keyBordClose];
    //[self.scrollView_Main setContentOffset:CGPointMake(0, 100) animated:YES];
    self.isMonth = true;
    [self.datePickerView setHidden:NO];
    self.expiryDatePicker.delegate = self;
    self.expiryDatePicker.dataSource = self;
}

- (IBAction)btnYear_Click:(UIButton *)__unused sender {
    [self keyBordClose];
    //[self.scrollView_Main setContentOffset:CGPointMake(0, 100) animated:YES];
    self.isMonth = false;
    [self.datePickerView setHidden:NO];
    self.expiryDatePicker.delegate = self;
    self.expiryDatePicker.dataSource = self;
}

- (IBAction)btnDone_Click:(UIButton *)__unused sender {
    
    
    [self.datePickerView setHidden:YES];
}

- (IBAction)btnSendPayment_Click:(id)__unused sender {
    
    [self keyBordClose];
    
    //1
    // for Trim
    NSCharacterSet *strTrim      = [NSCharacterSet characterSetWithCharactersInString:@"-"];
    //NSString  *strTempcardNumber = [[self.txtCardNumber.text componentsSeparatedByCharactersInSet:strTrim] componentsJoinedByString:@""];
  //  NSString  *cardNumber        = [NSString stringWithFormat:@"%@",strTempcardNumber];
    
//    self.stripeCard          = [[STPCardParams alloc] init];
//    self.stripeCard.name     = self.txtName.text;
//    self.stripeCard.number   = cardNumber;
//    self.stripeCard.cvc      = self.txtCvvNumber.text;
//    self.stripeCard.expMonth = [self.btnExpiryMonth.titleLabel.text integerValue];
//    self.stripeCard.expYear  = [self.btnExpiryYear.titleLabel.text integerValue];
//    
    //2
    if ([self isDataValid]) {
        
        self.btnSendPayment.enabled = NO;
        
        //service call sendPayment
        if([DataModel sharedInstance].isInternetConnected)
            
            [self sendPayment];
        
        else
            [self showAlertMessageWithMessage:@"Connection error" mesage:NSLocalizedString(@"QM_STR_LOST_INTERNET_CONNECTION", nil)];
    }
    else
    {
        [self showAlertMessageWithMessage:@"" mesage:validationMessage];
    }
}

- (IBAction)handleTabGestureMethods:(UITapGestureRecognizer *)__unused sender {
    
    [self keyBordClose];
    [self.scrollView_Main setContentOffset:CGPointMake(0, 0) animated:YES];
}

#pragma mark Service Call
-(void)sendPayment
{
    [SVProgressHUD show];
    UserProfile *UP = [UserProfile new];
    
    // for Trim
    NSCharacterSet *strTrim      = [NSCharacterSet characterSetWithCharactersInString:@"-"];
    NSString  *strTempcardNumber = [[self.txtCardNumber.text componentsSeparatedByCharactersInSet:strTrim] componentsJoinedByString:@""];
    NSString  *cardNumber        = [NSString stringWithFormat:@"%@",strTempcardNumber];
    
    NSString *strQBUserId  = [NSString stringWithFormat:@"%lu",[QMCore instance].currentProfile.userData.ID];
    
    NSDictionary *RequestDataDictionary = @{
                                            @"QuickBlocxID"   :strQBUserId,
                                            @"TotalAmount"    :self.txtAmount.text,
                                            @"Description"    :self.txtViewDescription.text,
                                            @"CardNumber"     :cardNumber,
                                            @"Month"          :self.btnExpiryMonth.titleLabel.text,
                                            @"Year"           :self.btnExpiryYear.titleLabel.text,
                                            @"cvc"            :self.txtCvvNumber.text,
                                            };
    
    
    [UP sendPaymentWithSuccess:RequestDataDictionary withSuccess:^(NSDictionary *dictResult) {
        
        if(dictResult != nil)
        {
            UserDataController *userOBJ = [[UserDataController alloc]initWithDictionary:dictResult];
            APPDELEGATE.isIsEligible = [userOBJ.strIsEligible boolValue];
            
            NSData *userProfielData = [NSKeyedArchiver archivedDataWithRootObject:dictResult];
            [[DataModel sharedInstance]setProfileData:userProfielData];
        }
        [self showAlertMessageWithMessage:@"" mesage:@"Payment received successfully"];
        self.btnSendPayment.enabled = YES;
        
        [self textReset];
        [SVProgressHUD dismiss];
        
    } failure:^(NSError *__unused error) {
        
        [self showAlertMessageWithMessage:@"Error" mesage:CommanErrorMessage];
        [SVProgressHUD dismiss];
    }];
}

@end

//
//  DonateFundVC.h
//  LionsMessenger
//
//  Created by Administrator on 2/21/17.
//  Copyright © 2017 Quickblox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DonateFundVC : UIViewController

@property (weak, nonatomic) IBOutlet UILabel  *lblContact;
@property (weak, nonatomic) IBOutlet UILabel  *lblDescription;
@property (weak, nonatomic) IBOutlet UIButton *btnContactUs;
@property (weak, nonatomic) IBOutlet UIButton *btnPayViaCard;

- (IBAction)btnContactUs_Click:(UIButton *)sender;
- (IBAction)btnPAyViaCard_Click:(UIButton *)sender;


@end

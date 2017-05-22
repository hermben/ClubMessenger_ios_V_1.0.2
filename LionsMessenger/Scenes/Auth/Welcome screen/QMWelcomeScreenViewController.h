//
//  SplashControllerViewController.h
//  Q-municate
//
//  Created by Igor Alefirenko on 13/02/2014.
//  Copyright (c) 2014 Quickblox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QMCornerButton.h"

@interface QMWelcomeScreenViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lblAppName;

@property (weak, nonatomic) IBOutlet QMCornerButton *btnLogin;
@property (weak, nonatomic) IBOutlet QMCornerButton *btnSignup;

@end

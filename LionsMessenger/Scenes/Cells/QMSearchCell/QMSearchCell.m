//
//  QMContactCell.m
//  Q-municate
//
//  Created by Vitaliy Gorbachov on 3/1/16.
//  Copyright © 2016 Quickblox. All rights reserved.
//

#import "QMSearchCell.h"
#import "QMCore.h"
#import "QMContactManager.h"

@interface QMSearchCell ()

@property (weak, nonatomic) IBOutlet UIButton *addFriendButton;
@property (weak, nonatomic) QMCore <QMServiceManagerProtocol>*serviceManager;
@end

@implementation QMSearchCell

+ (CGFloat)height {
    
    return 50.0f;
}

#pragma mark - setters

- (void)setAddButtonVisible:(BOOL)visible {
    
    self.addFriendButton.hidden = !visible;
}
 
#pragma mark - action

- (IBAction)didTapAddButton {
    
   self.didAddUserBlock(self);
}

@end

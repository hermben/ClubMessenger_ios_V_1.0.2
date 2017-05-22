//
//  QMTableViewCell.m
//  LionsMessenger
//
//  Created by Administrator on 2/20/17.
//  Copyright © 2017 Quickblox. All rights reserved.
//

#import "ContactListCell.h"

@implementation ContactListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)add
{
//    QBUUser *user = [QBUUser user];
//    user.ID    = self.userID;
//    
//    __weak __typeof(self)weakSelf = self;
//    [[QBChat instance] addUserToContactListRequest:self.userID completion:^(NSError *error) {
//        __typeof(self) strongSelf = weakSelf;
//        
//        if (error == nil) {
//            
//            //            if ([strongSelf.cacheDataSource respondsToSelector:@selector(contactListDidAddUser:)]) {
//            //                [strongSelf.cacheDataSource contactListDidAddUser:user];
//            //            }
//            
//        }
//        else {
//            
//        }
//    }];
//    
//    
//    //    [[self.serviceManager.contactListService addUserToContactListRequest:user] continueWithSuccessBlock:^id _Nullable(BFTask * _Nonnull __unused task) {
//    //
//    //        NSLog(@"%@",@"TEST");
//    //        return nil;
//    //    }];

}
@end

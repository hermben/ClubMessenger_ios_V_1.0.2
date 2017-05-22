//
//  QMChatVC.h
//  Q-municate
//
//  Created by Vitaliy Gorbachov on 3/9/16.
//  Copyright © 2016 Quickblox. All rights reserved.
//

#import "QMChatViewController.h"
NS_ASSUME_NONNULL_BEGIN

/**
 *  Chat view controller.
 */
@interface QMChatVC : QMChatViewController

/**
 *  Chat dialog.
 */
@property (strong, nonatomic, nullable) QBChatDialog *chatDialog;
@property (strong, nonatomic) QBUUser *user;
/**
 *  Chat view controller with chat dialog.
 *
 *  @param chatDialog chat dialog
 *
 *  @return QMChatViewController new instance.
 */
+ (nullable instancetype)chatViewControllerWithChatDialog:(nullable QBChatDialog *)chatDialog;

@end
NS_ASSUME_NONNULL_END

//
//  ContactListVC.h
//  LionsMessenger
//
//  Created by Administrator on 2/20/17.
//  Copyright © 2017 Quickblox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactListVC : UIViewController

@property (copy, nonatomic) void (^didAddUserBlock)();

@property (weak, nonatomic) IBOutlet UITableView *tblContactsList;
@property (weak, nonatomic) IBOutlet UISearchBar *searchContacts;

@property (retain, nonatomic)NSMutableArray           *arrContactsList;
@property (retain, nonatomic)NSMutableArray           *arrSearchContactsList;

@property (strong, nonatomic)NSString                 *strGroupID;
@property (strong, nonatomic)NSString                 *strSubGroupID;

#pragma mark NSLayout Property

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constratintSerchBarTop;
@end

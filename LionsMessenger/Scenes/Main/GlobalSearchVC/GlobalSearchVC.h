//
//  GlobalSearchVC.h
//  LionsMessenger
//
//  Created by Administrator on 2/15/17.
//  Copyright © 2017 Quickblox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserDataController.h"

@interface GlobalSearchVC : UIViewController



@property (weak, nonatomic) IBOutlet UINavigationItem *NavigationTitle;
@property (weak, nonatomic) IBOutlet UITableView      *tblGroupList;

@property (weak, nonatomic) IBOutlet UISearchBar      *searchBar;
@property (retain, nonatomic)NSMutableArray           *arrGroupsList;
@property (retain, nonatomic)NSMutableArray           *arrSearchGroupsList;
@property (assign,nonatomic)BOOL                      isClubs;
@property (assign,nonatomic)BOOL                      isFromSignUp;
@property (assign,nonatomic)BOOL                      isFromFBSignUp;

@property (strong, nonatomic)NSString                 *strSubGroupID;
@property (strong, nonatomic)UserDataController       *userOBJ;
@property (strong, nonatomic)NSIndexPath              *indexPath;

@property (retain, nonatomic)NSMutableArray           *arrUserList;


#pragma mark NSLayout Property
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTblBottamView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constratintSerchBarTop;

@end

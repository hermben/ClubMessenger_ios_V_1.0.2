//
//  GlobalSearchVC.m
//  LionsMessenger
//
//  Created by Administrator on 2/15/17.
//  Copyright © 2017 Quickblox. All rights reserved.
//

#import "GlobalSearchVC.h"
#import "QMSearchResultsController.h"
#import "QMGlobalSearchDataSource.h"
#import "ContactListVC.h"

#import "QMCore.h"
#import "QMTasks.h"
#import "QMAlert.h"

#import "UserProfile.h"
#import "QMConstants.h"
#import "UserDataController.h"
#import "GroupsCell.h"
#import "QMNoResultsCell.h"

@interface GlobalSearchVC ()<UISearchBarDelegate, UISearchDisplayDelegate,UIGestureRecognizerDelegate>

@property (weak, nonatomic) BFTask *addUserTask;

@end

@implementation GlobalSearchVC

#pragma mark View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationMenu];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self Initialization];
    
    if(self.isFromFBSignUp == true)
    {
        self.navigationItem.hidesBackButton = true;
    }
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.isClubs = false;
}
-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    if(self.isFromSignUp == true || self.isFromFBSignUp == true)
    {
        self.constraintTblBottamView.constant = 0;
    }
    else
    {
        self.constraintTblBottamView.constant = 49;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark Private Methods
-(void)Initialization
{
    
    if (self.isFromSignUp == true || self.isFromFBSignUp == true)
    {
        if(self.isClubs == true)
        {
            self.isClubs = true;
            self.NavigationTitle.title = NSLocalizedString(@"str_club", nil);
            
            //service call get All Sub Groups
            if([DataModel sharedInstance].isInternetConnected)
                
                [self getAllSubGroups];
            
            else
               [self showAlertMessageWithMessage:@"Connection error" mesage:NSLocalizedString(@"QM_STR_LOST_INTERNET_CONNECTION", nil)];        }
        
        else
        {
           self.NavigationTitle.title = NSLocalizedString(@"str_district", nil);
            
            //service call get All Groups
            if([DataModel sharedInstance].isInternetConnected)
                
                [self getAllGroups];
            
            else
                [self showAlertMessageWithMessage:@"Connection error" mesage:NSLocalizedString(@"QM_STR_LOST_INTERNET_CONNECTION", nil)];
            
            
        }
        
    }
    else if([[DataModel sharedInstance]isExtendSearch] == false)
    {
        self.isClubs = true;
        self.NavigationTitle.title = NSLocalizedString(@"str_club", nil);
        
        //service call get All Sub Groups
        if([DataModel sharedInstance].isInternetConnected)
            
            [self getAllSubGroups];
        
        else
           [self showAlertMessageWithMessage:@"Connection error" mesage:NSLocalizedString(@"QM_STR_LOST_INTERNET_CONNECTION", nil)];
    }
    else
    {
        if(self.isClubs == true)
        {
            self.isClubs = true;
            self.NavigationTitle.title = NSLocalizedString(@"str_club", nil);
            
            //service call get All Sub Groups
            if([DataModel sharedInstance].isInternetConnected)
                
                [self getAllSubGroups];
            
            else
                [self showAlertMessageWithMessage:@"Connection error" mesage:NSLocalizedString(@"QM_STR_LOST_INTERNET_CONNECTION", nil)];
        }
        
        else
        {
            
            self.NavigationTitle.title = NSLocalizedString(@"str_district", nil);
            
            //service call get All Groups
            if([DataModel sharedInstance].isInternetConnected)
                
                [self getAllGroups];
            
            else
                [self showAlertMessageWithMessage:@"Connection error" mesage:NSLocalizedString(@"QM_STR_LOST_INTERNET_CONNECTION", nil)];
            
            
        }

//        self.NavigationTitle.title = NSLocalizedString(@"str_district", nil);
//        
//        //service call get All Groups
//        if([DataModel sharedInstance].isInternetConnected)
//            
//            [self getAllGroups];
//        
//        else
//           [self showAlertMessageWithMessage:@"Connection error" mesage:NSLocalizedString(@"QM_STR_LOST_INTERNET_CONNECTION", nil)];
//        
        
    }
    if (self.isFromSignUp == false && self.isFromFBSignUp == false)
    {
        UILongPressGestureRecognizer *tblLongPressGestuer = [[UILongPressGestureRecognizer alloc]
                                                             initWithTarget:self action:@selector(handleLongPressGestureMethods:)];
        tblLongPressGestuer.minimumPressDuration = 1.0; //seconds
        tblLongPressGestuer.delegate = self;
        [self.tblGroupList addGestureRecognizer:tblLongPressGestuer];
    }
    
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

-(void)setNavigationMenu
{
    [self.navigationController.navigationBar setBackgroundColor:RGBCommanColor];
    [self.navigationController.navigationBar setBarTintColor:RGBCommanColor];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor blackColor],
       NSFontAttributeName:[UIFont systemFontOfSize:17.0]}];
    
}

#pragma mark - UISearchControllerDelegate


- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)__unused searchBar
{
    self.searchBar.showsCancelButton = true;
   
    [UIView animateWithDuration:0.3f animations:^{
        
        // Make all constraint changes here
        
        self.constratintSerchBarTop.constant = 22;
        
        [self.view layoutIfNeeded]; // Forces the layout of the subtree animation block and then captures all of the frame changes
        
    }];

    [self.navigationController setNavigationBarHidden:YES];
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)__unused searchText
{
    
    if(searchText.length == 0)
    {
        self.arrSearchGroupsList = [[NSMutableArray alloc]init];
        [self.arrSearchGroupsList addObjectsFromArray:self.arrGroupsList];
        
        [self.tblGroupList reloadData];
    }
    else
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"strGroupName CONTAINS[cd] %@", searchText];
        NSArray *results = [self.arrGroupsList filteredArrayUsingPredicate:predicate];
        
        self.arrSearchGroupsList = [[NSMutableArray alloc]init];
        [self.arrSearchGroupsList addObjectsFromArray:results];
        [self.tblGroupList reloadData];
    }
    
    
}

-(void)touchesEnded:(NSSet *)__unused touches withEvent:(UIEvent *)__unused event{
    
    [self.searchBar resignFirstResponder];
    [self.view endEditing:YES];
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)__unused searchBar
{
    
    [UIView animateWithDuration:0.3f animations:^{
        // Make all constraint changes here
         self.constratintSerchBarTop.constant = 64;
        [self.navigationController setNavigationBarHidden:NO];
        [self.view layoutIfNeeded]; // Forces the layout of the subtree animation block and then captures all of the frame changes
        
    }];
   
     self.searchBar.text = @"";
     self.searchBar.showsCancelButton = false;
     [self.searchBar resignFirstResponder];

}
#pragma mark - TableView Delegate & Datasource Method

- (CGFloat)tableView:(UITableView *)__unused tableView heightForRowAtIndexPath:(NSIndexPath *)__unused indexPath {
    
    if(self.arrSearchGroupsList.count > 0)
    {
        return 40;
    }
    else
    {
        return 450;
    }
}

- (NSInteger)tableView:(UITableView *)__unused tableView numberOfRowsInSection:(NSInteger)__unused section
{
    if(self.arrSearchGroupsList.count > 0)
    {
        return self.arrSearchGroupsList.count;
    }
    else
    {
        return 1;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)__unused tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.arrSearchGroupsList.count > 0)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"GroupsCell" owner:self options:nil];
        GroupsCell *cell = [nib objectAtIndex:0];
        UserDataController *obj = [self.arrSearchGroupsList objectAtIndex:indexPath.row];
        
        cell.lblGroupName.text  = obj.strGroupName;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    else
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"QMNoResultsCell" owner:self options:nil];
        QMNoResultsCell *cell = [nib objectAtIndex:0];
        
        return cell;
    }
    
}

- (void)tableView:(UITableView *)__unused tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.isFromSignUp == true)
    {
        UserDataController *obj = [self.arrSearchGroupsList objectAtIndex:indexPath.row];
        
        
        if(self.isClubs == true)
        {
            _userOBJ.strSubGroupID = obj.strGroupID;
            _userOBJ.strSubGroupName = obj.strGroupName;
            _userOBJ.isBack = true;
        }
        else
        {
            _userOBJ.isBack = true;
            _userOBJ.strGroupID = obj.strGroupID;
            _userOBJ.strGroupName = obj.strGroupName;
            APPDELEGATE.strGroupID = obj.strGroupID;
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    else if(self.isFromFBSignUp == true)
    {
        UserDataController *obj = [self.arrSearchGroupsList objectAtIndex:indexPath.row];
        
        
        if(self.isClubs == true)
        {
            self.strSubGroupID = obj.strGroupID;
            
            
            //service call Register user
            if([DataModel sharedInstance].isInternetConnected)
                
                [self registration];
            
            else
                [self showAlertMessageWithMessage:@"Connection error" mesage:NSLocalizedString(@"QM_STR_LOST_INTERNET_CONNECTION", nil)];
            
        }
        else
        {
            self.isClubs = true;
            APPDELEGATE.strGroupID = obj.strGroupID;
            
            self.NavigationTitle.title = NSLocalizedString(@"str_club", nil);
            
            self.navigationItem.hidesBackButton = false;
            
            //service call get All Sub Groups
            if([DataModel sharedInstance].isInternetConnected)
                
                [self getAllSubGroups];
            
            else
                [self showAlertMessageWithMessage:@"Connection error" mesage:NSLocalizedString(@"QM_STR_LOST_INTERNET_CONNECTION", nil)];
            
            
            
        }
        
    }
    else if ([[DataModel sharedInstance]isExtendSearch] == true)
    {
        
        UserDataController *obj = [self.arrSearchGroupsList objectAtIndex:indexPath.row];
        
        
        if(self.isClubs == true)
        {
            ContactListVC *clVC = (ContactListVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"ContactListVCID"];
            clVC.hidesBottomBarWhenPushed = YES;
            clVC.strSubGroupID  = obj.strGroupID;
            [self.navigationController pushViewController:clVC animated:YES];
            
        }
        else
        {
            APPDELEGATE.strGroupID = obj.strGroupID;
            self.isClubs = true;
            //service call get All Sub Groups
            if([DataModel sharedInstance].isInternetConnected)
                
                [self getAllSubGroups];
            
            else
                [self showAlertMessageWithMessage:@"Connection error" mesage:NSLocalizedString(@"QM_STR_LOST_INTERNET_CONNECTION", nil)];
//            GlobalSearchVC *gsVC = (GlobalSearchVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"GlobalSearchID"];
//            gsVC.isClubs = true;
//            APPDELEGATE.strGroupID = obj.strGroupID;
//            [self.navigationController pushViewController:gsVC animated:YES];
        }
        
    }
    else
    {
        UserDataController *obj = [self.arrSearchGroupsList objectAtIndex:indexPath.row];
        if(self.isClubs == true)
        {
            
            ContactListVC *clVC = (ContactListVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"ContactListVCID"];
            clVC.hidesBottomBarWhenPushed = YES;
            clVC.strSubGroupID  = obj.strGroupID;
            [self.navigationController pushViewController:clVC animated:YES];
            
        }
    }
    
}

-(void)handleLongPressGestureMethods:(UILongPressGestureRecognizer *)gestureRecognizer
{
    CGPoint point = [gestureRecognizer locationInView:self.tblGroupList];
    
    NSIndexPath *indexPath = [self.tblGroupList indexPathForRowAtPoint:point];
    if (indexPath == nil) {
        NSLog(@"long press on table view but not on a row");
    } else if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"long press on table view at row %ld", indexPath.row);
        
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"QM_STR_FRIEND_REQUEST_ADD_ALL",nil) message:NSLocalizedString(@"QM_STR_FRIEND_REQUEST_DID_SEND_FOR_ALL",nil) preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:^(UIAlertAction *__unused action) {
            
        }];
        
        UIAlertAction *actionYes = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction *__unused action) {
            
            UserDataController *obj = [self.arrSearchGroupsList objectAtIndex:indexPath.row];
            
            if(self.isClubs == true)
            {
                self.strSubGroupID = obj.strGroupID;
                
                //service call get All Sub Groups
                if([DataModel sharedInstance].isInternetConnected)
                    
                    [self getUserBySubGroup];
                
                else
                    [self showAlertMessageWithMessage:@"Connection error" mesage:NSLocalizedString(@"QM_STR_LOST_INTERNET_CONNECTION", nil)];
            }
            else
            {
                APPDELEGATE.strGroupID = obj.strGroupID;
                //service call get All Groups
                if([DataModel sharedInstance].isInternetConnected)
                    
                    [self getUserByGroup];
                
                else
                     [self showAlertMessageWithMessage:@"Connection error" mesage:NSLocalizedString(@"QM_STR_LOST_INTERNET_CONNECTION", nil)];
            }
            
            
        }];
        
        [alertVc addAction:actionCancel];
        [alertVc addAction:actionYes];
        [self presentViewController:alertVc animated:YES completion:nil];
        
        
        
    } else {
        NSLog(@"gestureRecognizer.state = %ld", gestureRecognizer.state);
    }
}

#pragma mark Service CAll
-(void)getAllGroups
{
    
    [SVProgressHUD show];
    
    UserProfile *UP = [UserProfile new];
    
    [UP getAllGroupsWithSuccess:^(NSDictionary *dictResult) {
        
        
        
        self.arrGroupsList = [[NSMutableArray alloc]init];
        self.arrSearchGroupsList = [[NSMutableArray alloc]init];
        
        for ( NSDictionary *obj in dictResult) {
            
            UserDataController *UDC = [[UserDataController alloc]init];
            
            UDC.strGroupID  = [NSString stringWithFormat:@"%@", [obj objectForKey:@"GroupID"]];
            UDC.strGroupName    = [NSString stringWithFormat:@"%@", [obj objectForKey:@"GroupName"]];
            
            [UDC avoidNullValues];
            
            [self.arrGroupsList addObject:UDC];
        }
        
        [self.arrSearchGroupsList addObjectsFromArray:self.arrGroupsList];
        [self.tblGroupList reloadData];
        
        [SVProgressHUD dismiss];
        
    } failure:^(NSError *__unused error) {
        
        [self showAlertMessageWithMessage:@"Error" mesage:CommanErrorMessage];
        [SVProgressHUD dismiss];
    }];
}


-(void)getAllSubGroups
{
    
    [SVProgressHUD show];
    
    UserProfile *UP = [UserProfile new];
    
    [UP getAllSubGroupsWithSuccess: APPDELEGATE.strGroupID withSuccess:^(NSDictionary *dictResult) {
        
        [self.navigationController setNavigationBarHidden:NO];
        self.arrGroupsList = [[NSMutableArray alloc]init];
        self.arrSearchGroupsList = [[NSMutableArray alloc]init];
        
        for ( NSDictionary *obj in dictResult) {
            
            UserDataController *UDC = [[UserDataController alloc]init];
            
            UDC.strGroupID  = [NSString stringWithFormat:@"%@", [obj objectForKey:@"SubGroupID"]];
            UDC.strGroupName    = [NSString stringWithFormat:@"%@", [obj objectForKey:@"SubGroupName"]];
            
            [UDC avoidNullValues];
            
            [self.arrGroupsList addObject:UDC];
        }
        
        [self.arrSearchGroupsList addObjectsFromArray:self.arrGroupsList];
        [self.tblGroupList reloadData];
        
        [SVProgressHUD dismiss];
        
    } failure:^(NSError *__unused error) {
        
        [self showAlertMessageWithMessage:@"Error" mesage:CommanErrorMessage];
        [SVProgressHUD dismiss];
    }];
}

-(void)registration
{
    
    UserProfile *UP = [UserProfile new];
    NSString *strQBUserId  = [NSString stringWithFormat:@"%lu",[QMCore instance].currentProfile.userData.ID];
    NSString *strProImage  = [NSString stringWithFormat:@"%@",[QMCore instance].currentProfile.userData.avatarUrl];
    NSString *strFullName  = [NSString stringWithFormat:@"%@",[QMCore instance].currentProfile.userData.fullName];
    NSString *strEmail     = [NSString stringWithFormat:@"%@",[QMCore instance].currentProfile.userData.email];
    NSString *strBlobID    = [NSString stringWithFormat:@"%ld",[QMCore instance].currentProfile.userData.blobID];
    
    NSDictionary *RequestDataDictionary = @{
                                            @"Name"           :strFullName,
                                            @"Email"          :strEmail,
                                            @"Password"       :@"123456789",
                                            @"Picture"        :strProImage,
                                            @"BirthDate"      :@"",
                                            @"GroupMultiple"  :@"",
                                            @"PresentTitle"   :@"",
                                            @"Phone"          :@"",
                                            @"Achivements"    :@"",
                                            @"Career"         :@"",
                                            @"City"           :@"",
                                            @"State"          :@"",
                                            @"Country"        :@"",
                                            @"GroupID"        :APPDELEGATE.strGroupID,
                                            @"SubGroupID"     :self.strSubGroupID,
                                            @"BlobID"         :strBlobID,
                                            @"QuickbloxUserID":strQBUserId,
                                            @"FbID"           :APPDELEGATE.strFBID,
                                            };
    
    
    [UP registerUserWithSuccess:RequestDataDictionary withSuccess:^(NSDictionary *dictResult) {
        
        UserDataController *userOBJ = [[UserDataController alloc]initWithDictionary:dictResult];
       
        [[DataModel sharedInstance]setUserID:userOBJ.strUserId];
        [DataModel sharedInstance].objUser  = userOBJ;
        NSData *userProfielData = [NSKeyedArchiver archivedDataWithRootObject:dictResult];
        [[DataModel sharedInstance]setProfileData:userProfielData];
        
        [self performSegueWithIdentifier:kQMSceneSegueMain sender:nil];
        
        [SVProgressHUD dismiss];
        
    } failure:^(NSError *__unused error) {
        
        [self showAlertMessageWithMessage:@"Error" mesage:CommanErrorMessage];
        [SVProgressHUD dismiss];
    }];
}


-(void)getUserByGroup
{
    
    [SVProgressHUD show];
    
    UserProfile *UP = [UserProfile new];
    
    NSString *strQBUserId  = [NSString stringWithFormat:@"%lu",[QMCore instance].currentProfile.userData.ID];
    NSDictionary *RequestDataDictionary = @{
                                            @"GroupID"         :APPDELEGATE.strGroupID,
                                            @"UserID"          :strQBUserId,
                                            };
    [UP getUserByGroupWithSuccess:RequestDataDictionary withSuccess:^(NSDictionary *dictResult) {
        
        [self handleUserListData:dictResult];
        
    } failure:^(NSError *__unused error) {
        
        [self showAlertMessageWithMessage:@"Error" mesage:CommanErrorMessage];
        [SVProgressHUD dismiss];
    }];
}

-(void)getUserBySubGroup
{
    
    [SVProgressHUD show];
    
    UserProfile *UP = [UserProfile new];
    
    NSString *strQBUserId  = [NSString stringWithFormat:@"%lu",[QMCore instance].currentProfile.userData.ID];
    NSDictionary *RequestDataDictionary = @{
                                            @"GroupID"         :self.strSubGroupID,
                                            @"UserID"          :strQBUserId,
                                            };
    [UP getUserBySubGroupWithSuccess:RequestDataDictionary withSuccess:^(NSDictionary *dictResult) {
        
        [self handleUserListData:dictResult];
        
    } failure:^(NSError *__unused error) {
        
        [self showAlertMessageWithMessage:@"Error" mesage:CommanErrorMessage];
        [SVProgressHUD dismiss];
    }];
}

-(void)handleUserListData:(NSDictionary *)dictResult
{
    self.arrUserList = [[NSMutableArray alloc]init];
    
    for ( NSDictionary *obj in dictResult) {
        
        UserDataController *UDC = [[UserDataController alloc]init];
        
        UDC.strUserId           = [NSString stringWithFormat:@"%@", [obj objectForKey:@"UserID"]];
        UDC.strFullName         = [NSString stringWithFormat:@"%@", [obj objectForKey:@"Fullname"]];
        UDC.strEmail            = [NSString stringWithFormat:@"%@", [obj objectForKey:@"Email"]];
        UDC.strProfileImage     = [NSString stringWithFormat:@"%@", [obj objectForKey:@"Picture"]];
        UDC.strPhoneNo          = [NSString stringWithFormat:@"%@", [obj objectForKey:@"Phone"]];
        UDC.strLionsTitle       = [NSString stringWithFormat:@"%@", [obj objectForKey:@"PresentTitle"]];
        UDC.strDistrict         = [NSString stringWithFormat:@"%@", [obj objectForKey:@"GroupMultiple"]];
        UDC.strAchievement      = [NSString stringWithFormat:@"%@", [obj objectForKey:@"Achivements"]];
        UDC.strDOB              = [NSString stringWithFormat:@"%@", [obj objectForKey:@"BirthDate"]];
        UDC.strCareer           = [NSString stringWithFormat:@"%@", [obj objectForKey:@"Career"]];
        UDC.strCity             = [NSString stringWithFormat:@"%@", [obj objectForKey:@"City"]];
        UDC.strState            = [NSString stringWithFormat:@"%@", [obj objectForKey:@"State"]];
        UDC.strCountry          = [NSString stringWithFormat:@"%@", [obj objectForKey:@"Country"]];
        UDC.strGroupID          = [NSString stringWithFormat:@"%@", [obj objectForKey:@"GroupID"]];
        UDC.strSubGroupID       = [NSString stringWithFormat:@"%@", [obj objectForKey:@"SubGroupID"]];
        UDC.strBlobID           = [NSString stringWithFormat:@"%@", [obj objectForKey:@"BlobID"]];
        UDC.strQuickbloxUserID  = [NSString stringWithFormat:@"%@", [obj objectForKey:@"QuickbloxUserID"]];
        UDC.strCreatedDate      = [NSString stringWithFormat:@"%@", [obj objectForKey:@"CreatedDate"]];
        UDC.strUpdatedDate      = [NSString stringWithFormat:@"%@", [obj objectForKey:@"UpdatedDate"]];
        
        
        [UDC avoidNullValues];
        NSString *strQBUserId  = [NSString stringWithFormat:@"%lu",[QMCore instance].currentProfile.userData.ID];
        if(UDC.strFullName.length > 0 && UDC.strQuickbloxUserID != strQBUserId)
        {
            [self.arrUserList addObject:UDC];
        }
    }
    
    if(self.arrUserList.count > 0)
    {
        [self sendRequest];
    }
    [SVProgressHUD dismiss];
}

-(void)sendRequest
{
    NSLog(@"%lu", (unsigned long)self.arrUserList.count);
    for (unsigned long i = 0; i < self.arrUserList.count; i++) {
        
        UserDataController *obj = [self.arrUserList objectAtIndex:i];
        
        QBUUser *user = [QBUUser user];
        user.ID       = [obj.strQuickbloxUserID integerValue];
        user.fullName = obj.strFullName;
        
        /* @weakify(self);
         
         @strongify(self);
         if (self.addUserTask) {
         // task in progress
         return;
         }*/
        self.addUserTask = [[[QMCore instance].contactManager addUserToContactList:user] continueWithBlock:^id _Nullable(BFTask * _Nonnull task) {
            
            if (!task.isFaulted) {
                
                
            }
            else {
                
                switch ([QMCore instance].chatService.chatConnectionState) {
                        
                    case QMChatConnectionStateDisconnected:
                    case QMChatConnectionStateConnected:
                        
                        if ([[QMCore instance] isInternetConnected]) {
                            
                            //[QMAlert showAlertWithMessage:NSLocalizedString(@"QM_STR_CHAT_SERVER_UNAVAILABLE", nil) actionSuccess:NO inViewController:self];
                        }
                        else {
                            
                            [QMAlert showAlertWithMessage:NSLocalizedString(@"QM_STR_CHECK_INTERNET_CONNECTION", nil) actionSuccess:NO inViewController:self];
                        }
                        break;
                        
                    case QMChatConnectionStateConnecting:
                        [QMAlert showAlertWithMessage:NSLocalizedString(@"QM_STR_CONNECTION_IN_PROGRESS", nil) actionSuccess:NO inViewController:self];
                        break;
                }
            }
            
            return nil;
        }];
    }
    [KSToastView ks_showToast:NSLocalizedString(@"QM_STR_FRIEND_REQUEST_DID_SEND_FOR_ME",nil) duration:2.0f];
    
}
@end

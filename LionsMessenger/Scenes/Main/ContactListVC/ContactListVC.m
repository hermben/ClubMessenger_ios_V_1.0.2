//
//  ContactListVC.m
//  LionsMessenger
//
//  Created by Administrator on 2/20/17.
//  Copyright © 2017 Quickblox. All rights reserved.
//

#import "ContactListVC.h"
#import "UserProfile.h"
#import "UserDataController.h"
#import "QMConstants.h"
#import "QMSearchCell.h"
#import "QMNoContactsCell.h"
#import "ContactListCell.h"

#import "QMCore.h"
#import "QMTasks.h"
#import "QMAlert.h"

@interface ContactListVC ()
{
    
}
@property (weak, nonatomic) BFTask *addUserTask;
@end

@implementation ContactListVC

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

#pragma mark Private Methods
-(void)Initialization
{
    [self setNavigationMenu];
    
        //service call get USer By Sub Groups
        if([DataModel sharedInstance].isInternetConnected)
            
            [self getUserBySubGroup];
        
        else
            [self showAlertMessageWithMessage:@"Connection error" mesage:NSLocalizedString(@"QM_STR_LOST_INTERNET_CONNECTION", nil)];    
    
    // setting up data source
    [self configureDataSources];
    
    
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
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.title = @"Contact List";
    [self.navigationController.navigationBar setBackgroundColor:RGBCommanColor];
    [self.navigationController.navigationBar setBarTintColor:RGBCommanColor];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor blackColor],
       NSFontAttributeName:[UIFont systemFontOfSize:17.0]}];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = true;
    
    
    [UIView animateWithDuration:0.3f animations:^{
        
        [self.navigationController setNavigationBarHidden:YES];
        // Make all constraint changes here
        self.constratintSerchBarTop.constant = 22;
        [self.view layoutIfNeeded]; // Forces the layout of the subtree animation block and then captures all of the frame changes
        
    }];
    
    return YES;
}

- (void)searchBar:(UISearchBar *)__unused searchBar textDidChange:(NSString *)searchText
{
    if(searchText.length == 0)
    {
        self.arrSearchContactsList = [[NSMutableArray alloc]init];
        [self.arrSearchContactsList addObjectsFromArray:self.arrContactsList];
        
        [self.tblContactsList reloadData];
    }
    else
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"strFullName CONTAINS[cd] %@", searchText];
        NSArray *results = [self.arrContactsList filteredArrayUsingPredicate:predicate];
        
        self.arrSearchContactsList = [[NSMutableArray alloc]init];
        [self.arrSearchContactsList addObjectsFromArray:results];
        [self.tblContactsList reloadData];
    }
    
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    
    [UIView animateWithDuration:0.3f animations:^{
        // Make all constraint changes here
        self.constratintSerchBarTop.constant = 64;
        [self.navigationController setNavigationBarHidden:NO];
        [self.view layoutIfNeeded]; // Forces the layout of the subtree animation block and then captures all of the frame changes
        
    }];
    searchBar.text = @"";
    searchBar.showsCancelButton = false;
    [searchBar resignFirstResponder];
    
}
- (void)configureDataSources {

    @weakify(self);
    self.self.didAddUserBlock = ^(UITableViewCell *cell) {
        
        @strongify(self);
        if (self.addUserTask) {
            // task in progress
            return;
        }
        
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        
        NSIndexPath *indexPath = [self.tblContactsList indexPathForCell:cell];
        UserDataController *obj = [self.arrSearchContactsList objectAtIndex:indexPath.row];
        QBUUser *user = [QBUUser user];
        user.ID = [obj.strQuickbloxUserID integerValue];
        user.fullName = obj.strFullName;
        

        self.addUserTask = [[[QMCore instance].contactManager addUserToContactList:user] continueWithBlock:^id _Nullable(BFTask * _Nonnull task) {
            
            [SVProgressHUD dismiss];
            
            if (!task.isFaulted) {
                
               // && self.searchController.isActive
              //  && [self.searchResultsController.tableView.dataSource conformsToProtocol:@protocol(QMGlobalSearchDataSourceProtocol)]
               // [self.searchResultsController.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                /// show NSObject description with 2 seconds.
                [KSToastView ks_showToast:NSLocalizedString(@"QM_STR_FRIEND_REQUEST_DID_SEND_FOR_ME",nil) duration:2.0f];
            }
            else {
                
                switch ([QMCore instance].chatService.chatConnectionState) {
                        
                    case QMChatConnectionStateDisconnected:
                    case QMChatConnectionStateConnected:
                        
                        if ([[QMCore instance] isInternetConnected]) {
                            
                            [QMAlert showAlertWithMessage:NSLocalizedString(@"QM_STR_CHAT_SERVER_UNAVAILABLE", nil) actionSuccess:NO inViewController:self];
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
    };
}

#pragma mark - TableView Delegate & Datasource Method

- (CGFloat)tableView:(UITableView *)__unused tableView heightForRowAtIndexPath:(NSIndexPath *)__unused indexPath {
    
    if(self.arrSearchContactsList.count > 0)
    {
        return 50;
    }
    else
    {
        return 450;
    }
}

- (NSInteger)tableView:(UITableView *)__unused tableView numberOfRowsInSection:(NSInteger)__unused section
{
    if(self.arrSearchContactsList.count > 0)
    {
        return self.arrSearchContactsList.count;
    }
    else
    {
        return 1;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)__unused tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.arrSearchContactsList.count > 0)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"QMSearchCell" owner:self options:nil];
        QMSearchCell *cell = [nib objectAtIndex:0];
        
        UserDataController *obj = [self.arrSearchContactsList objectAtIndex:indexPath.row];
        
         NSInteger  userId = [obj.strQuickbloxUserID integerValue];
        
         [cell setTitle:obj.strFullName placeholderID:userId avatarUrl:obj.strProfileImage];
        
       
        [cell setAddButtonVisible:YES];
        
      
        cell.userID = userId;
        
        cell.didAddUserBlock = self.didAddUserBlock;

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    else
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"QMNoContactsCell" owner:self options:nil];
        QMNoContactsCell *cell = [nib objectAtIndex:0];
        [cell setTitle:NSLocalizedString(@"QM_STR_NO_CONTACTS", nil)];
        
        return cell;
    }
    
}

//- (void)tableView:(UITableView *)__unused tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//}

#pragma mark Service CAll
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
    
        
        self.arrContactsList = [[NSMutableArray alloc]init];
        self.arrSearchContactsList = [[NSMutableArray alloc]init];
        
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
            if( UDC.strFullName.length > 0)
            {
               [self.arrContactsList addObject:UDC];
            }
        }
        
        [self.arrSearchContactsList addObjectsFromArray:self.arrContactsList];
        [self.tblContactsList reloadData];

       
        
        [SVProgressHUD dismiss];
        
    } failure:^(NSError *__unused error) {
        
        [self showAlertMessageWithMessage:@"Error" mesage:CommanErrorMessage];
        [SVProgressHUD dismiss];
    }];
}


@end

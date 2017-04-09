//
//  CNConnectionsVC.m
//  Connect
//
//  Created by Daniel on 30/01/2017.
//  Copyright © 2017 Connect Social Network. All rights reserved.
//

#import "CNConnectionsVC.h"
#import "CNConnectionsCell.h"
#import "CNProfileViewController.h"
#import "CNUserVC.h"
#import "CNNotificationVC.h"
#import "MIBadgeButton.h"


@interface CNConnectionsVC () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (strong, nonatomic) MIBadgeButton *badgeButton;


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constOfTableViewBottom;

@property (strong, nonatomic) FIRDatabaseReference *userRef;
@property (strong, nonatomic) FIRDatabaseReference *connectionRef;

@property (strong, nonatomic) NSArray *connections;
@property (nonatomic, strong) NSMutableDictionary *connectionsData;
@property (strong, nonatomic) NSArray *connectionTitles;

@end

@implementation CNConnectionsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self configureLayout];
    [self setupNavTitle];
    [self loadConnection];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillHideNotification object:nil];
}


- (void)viewWillDisappear:(BOOL)animated {
    [self.view endEditing:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helpers

- (void) setupNavTitle{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    label.text = @"GRIP";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = TextAlignmentCenter;
    
    self.navigationItem.titleView = label;
}


- (void)configureLayout {
    // Configure view
    self.navigationController.navigationBar.barTintColor = kAppTintColor;
    
    self.tableView.sectionIndexColor = [UIColor blackColor];
    self.tableView.sectionIndexBackgroundColor = UIColorFromRGB(0xFAFAFA);
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView registerNib:[UINib nibWithNibName:@"CNConnectionsCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
}


- (void)keyboardChange:(NSNotification *)notification {
    // animate view when keyboard shows/hides
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    //adjust ChatTableView's height
    if (notification.name == UIKeyboardWillShowNotification) {
        self.constOfTableViewBottom.constant = keyboardEndFrame.size.height - kBottomBarHeight;
    } else {
        self.constOfTableViewBottom.constant = 0;
    }
    
    [self.view layoutIfNeeded];
    
    [UIView commitAnimations];
    
}

- (void)loadConnection {
    
//    if (_connections != nil) {
//        [self startSearchWithString:self.searchBar.text];
//        return;
//    }
    self.connectionRef = [[[AppDelegate sharedInstance].dbRef child:@"connections"] child:[CNUser currentUser].userID];
    self.userRef = [[AppDelegate sharedInstance].dbRef child:@"users"];

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [_connectionRef observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {

        self.connections = [[NSMutableArray alloc] init];

        [MBProgressHUD hideHUDForView:self.view animated:YES];

        if (![snapshot.value isEqual:[NSNull null]]) {
            NSDictionary *value = snapshot.value;
            
            [CNUser currentUser].connectionId = [[NSMutableArray alloc] init];
            NSMutableArray *array = [[NSMutableArray alloc] init];
            
            for(int i = 0 ; i < value.allKeys.count; i ++){
                
                NSString *userID = [value.allKeys objectAtIndex:i];
                [[CNUser currentUser].connectionId addObject:userID];
                
                [[self.userRef child:userID] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                    NSLog(@"%@", snapshot.value);
                    NSDictionary *value1 = snapshot.value;
                    [array addObject:value1];
                    
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        [self showConnections];
                    });
                    
                }];
                
            }
            self.connections = array;

            
        } else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self showConnections];
            });
        }

    }];
}

- (void)showConnections{
    self.connectionsData = [NSMutableDictionary new];
    
    
    for (NSDictionary *object in self.connections) {
        NSString *name = [NSString stringWithFormat:@"%@ %@", object[@"firstName"], object[@"lastName"]];
        
        
        NSString *firstLetter = [[name substringToIndex:1] uppercaseString];
        NSMutableArray *array = [self.connectionsData objectForKey:firstLetter];
        
        if (array == nil) {
            array = [NSMutableArray array];
            [self.connectionsData setObject:array forKey:firstLetter];
        }
        
        [array addObject:object];
        
    }
    
    
    self.connectionTitles = [[self.connectionsData allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.connectionTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.connectionsData objectForKey:[self.connectionTitles objectAtIndex:section]] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 67.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//        return @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z"];
    return self.connectionTitles;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        cell.preservesSuperviewLayoutMargins = NO;
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Configure cell
    CNConnectionsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSString *sectionTitle = [self.connectionTitles objectAtIndex:indexPath.section];
    NSArray *sectionConnections = [self.connectionsData objectForKey:sectionTitle];
    NSDictionary *connection = [sectionConnections objectAtIndex:indexPath.row];
    
    [cell configureCellWithConnection:connection];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    CNUserVC *vc = (CNUserVC*)[self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CNUserVC class])];
    
    NSString *sectionTitle = [self.connectionTitles objectAtIndex:indexPath.section];
    NSArray *sectionConnections = [self.connectionsData objectForKey:sectionTitle];
    NSDictionary *connection = [sectionConnections objectAtIndex:indexPath.row];
    
    NSString *userID = connection[@"userID"];
    
    self.userRef = [[[AppDelegate sharedInstance].dbRef child:@"users"] child:userID];
    [self.userRef observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if (![snapshot.value isEqual:[NSNull null]]) {
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:snapshot.value];
            CNUser *user = [[CNUser alloc] initWithDictionary:userInfo];
            vc.user = user;
            
            [self presentViewController:vc animated:YES completion:nil];

        }
        
    }];
    
}

// Override to support conditional editing of the table view.
// This only needs to be implemented if you are going to be returning NO
// for some items. By default, all items are editable.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
//        [_chats removeObjectAtIndex:indexPath.row];
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

@end

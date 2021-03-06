//
//  CNSearchVC.m
//  Connect
//
//  Created by mac on 4/9/17.
//  Copyright © 2017 Connect Social Network. All rights reserved.
//

#import "CNSearchVC.h"
#import "CNSwitchView.h"
#import "CNConnectionsCell.h"
#import "CNUserVC.h"

@interface CNSearchVC () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UIView *switchView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constOfSwitchViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constOfTableViewBottom;

@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) CNSwitchView *searchSwitch;

@property (strong, nonatomic) FIRDatabaseReference *userRef;
@property (strong, nonatomic) FIRDatabaseReference *connectionRef;

@property (strong, nonatomic) NSArray *connections;
@property (strong, nonatomic) NSArray *allUsers;
@property (nonatomic, strong) NSMutableDictionary *connectionsData;
@property (strong, nonatomic) NSArray *connectionTitles;

@end

@implementation CNSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configureLayout];
    [self configureSwitchView];
    
    [self initNavBar];
}

- (void) viewWillAppear:(BOOL)animated{
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

- (void)configureLayout {
    // Configure view
    self.navigationController.navigationBar.barTintColor = kAppTintColor;
    
    self.tableView.sectionIndexColor = [UIColor blackColor];
    self.tableView.sectionIndexBackgroundColor = UIColorFromRGB(0xFAFAFA);
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView registerNib:[UINib nibWithNibName:@"CNConnectionsCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
}

- (void)configureSwitchView {
    // Configure switch view
    self.switchView.clipsToBounds = YES;
    self.searchSwitch = [[CNSwitchView alloc] initWithType:CNSwitchTypeConnections];
    self.searchSwitch.translatesAutoresizingMaskIntoConstraints = NO;
    [self.searchSwitch addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.switchView addSubview:self.searchSwitch];
    
    self.searchSwitch.layer.shadowOffset = CGSizeMake(0, 0);
    self.searchSwitch.layer.shadowRadius = 4;
    self.searchSwitch.layer.shadowOpacity = 0.1;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_searchSwitch);
    [self.switchView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_searchSwitch]-15-|" options:0 metrics:nil views:views]];
    [self.switchView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-14-[_searchSwitch(40)]" options:0 metrics:nil views:views]];
    
    // Hide switch view on first load
    self.constOfSwitchViewHeight.constant = 0;
    
}

- (void) initNavBar{
    
    [self setupSearchBar];
    [self.searchSwitch setOn:YES];
    [self loadConnection];
    
}

- (void)setupSearchBar {
    
    // Configure searchBar
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 70, SCREEN_WIDTH, 44)];
    self.searchBar.delegate = self;
    self.searchBar.barTintColor = kAppTextColor;
    
    self.navigationItem.titleView = self.searchBar;
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


- (void)switchValueChanged:(id)sender {
    CNSwitchView *cnSwitch = (CNSwitchView *)sender;
    if (cnSwitch.isOn) {
        NSLog(@"Switch On");
        [self loadConnection];
    } else {
        NSLog(@"Switch Off");
        [self loadAllUser];
    }
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
                        
                        [self startSearchWithString:self.searchBar.text];
                    });
                    
                }];
                
            }
            self.connections = array;
            
        } else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                [self startSearchWithString:self.searchBar.text];
            });
        }
        
    }];
}

- (void) loadAllUser{
    //    if (_allUsers != nil) {
    //        [self startSearchWithString:self.searchBar.text];
    //        return;
    //    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.userRef = [[AppDelegate sharedInstance].dbRef child:@"users"];
    
    [_userRef observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (![snapshot.value isEqual:[NSNull null]]) {
            
            self.allUsers = [[NSMutableArray alloc] init];
            
            NSEnumerator *children = [snapshot children];
            FIRDataSnapshot *child;
            NSMutableArray *array = [[NSMutableArray alloc] init];
            
            while (child = [children nextObject]) {
                NSLog(@"Child Value: %@", child.value);
                NSDictionary *dict = child.value;
                NSNumber* profileHidden = [dict objectForKey:@"profileHidden"];
                
                if (![[CNUser currentUser].userID isEqualToString:dict[@"userID"]]  && [profileHidden boolValue] == false) {
                    [array addObject: dict];
                }
            }
            
            self.allUsers = array;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self startSearchWithString:self.searchBar.text];
        });
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SearchBar Delegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self startSearchWithString:searchText];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
    [self.searchBar setShowsCancelButton:NO animated:NO];
    [self.searchSwitch setOn:YES];
    [self startSearchWithString:searchBar.text];
    [self.view endEditing:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar*)searchBar {
    [searchBar resignFirstResponder];
    [self startSearchWithString:searchBar.text];
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) return YES;
    if (text.length == 0) return YES;
    if (searchBar.text.length > 0 && [text isEqualToString:@" "]) return YES;
    
    if ([text rangeOfCharacterFromSet:[NSCharacterSet alphanumericCharacterSet]].location == NSNotFound) {
        return NO;
    } return YES;
}

- (void)startSearchWithString:(NSString*)searchString {
    // Search implementation
    
    if (searchString.length == 0) {
        self.constOfSwitchViewHeight.constant = 0;
    } else {
        self.constOfSwitchViewHeight.constant = 68;
    }
    
    self.connectionsData = [NSMutableDictionary new];
    
    NSArray *temp;
    if (self.searchSwitch.isOn) {
        temp = self.connections;
    } else {
        temp = self.allUsers;
    }
    
    for (NSDictionary *object in temp) {
        NSString *name = [NSString stringWithFormat:@"%@ %@", object[@"firstName"], object[@"lastName"]];
        
        if (searchString.length > 0) {
            if (![[name lowercaseString] containsString:[searchString lowercaseString]]) {
                continue;
            }
        }
        
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

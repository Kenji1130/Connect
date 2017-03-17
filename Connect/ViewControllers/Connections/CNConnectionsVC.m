//
//  CNConnectionsVC.m
//  Connect
//
//  Created by Daniel on 30/01/2017.
//  Copyright © 2017 Connect Social Network. All rights reserved.
//

#import "CNConnectionsVC.h"
#import "CNConnectionsCell.h"
#import "CNSwitchView.h"
#import "CNProfileViewController.h"

@interface CNConnectionsVC () <UITableViewDelegate, UITableViewDataSource, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UIView *switchView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constOfSwitchViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constOfTableViewBottom;

@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) CNSwitchView *searchSwitch;

@property (strong, nonatomic) FIRDatabaseReference *userRef;

@property (strong, nonatomic) NSArray *connections;
@property (nonatomic, strong) NSMutableDictionary *connectionsData;
@property (strong, nonatomic) NSArray *connectionTitles;

@end

@implementation CNConnectionsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupSearchBar];
    [self configureLayout];
    [self configureSwitchView];
    
    [self loadData];
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

-(void)dealloc {
    [self.searchController.view removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helpers

- (void)setupSearchBar {
    // Configure search controller
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.delegate = self;
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    [self.searchController setHidesNavigationBarDuringPresentation:NO];
    self.searchController.searchBar.placeholder = @"Search";
    self.searchController.searchBar.delegate = self;
    self.searchController.searchBar.autocapitalizationType = UITextAutocapitalizationTypeWords;
    self.searchController.searchBar.barTintColor = kAppTextColor;
    
//    self.searchController.searchBar.backgroundImage = [self imageWithColor:[UIColor whiteColor] size:self.searchController.searchBar.frame.size];
//    UITextField *txfSearchField = [self.searchController.searchBar valueForKey:@"_searchField"];
//    txfSearchField.backgroundColor = UIColorFromRGB(0xdedee0);
    
    self.navigationItem.titleView = self.searchController.searchBar;
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
//    CNSwitchView *cnSwitch = (CNSwitchView *)sender;
    
}

- (void)loadData {
    // Default connections
    self.connections = @[@{@"name" : @"Jonathan Reyes", @"image" : @"UIImageViewPerson1", @"profile_type" : @0},
                         @{@"name" : @"Gabi Maskowitz", @"image" : @"UIImageViewPerson1", @"profile_type" : @1},
                         @{@"name" : @"Annie Rowe", @"image" : @"UIImageViewPerson1", @"profile_type" : @0},
                         @{@"name" : @"Rachel Woods", @"image" : @"UIImageViewPerson1", @"profile_type" : @2},
                         @{@"name" : @"Carol Mendez", @"image" : @"UIImageViewPerson1", @"profile_type" : @1},
                         @{@"name" : @"Joan Green", @"image" : @"UIImageViewPerson1", @"profile_type" : @0},
                         @{@"name" : @"Johnny Castillo", @"image" : @"UIImageViewPerson1", @"profile_type" : @0},
                         @{@"name" : @"Kathy Patterson", @"image" : @"UIImageViewPerson1", @"profile_type" : @0}];
    
    if (self.userRef == nil) {
        self.userRef = [[[AppDelegate sharedInstance].dbRef child:@"users"] child:[CNUser currentUser].userID];
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[_userRef child:@"connections"] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if (![snapshot.value isEqual:[NSNull null]]) {
            NSDictionary *value = snapshot.value;
            self.connections = value.allValues;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [self startSearchWithString:nil];
        });
    }];
}

#pragma mark - Search Delegate

- (void)startSearchWithString:(NSString*)searchString {
    // Search implementation
    
    if (searchString.length == 0) {
        self.constOfSwitchViewHeight.constant = 0;
    } else {
        self.constOfSwitchViewHeight.constant = 68;
    }
    
    self.connectionsData = [NSMutableDictionary new];
    
    for (NSDictionary *object in self.connections) {
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

- (void)updateSearchResultsForSearchController:(UISearchController*)searchController {
    [self startSearchWithString:searchController.searchBar.text];
}

- (void)willDismissSearchController:(UISearchController *)searchController {
    [self dismissSearch];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self dismissSearch];
}

- (void)dismissSearch {
    if (self.navigationItem.titleView != nil) {
        // Remove search bar from navigation bar and hide search results
        [self.searchController.searchBar resignFirstResponder];
        
        if (![self.searchController.searchBar.text isEqualToString:@""]) {
//            [self startSearchWithString:self.searchController.searchBar.text];
        }
    }
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
//    [self.view endEditing:YES];
    [self.searchController.searchBar resignFirstResponder];
    
    CNProfileViewController *profileVC = (CNProfileViewController *)[self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CNProfileViewController class])];
//    profileVC.user = nil;
    profileVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:profileVC animated:YES];
    
//    NSString *sectionTitle = [self.countrySectionTitles objectAtIndex:indexPath.section];
//    NSArray *sectionCountries = [self.countryData objectForKey:sectionTitle];
//    NSDictionary *country = [sectionCountries objectAtIndex:indexPath.row];
//    
//    if (self.delegate && [self.delegate respondsToSelector:@selector(didCountrySelected:)]) {
//        [self.delegate didCountrySelected:country];
//    }
//    
//    [self.navigationController popViewControllerAnimated:YES];
    
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

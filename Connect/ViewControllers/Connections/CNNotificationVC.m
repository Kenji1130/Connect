//
//  CNNotificationVC.m
//  Connect
//
//  Created by mac on 3/22/17.
//  Copyright © 2017 Connect Social Network. All rights reserved.
//

#import "CNNotificationVC.h"
#import "CNSwitchView.h"
#import "CNNotificationCell.h"
#import "CNNotification.h"

@interface CNNotificationVC () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *switchView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) CNSwitchView *searchSwitch;

@property (strong, nonatomic) FIRDatabaseReference *notiRef;
@property (strong, nonatomic) FIRDatabaseReference *connectRef;
@property (strong, nonatomic) NSMutableArray *notifications;
@property (strong, nonatomic) NSMutableArray *connections;
@property (strong, nonatomic) NSArray *sortedNotis;

@end

@implementation CNNotificationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configLayout];
    [self loadConnections];
    
}

- (void)configLayout{
    [self configSwitchView];
    
    self.tableView.sectionIndexColor = [UIColor blackColor];
    self.tableView.sectionIndexBackgroundColor = UIColorFromRGB(0xFAFAFA);

    [self.tableView registerNib:[UINib nibWithNibName:@"CNNotificationCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
}

- (void)configSwitchView {
    // Configure switch view
    self.switchView.clipsToBounds = YES;
    self.searchSwitch = [[CNSwitchView alloc] initWithType:CNSwitchTypeNotification];
    self.searchSwitch.translatesAutoresizingMaskIntoConstraints = NO;
    [self.searchSwitch addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.switchView addSubview:self.searchSwitch];
    
    self.searchSwitch.layer.shadowOffset = CGSizeMake(0, 0);
    self.searchSwitch.layer.shadowRadius = 4;
    self.searchSwitch.layer.shadowOpacity = 0.1;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_searchSwitch);
    [self.switchView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_searchSwitch]-15-|" options:0 metrics:nil views:views]];
    [self.switchView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-14-[_searchSwitch(40)]" options:0 metrics:nil views:views]];
        
}

- (void)loadNotifications{
    self.notiRef = [[[AppDelegate sharedInstance].dbRef child:@"notifications"] child:[CNUser currentUser].userID];
    [self.notiRef observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        self.notifications = [[NSMutableArray alloc] init];
        self.sortedNotis = [[NSArray alloc] init];
        NSEnumerator *children = [snapshot children];
        FIRDataSnapshot *child;
        while (child = [children nextObject]) {
            NSLog(@"Child Value: %@", child.value);
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            dict = child.value;
            [dict setObject:child.key forKey:@"fromID"];
            [dict setObject:[CNUser currentUser].userID forKey:@"toID"];
            CNNotification *noti = [[CNNotification alloc] initWithDictionary:dict];
            [self.notifications addObject:noti];
            self.sortedNotis = [self.notifications sortedArrayUsingSelector:@selector(compare:)];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.tableView reloadData];
        });

    }];

}

- (void)loadConnections{
    self.notiRef = [[AppDelegate sharedInstance].dbRef child:@"notifications"];
    self.connections = [[NSMutableArray alloc] init];
    self.sortedNotis = [[NSArray alloc] init];

    int connectCount = (int)[CNUser currentUser].connectionId.count;
    for (int i = 0; i < connectCount / 2 ; i++) {
        NSLog(@"Connection ID: %@", [[CNUser currentUser].connectionId objectAtIndex:i]);
        NSString *userID1 = [[CNUser currentUser].connectionId objectAtIndex:i];
        
        int j = i + 1;
        while (i+j < connectCount) {
            NSString *userID2 = [[CNUser currentUser].connectionId objectAtIndex:i+j];
            
            [[[self.notiRef child:userID1] child:userID2] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                
                NSLog(@"Connection ID: %@ Connection Data: %@", userID1, snapshot.value);
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                dict = snapshot.value;
                CNNotification *noti = [[CNNotification alloc] initWithDictionary:dict];
                [self.connections addObject:noti];
                self.sortedNotis = [self.connections sortedArrayUsingSelector:@selector(compare:)];

                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.tableView reloadData];
                });
                
            }];
            
            j ++;

        }
        
    }
}

- (void)switchValueChanged:(id)sender {
    CNSwitchView *cnSwitch = (CNSwitchView *)sender;
    if (cnSwitch.isOn) {
        NSLog(@"Switch On");
        [self loadConnections];
    } else {
        NSLog(@"Switch Off");
        [self loadNotifications];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction

- (IBAction)onBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sortedNotis.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CNNotification *notification = [self.sortedNotis objectAtIndex:indexPath.row];
    if (notification.notiType == CNNotificationTypeRequest) {
        return 82;
    }
    return 56.0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Configure cell
    CNNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    CNNotification *notification = [self.sortedNotis objectAtIndex:indexPath.row];
    [cell configureCellWithNotification:notification];
    return cell;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  CNProfileViewController.m
//  Connect
//
//  Created by Daniel on 31/01/2017.
//  Copyright © 2017 Connect Social Network. All rights reserved.
//

#import "CNProfileViewController.h"
#import "CNProfileHeaderView.h"
#import "CNProfileMediaCell.h"
#import "CNProfileEditOptionCell.h"
#import "CNProfileAddMediaCell.h"

@interface CNProfileViewController () <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CNProfileHeaderViewDelegate, CNProfileMediaCellDelegate, CNProfileAddMediaCellDelegate, CNProfileEditOptionCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) CNProfileHeaderView *headerView;
@property (strong, nonatomic) UIRefreshControl *refrshControl;

@property (assign, nonatomic) CGFloat headerHeight;
//@property (assign, nonatomic) CNProfileType profileType;
@property (assign, nonatomic) BOOL isEdit;

@end

@implementation CNProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configureView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.navigationController.viewControllers.count > 1) {
        [[self navigationController] setNavigationBarHidden:YES animated:YES];
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.navigationController.viewControllers.count > 1) {
        [[self navigationController] setNavigationBarHidden:NO animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helpers

- (void)configureView {
    // Configure View
    if (self.user == nil)
        self.user = [CNUser currentUser];
    
    self.isEdit = NO;
    
    if (!self.user.isMe) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"UIButtonOnboardingBack"] style:UIBarButtonItemStylePlain target:self action:@selector(onBackBtnClicked:)];
    }
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    [self.tableView registerNib:[UINib nibWithNibName:@"CNProfileEditOptionCell" bundle:nil] forCellReuseIdentifier:@"CellOption"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CNProfileMediaCell" bundle:nil] forCellReuseIdentifier:@"CellMedia"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CNProfileAddMediaCell" bundle:nil] forCellReuseIdentifier:@"CellAdd"];
    
    if (self.navigationController.viewControllers.count > 1) {
        self.refrshControl = [UIRefreshControl new];
        [self.refrshControl addTarget:self action:@selector(refreshList:) forControlEvents:UIControlEventValueChanged];
        [self.tableView addSubview:self.refrshControl];
    } else {
        self.tableView.bounces = NO;
    }
}

- (void)refreshList:(id)sender {
//    SDImageCache *imageCache = [SDImageCache sharedImageCache];
//    [imageCache clearMemory];
//    [imageCache clearDisk];
    
    self.tableView.userInteractionEnabled = NO;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.refrshControl endRefreshing];
        [self.tableView reloadData];
        self.tableView.userInteractionEnabled = YES;
    });
}

#pragma mark - IBActions

- (IBAction)onBackBtnClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger extra = self.isEdit ? 2 : 0;
    return (self.user.profileType == CNProfileTypePersonal ? 5 : 4) + extra;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isEdit) {
        NSInteger lastIndex = self.user.profileType == CNProfileTypePersonal ? 6 : 5;
        if (lastIndex == indexPath.row)
            return 85.0;
    }
    
    return 50.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    self.headerHeight = round(self.isEdit ? SCREEN_WIDTH : (SCREEN_WIDTH * (613.0 / 750.0))) - (isiPhone6Plus ? 40 : 0);
    return self.headerHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.headerView == nil) {
        self.headerView = (CNProfileHeaderView *)[[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CNProfileHeaderView class]) owner:nil options:nil] firstObject];
        self.headerView.delegate = self;
    }
    
    self.headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.headerHeight);
//    [self.headerView configureViewWithType:self.profileType isEdit:self.isEdit isCurrent:self.isCurrentUser];
    [self.headerView configureViewWithUser:self.user isEdit:self.isEdit];
    
    return self.headerView;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
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
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        NSInteger lastIndex = (self.isEdit ? 2 : 0) + (self.user.profileType == CNProfileTypePersonal ? 5 : 4) - 1;
        if (indexPath.row == lastIndex) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, SCREEN_WIDTH, 0, 0)];
        } else {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Configure cell
    if (self.isEdit) {
        NSInteger lastIndex = self.user.profileType == CNProfileTypePersonal ? 6 : 5;
        if (indexPath.row == 0) {
            // Hide profile from search
            CNProfileEditOptionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellOption" forIndexPath:indexPath];
            cell.delegate = self;
            
            return cell;
            
        } else if (indexPath.row == lastIndex) {
            // Add social media
            CNProfileAddMediaCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellAdd" forIndexPath:indexPath];
            cell.delegate = self;
            
            return cell;
        }
    }
    
    CNProfileMediaCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellMedia" forIndexPath:indexPath];
    cell.delegate = self;
    [cell configureCellWithIndex:indexPath.row withType:self.user.profileType isEdit:self.isEdit isCurrent:self.user.isMe];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.view endEditing:YES];
    
}

#pragma mark - CNProfileHeaderView Delegate

- (void)didProfileTypeChanged:(CNProfileType)profileType {
    self.user.profileType = profileType;
    [self.tableView reloadData];
}

- (void)didEditProfileTapped {
    self.isEdit = YES;
    [self.tableView reloadData];
}

- (void)didEditProfileDone {
    self.isEdit = NO;
    [self.tableView reloadData];
}

- (void)didProfileImageTapped {
    UIImagePickerController *controller = [UIImagePickerController new];
    controller.delegate = self;
    controller.allowsEditing = YES;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertAction *Camera = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:controller animated:YES completion:nil];
        }];
        
        [alert addAction:Camera];
    }
    
    UIAlertAction *photoLibrary = [UIAlertAction actionWithTitle:@"Photo Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:controller animated:YES completion:nil];
    }];
    [alert addAction:photoLibrary];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    
    alert.popoverPresentationController.sourceView = self.headerView.ivProfileImage;
    alert.popoverPresentationController.sourceRect = self.headerView.ivProfileImage.bounds;
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - ImagePickerController delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [self dismissViewControllerAnimated:YES completion:^{
        UIImage *image = info[UIImagePickerControllerEditedImage];
//        self.user setProfileImage:<#(UIImage *)#>
//        image = info[UIIm]
        
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - CNProfileMediaCell Delegate

- (void)didMediaRemovedAtIndex:(NSInteger)index {
    
}

#pragma mark - CNProfileAddMediaCell Delegate

- (void)didAddMediaTapped {
    
}

#pragma mark - CNProfileEditOptionCell Delegate {

- (void)didHideSwitchChanged:(BOOL)hide {
    
}

@end

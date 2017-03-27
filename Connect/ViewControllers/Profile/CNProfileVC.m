//
//  CNProfileVC.m
//  Connect
//
//  Created by mac on 3/24/17.
//  Copyright © 2017 Connect Social Network. All rights reserved.
//

#import "CNProfileVC.h"
#import "CNSwitchView.h"
#import "CNMyProfileCell.h"
#import "CNSettingVC.h"

@interface CNProfileVC () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *btnEdit;
@property (weak, nonatomic) IBOutlet UIButton *btnSetting;
@property (weak, nonatomic) IBOutlet UIButton *btnImagePick;
@property (weak, nonatomic) IBOutlet UIView *switchView;
@property (weak, nonatomic) IBOutlet UIImageView *ivProfileImage;
@property (weak, nonatomic) IBOutlet UIView *profileInfoView;
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lbOccupation;
@property (weak, nonatomic) IBOutlet UIView *profileEditView;
@property (weak, nonatomic) IBOutlet UITextField *tfName;
@property (weak, nonatomic) IBOutlet UITextField *tfOccupation;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTopAnchor;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *profileHideView;
@property (weak, nonatomic) IBOutlet UISwitch *profileHiddenToggle;


@property (nonatomic, strong) CNSwitchView *profileSwitch;

@property (nonatomic, assign) BOOL isEdit;

@property (strong, nonatomic) FIRDatabaseReference *userRef;

@end

@implementation CNProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self configLayout];
}

- (void) viewWillDisappear:(BOOL)animated{
    [self.view endEditing:YES];
    [super viewWillDisappear:animated];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (void)initData{
    self.isEdit = false;
    self.user = [CNUser currentUser];
}

- (void)configLayout{
    [self configSwtichView];
    
    if (self.user.profileType == CNProfileTypePersonal) {
        self.view.backgroundColor = UIColorFromRGB(0xf0f0f0);
        self.switchView.backgroundColor = UIColorFromRGB(0xf0f0f0);
        [self.profileSwitch setOn:false];
    } else {
        self.view.backgroundColor = UIColorFromRGB(0x9a9a9b);
        self.switchView.backgroundColor = UIColorFromRGB(0x9a9a9b);
        [self.profileSwitch setOn:true];
    }
    
    if (self.user.profileImageURL == nil) {
        self.ivProfileImage.backgroundColor = UIColorFromRGB(0xd1d1d1);
        self.ivProfileImage.image = [UIImage imageNamed:@"UIImageViewProfileIconPicture"];
        self.ivProfileImage.contentMode = UIViewContentModeCenter;
    } else {
        self.ivProfileImage.backgroundColor = [UIColor clearColor];
        [self.ivProfileImage setImageWithURL:self.user.profileImageURL placeholderImage:nil usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.ivProfileImage.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    self.btnImagePick.hidden = true;
    self.lbName.text = [NSString stringWithFormat:@"%@ %@", self.user.firstName, self.user.lastName];
    if (self.user.occupation != nil) {
        self.lbOccupation.text = self.user.occupation;
    } else {
        self.lbOccupation.text = @"";
    }
    
    self.profileEditView.hidden = true;
    self.tfName.text = [NSString stringWithFormat:@"%@ %@", self.user.firstName, self.user.lastName];
    if (self.user.occupation != nil) {
        self.tfOccupation.text = self.user.occupation;
    } else {
        self.tfOccupation.text = @"";
    }
    
    self.lbName.textColor = kAppTextColor;
    self.lbOccupation.textColor = kAppTextColor;
    self.tfName.textColor = kAppTextColor;
    self.tfOccupation.textColor = kAppTextColor;
    
    self.tfName.layer.borderWidth = 1.0;
    self.tfName.layer.borderColor = UIColorFromRGB(0xdddddd).CGColor;
    
    self.tfOccupation.layer.borderWidth = 1.0;
    self.tfOccupation.layer.borderColor = UIColorFromRGB(0xdddddd).CGColor;
    
    self.profileHideView.hidden = true;
    [self.profileHiddenToggle setOn:[CNUser currentUser].profileHidden];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CNMyProfileCell" bundle:nil] forCellReuseIdentifier:@"CellMedia"];
    
}

- (void)configSwtichView{
    // Configure switch view
    self.switchView.clipsToBounds = YES;
    self.profileSwitch = [[CNSwitchView alloc] initWithType:CNSwitchTypeProfile];
    self.profileSwitch.translatesAutoresizingMaskIntoConstraints = NO;
    [self.profileSwitch addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.switchView addSubview:self.profileSwitch];
    
    self.profileSwitch.layer.shadowOffset = CGSizeMake(0, 0);
    self.profileSwitch.layer.shadowRadius = 4;
    self.profileSwitch.layer.shadowOpacity = 0.1;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_profileSwitch);
    [self.switchView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_profileSwitch]-15-|" options:0 metrics:nil views:views]];
    [self.switchView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-14-[_profileSwitch(40)]" options:0 metrics:nil views:views]];
    
}


#pragma mark - IBAction
- (IBAction)onEdit:(id)sender {
    self.isEdit = !self.isEdit;
    if (!self.isEdit) {
        [self.btnEdit setImage:[UIImage imageNamed:@"UIButtonProfileEdit"] forState:UIControlStateNormal];
        [self profileSave];

    } else{
        [self.btnEdit setImage:[UIImage imageNamed:@"UIButtonProfileDoneCheckmark"] forState:UIControlStateNormal];
        [self profileEdit];
    }
    
    self.btnImagePick.hidden = !self.isEdit;
    
    [self.tableView reloadData];
}

- (void)profileEdit{
    [self.profileSwitch setEnabled:false];
    self.profileInfoView.hidden = true;
    self.profileEditView.hidden = false;
    self.profileHideView.hidden = false;
    self.tableViewTopAnchor.constant = 106;
    
    self.btnSetting.hidden = true;
}

- (void)profileSave{
    [self.view endEditing:YES];
    [self.profileSwitch setEnabled:true];
    self.profileInfoView.hidden = false;
    self.profileEditView.hidden = true;
    self.profileHideView.hidden = true;
    self.tableViewTopAnchor.constant = 8;
    
    self.btnSetting.hidden = false;

}

- (IBAction)onSetting:(id)sender {
    CNSettingVC *vc = (CNSettingVC*)[self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CNSettingVC class])];
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)onPicker:(id)sender {
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
    
    alert.popoverPresentationController.sourceView = self.ivProfileImage;
    alert.popoverPresentationController.sourceRect = self.ivProfileImage.bounds;
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - ImagePickerController delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [self dismissViewControllerAnimated:YES completion:^{
        UIImage *image = info[UIImagePickerControllerEditedImage];
        //        self.user setProfileImage:<#(UIImage *)#>
        //        image = info[UIIm]
        [self.ivProfileImage setImage:image];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Switch Value Change
- (void)switchValueChanged:(id)sender {
    CNSwitchView *cnSwitch = (CNSwitchView *)sender;
    if (cnSwitch.isOn) {
        NSLog(@"Switch On");
        self.btnEdit.tintColor = UIColorFromRGB(0x929eaf);
        self.btnSetting.tintColor = UIColorFromRGB(0x929eaf);
        self.view.backgroundColor = UIColorFromRGB(0xf0f0f0);
        self.switchView.backgroundColor = UIColorFromRGB(0xf0f0f0);
        
        self.lbName.textColor = kAppTextColor;
        self.lbOccupation.textColor = kAppTextColor;
        self.tfName.textColor = kAppTextColor;
        self.tfOccupation.textColor = kAppTextColor;
        

    } else {
        NSLog(@"Switch Off");
        self.btnEdit.tintColor = [UIColor whiteColor];
        self.btnSetting.tintColor = [UIColor whiteColor];
        self.view.backgroundColor = UIColorFromRGB(0x9a9a9b);
        self.switchView.backgroundColor = UIColorFromRGB(0x9a9a9b);
        
        self.lbName.textColor = [UIColor whiteColor];
        self.lbOccupation.textColor = [UIColor whiteColor];
        self.tfName.textColor = [UIColor whiteColor];
        self.tfOccupation.textColor = [UIColor whiteColor];
    }
}

#pragma mark - Show/Hide Profile
- (IBAction)profileShowHide:(UISwitch *)sender {
    [CNUser currentUser].profileHidden = sender.on;
    self.userRef = [[[AppDelegate sharedInstance].dbRef child:@"users"] child:[CNUser currentUser].userID];
    NSDictionary *updateValue = @{@"profileHidden": [NSNumber numberWithBool:sender.on]};
    [self.userRef updateChildValues:updateValue];
}



#pragma mark - UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Deleage
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CNMyProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellMedia" forIndexPath:indexPath];
   
    [cell configureCellWithIndex:indexPath.row withType:self.user.profileType isEdit:self.isEdit];
    
    return cell;
}
@end

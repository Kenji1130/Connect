//
//  ViewController.m
//  Connect
//
//  Created by Daniel on 10/01/2017.
//  Copyright © 2017 Connect Social Network. All rights reserved.
//

#import "CNSplashViewController.h"
#import "CNOnboardingSignTypeVC.h"

@interface CNSplashViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end

@implementation CNSplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self configureLayout];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helpers

- (void)configureLayout {
    // Configures layout
    
}

#pragma mark - IBActions

- (IBAction)onGetStartedBtnClicked:(id)sender {
    // Show onboarding snapchat vc
    CNOnboardingSignTypeVC *vc = (CNOnboardingSignTypeVC *)[self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CNOnboardingSignTypeVC class])];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Update page control index
    self.pageControl.currentPage = round(scrollView.contentOffset.x / scrollView.frame.size.width);
}


@end

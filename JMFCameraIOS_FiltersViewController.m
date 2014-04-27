/***************************************************************************/
/*                                                                         */
/*  JMFCameraIOS_FiltersViewController.m                                   */
/*  Copyright (c) 2014 Simarks. All rights reserved.                       */
/*                                                                         */
/*  Description: JMFCameraIOS                                              */
/*               U-Tad - Práctica iOS Avanzado                             */
/*               Filters View Controller Class implementation file         */
/*                                                                         */
/*       Author: Jorge Marcos Fernandez                                    */
/*                                                                         */
/***************************************************************************/
#import "JMFCameraIOS_FiltersViewController.h"
#import "JMFCameraIOS_EditFiltersViewController.h"
#import "JMFCameraIOS_FaceRecViewController.h"

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  Defines                                                                */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
#define IDC_UITOOLBAR_BUTTON_SHARE_INDEX    0
#define IDC_UITOOLBAR_BUTTON_SHOW_INDEX     1
#define IDC_UITOOLBAR_BUTTON_FILTERS_INDEX  2
#define IDC_UITOOLBAR_BUTTON_DATA_INDEX     3

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  JMFCameraIOS_FiltersViewController Class Interface                     */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@interface JMFCameraIOS_FiltersViewController ()

@end

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  JMFCameraIOS_FiltersViewController Class Implemantation                */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@implementation JMFCameraIOS_FiltersViewController

#pragma mark - Initialization Methods
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  Initialization Methods                                                 */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  initWithImage:                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (id)initWithImage:(UIImage*)image
{
    if( self = [super initWithNibName:nil bundle:nil] )
    {
        self.image = image;
    }
    return self;
}

#pragma mark - UIViewController Override Methods
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  UIViewController Override Methods                                      */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  initWithNibName:bundle:                                                */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if( self )
    {
        // Custom initialization
    }
    return self;
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  viewDidLoad                                                            */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.title = NSLocalizedString( @"IDS_FILTERS", nil );
    
    self.iboTabBar.delegate = self;
    [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_SHARE_INDEX]      setTitle:NSLocalizedString( @"IDS_SHARE",   nil )];
    [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_SHOW_INDEX]       setTitle:NSLocalizedString( @"IDS_SHOW",    nil )];
    [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_FILTERS_INDEX]    setTitle:NSLocalizedString( @"IDS_FILTERS", nil )];
    [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_DATA_INDEX]       setTitle:NSLocalizedString( @"IDS_DATA",    nil )];
    
    self.iboSourceImage.image = self.image;
    self.iboTargetImage.image = self.image;
    
    NSString* filterString = NSLocalizedString( @"IDS_FILTER", nil );
    self.iboFilter1Label.text = [NSString stringWithFormat:@"%@ 1", filterString, nil];
    self.iboFilter2Label.text = [NSString stringWithFormat:@"%@ 2", filterString, nil];
    self.iboFilter3Label.text = [NSString stringWithFormat:@"%@ 3", filterString, nil];
    self.iboFilter4Label.text = [NSString stringWithFormat:@"%@ 4", filterString, nil];
    self.iboFilter5Label.text = [NSString stringWithFormat:@"%@ 5", filterString, nil];
    
    [self.iboFilter1Switch setOn:NO];
    [self.iboFilter2Switch setOn:NO];
    [self.iboFilter3Switch setOn:NO];
    [self.iboFilter4Switch setOn:NO];
    [self.iboFilter5Switch setOn:NO];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  viewWillAppear                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  didReceiveMemoryWarning                                                */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITabBarDelegate
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  UITabBarDelegate Methods                                               */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  tabBar:didSelectItem:                                                  */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)tabBar:(UITabBar*)tabBar didSelectItem:(UITabBarItem*)item
{
    switch( item.tag )
    {
        case IDC_UITOOLBAR_BUTTON_SHARE_INDEX:      [self onShareClicked];      break;
        case IDC_UITOOLBAR_BUTTON_SHOW_INDEX:       [self onShowClicked];       break;
        case IDC_UITOOLBAR_BUTTON_FILTERS_INDEX:    [self onFiltersClicked];    break;
        case IDC_UITOOLBAR_BUTTON_DATA_INDEX:       [self onDataClicked];       break;
    }
}

#pragma mark - Class Instance Methods
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  Class Instance Methods                                                 */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  onShareClicked                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)onShareClicked
{
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  onShowClicked                                                          */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)onShowClicked
{
    JMFCameraIOS_FaceRecViewController* faceRecVC = [[JMFCameraIOS_FaceRecViewController alloc] initWithImage:self.image];
    [self.navigationController pushViewController:faceRecVC animated:YES];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  onFiltersClicked                                                       */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)onFiltersClicked
{
    JMFCameraIOS_EditFiltersViewController* filtersVC = [[JMFCameraIOS_EditFiltersViewController alloc]init];
    [self.navigationController pushViewController:filtersVC animated:YES];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  onDataClicked                                                          */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)onDataClicked
{
}

#pragma mark - IBAction Methods
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  IBAction Methods                                                       */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  onFilterSwitchChanged:                                                 */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (IBAction)onFilterSwitchChanged:(id)sender
{
}

@end

/***************************************************************************/
/*                                                                         */
/*  JMFCameraIOS_EditFiltersViewController.m                               */
/*  Copyright (c) 2014 Simarks. All rights reserved.                       */
/*                                                                         */
/*  Description: JMFCameraIOS                                              */
/*               U-Tad - Práctica iOS Avanzado                             */
/*               Edit Filters View Controller Class implementation file    */
/*                                                                         */
/*       Author: Jorge Marcos Fernandez                                    */
/*                                                                         */
/***************************************************************************/
#import "JMFCameraIOS_EditFiltersViewController.h"
#import "JMFCameraIOS_FilterTVPickerCell.h"

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  Defines                                                                */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
#define IDS_FILTERTV_NORMAL_CELL_IDENTIFIER     @"FilterTVNormalCellIdentifier"
#define IDS_FILTERTV_PICKER_CELL_IDENTIFIER     @"FilterTVPickerCellIdentifier"

#define IDC_UITOOLBAR_BUTTON_CANCEL_INDEX       0
#define IDC_UITOOLBAR_BUTTON_APPLY_INDEX        1

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  JMFCameraIOS_EditFiltersViewController Class Interface                 */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@interface JMFCameraIOS_EditFiltersViewController ()
{
    long                iPickerViewSection;
    NSMutableArray*     filtersArray;
}

@end

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  JMFCameraIOS_EditFiltersViewController Class Implemantation            */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@implementation JMFCameraIOS_EditFiltersViewController

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
    self.title = NSLocalizedString( @"IDS_EDIT_FILTERS", nil );
    
    //TabBar
    self.iboTabBar.delegate = self;
    self.iboTabBar.layer.zPosition = -10;
    [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_CANCEL_INDEX] setTitle:NSLocalizedString( @"IDS_CANCEL", nil )];
    [[self.iboTabBar.items objectAtIndex:IDC_UITOOLBAR_BUTTON_APPLY_INDEX]  setTitle:NSLocalizedString( @"IDS_APPLY",  nil )];

    //TableView
    [self.iboTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:IDS_FILTERTV_NORMAL_CELL_IDENTIFIER];
    [self.iboTableView registerClass:[JMFCameraIOS_FilterTVPickerCell class] forCellReuseIdentifier:IDS_FILTERTV_PICKER_CELL_IDENTIFIER];
    self.iboTableView.sectionHeaderHeight = 2.0;
    self.iboTableView.sectionFooterHeight = 20.0;
    self.iboTableView.delegate = self;
    self.iboTableView.dataSource = self;
    
    iPickerViewSection = -1;
    filtersArray = [[CIFilter filterNamesInCategories:nil]mutableCopy];
    [filtersArray insertObject:@"CIFilterNone" atIndex:0];
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
        case IDC_UITOOLBAR_BUTTON_CANCEL_INDEX:
            [self.navigationController popViewControllerAnimated:YES];
            break;
            
        case IDC_UITOOLBAR_BUTTON_APPLY_INDEX:
            [self.navigationController popViewControllerAnimated:YES];
            break;
    }
}

#pragma mark - UITableViewDataSource
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  UITableViewDataSource Methods                                          */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  numberOfSectionsInTableView                                            */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 5;
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  tableView:titleForHeaderInSection:                                     */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"%@ #%d", NSLocalizedString( @"IDS_FILTER", nil ), section + 1];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  tableView:numberOfRowsInSection:                                       */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = ( iPickerViewSection != -1 && section == iPickerViewSection ) ? 2 : 1;
    return rows;
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  tableView:cellForRowAtIndexPath:                                       */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if( iPickerViewSection != -1 && indexPath.section == iPickerViewSection && indexPath.row == 1 )
    {
        JMFCameraIOS_FilterTVPickerCell* cell  = [tableView dequeueReusableCellWithIdentifier:IDS_FILTERTV_PICKER_CELL_IDENTIFIER forIndexPath:indexPath];
        cell.imageView.image = nil;
        cell.pickerView.dataSource = self;
        cell.pickerView.delegate = self;
        return cell;
    }
    else
    {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:IDS_FILTERTV_NORMAL_CELL_IDENTIFIER forIndexPath:indexPath];
        cell.imageView.image = [UIImage imageNamed:@"ArrowDown.png"];
        cell.textLabel.text = [NSString stringWithFormat:@"CIFilterNone"];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
        return cell;
    }
}

#pragma mark - UITableViewDelegate
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  UITableViewDelegate Methods                                            */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  tableView:heightForRowAtIndexPath:                                     */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return ( indexPath.section == iPickerViewSection && indexPath.row == 1 ) ? 160 : 30;
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  tableView:heightForHeaderInSection:                                    */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  tableView:viewForHeaderInSection:                                      */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel* headerView = [[UILabel alloc] initWithFrame:CGRectMake( 0, 0, tableView.bounds.size.width, 30 ) ];
    headerView.text = [NSString stringWithFormat:@"   %@ #%d", NSLocalizedString( @"IDS_FILTER", nil ), section + 1];
    headerView.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
    headerView.backgroundColor = Rgb2UIColor( 245, 200, 35 );
    headerView.textColor = [UIColor whiteColor];
    return headerView;
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  tableView:didSelectRowAtIndexPath:                                     */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    if( indexPath.row == 1 ) return;
    
    BOOL bOtherSectionSelected = ( indexPath.section != iPickerViewSection );
    
    [tableView beginUpdates];
    if( iPickerViewSection != -1 )
    {
        NSIndexPath* idx = [NSIndexPath indexPathForRow:1 inSection:iPickerViewSection];
        [tableView deleteRowsAtIndexPaths:@[idx] withRowAnimation:( bOtherSectionSelected ) ? UITableViewRowAnimationNone : UITableViewRowAnimationTop];
        idx = [NSIndexPath indexPathForRow:0 inSection:iPickerViewSection];
        UITableViewCell* goneCell = [self.iboTableView cellForRowAtIndexPath:idx];
        goneCell.imageView.image = [UIImage imageNamed:@"ArrowDown.png"];
    }
    
    if( bOtherSectionSelected )
    {
        iPickerViewSection = indexPath.section;
        NSIndexPath* idx = [NSIndexPath indexPathForRow:1 inSection:indexPath.section];
        [tableView insertRowsAtIndexPaths:@[idx] withRowAnimation:UITableViewRowAnimationTop];
        UITableViewCell* selectedCell = [self.iboTableView cellForRowAtIndexPath:indexPath];
        selectedCell.imageView.image = [UIImage imageNamed:@"ArrowUp.png"];
    }
    else iPickerViewSection = -1;
    
    [tableView endUpdates];
    
    if( bOtherSectionSelected )
    {
        NSIndexPath* idx = [NSIndexPath indexPathForRow:0 inSection:iPickerViewSection];
        [tableView scrollToRowAtIndexPath:idx atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

#pragma mark - UIPickerViewDataSource Methods
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  UIPickerViewDataSource Methods                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  numberOfComponentsInPickerView:                                        */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 1;
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  pickerView:numberOfRowsInComponent:                                    */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (NSInteger)pickerView:(UIPickerView*)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return filtersArray.count;
}

#pragma mark - UIPickerViewDelegate Methods
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  UIPickerViewDelegate Methods                                           */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  pickerView:titleForRow:forComponent:                                   */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
-(NSString*)pickerView:(UIPickerView*)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [filtersArray objectAtIndex:row];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  pickerView:didSelectRow:inComponent:                                   */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSIndexPath* indexPath = [NSIndexPath indexPathForItem:0 inSection:iPickerViewSection];
    UITableViewCell* cell = [self.iboTableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.text = [filtersArray objectAtIndex:row];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  pickerView:viewForRow:forComponent:reusingView:                        */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* label = (UILabel*)view;
    if( !label ) label = [[UILabel alloc]init];
    
    label.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = [filtersArray objectAtIndex:row];
    
    return label;
}

@end
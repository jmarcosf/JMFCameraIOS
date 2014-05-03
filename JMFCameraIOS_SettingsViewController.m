/***************************************************************************/
/*                                                                         */
/*  JMFCameraIOS_SettingsViewController.m                                  */
/*  Copyright (c) 2014 Simarks. All rights reserved.                       */
/*                                                                         */
/*  Description: JMFCameraIOS                                              */
/*               U-Tad - Práctica iOS Avanzado                             */
/*               Settings View Controller Class implementation file        */
/*                                                                         */
/*       Author: Jorge Marcos Fernandez                                    */
/*                                                                         */
/***************************************************************************/
#import "JMFCameraIOS_SettingsViewController.h"

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  Defines                                                                */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
#define PREFERENCE_SYNC_TO_FLKR_KEY             @"PreferenceSyncToFlickrKey"
#define PREFERENCE_SYNC_FREQUENCY               @"PreferenceSyncFrequencyKey"

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  JMFCameraIOS_SettingsViewController Class Interface                    */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@interface JMFCameraIOS_SettingsViewController ()
{
    NSArray*            frequencyStrings;
    NSArray*            frecuencyValues;
    NSUserDefaults*     appPreferences;
    BOOL                bSyncToFlickr;
    int                 iSyncFrequency;
}

@end

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  JMFCameraIOS_SettingsViewController Class Implemantation               */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@implementation JMFCameraIOS_SettingsViewController

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
/*  initWithModel:                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (id)initWithModel:(JMFCoreDataStack *)model
{
    self = [super initWithNibName:nil bundle:nil];
    if( self )
    {
        self.model = model;
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
/*  viewDidLoad                                                            */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.title = NSLocalizedString( @"IDS_SETTINGS", nil );
    
    //Containers
    self.iboFlickrSyncContainer.layer.borderWidth = self.iboFrequencyContainer.layer.borderWidth = self.iboDropContainer.layer.borderWidth = 1;
    self.iboFlickrSyncContainer.layer.borderColor = self.iboFrequencyContainer.layer.borderColor = self.iboDropContainer.layer.borderColor = [Rgb2UIColor( 200, 200, 200 ) CGColor];

    //Titles
    self.iboFlickrSyncTitle.text = NSLocalizedString( @"IDS_FLICKR_SYNC", nil );
    self.iboDatabaseTitle.text   = NSLocalizedString( @"IDS_DATABASE", nil );

    //Labels
    self.iboFlickrSyncLabel.text = NSLocalizedString( @"IDS_FLICKR_SYNC_PICTURES", nil );
    self.iboFrequencyLabel.text  = NSLocalizedString( @"IDS_FREQUENCY", nil );
    self.iboDropLabel.text       = NSLocalizedString( @"IDS_DROP_DATABASE", nil );

    //Frecuency
    NSString* minute = NSLocalizedString( @"IDS_MINUTE", nil );
    frequencyStrings = [NSArray arrayWithObjects:[NSString stringWithFormat:@"15 %@s",  minute],
                                                 [NSString stringWithFormat:@"30 %@s",  minute],
                                                 [NSString stringWithFormat:@"45 %@s",  minute],
                                                 [NSString stringWithFormat:@"60 %@s",  minute],
                                                 [NSString stringWithFormat:@"90 %@s",  minute],
                                                 [NSString stringWithFormat:@"120 %@s", minute],
                                                 nil];
    frecuencyValues = [NSArray arrayWithObjects:@15, @30, @45, @60, @90, @120, nil];
    self.iboFrequencySetepper.maximumValue = 5;

    //Database
    self.iboDropSwitch.on = NO;
    
    //Read Defaults
    appPreferences = [NSUserDefaults standardUserDefaults];
    bSyncToFlickr  = NO;
    bSyncToFlickr  = [[appPreferences objectForKey:PREFERENCE_SYNC_TO_FLKR_KEY] boolValue];
    iSyncFrequency = 0;
    iSyncFrequency = [[appPreferences objectForKey:PREFERENCE_SYNC_FREQUENCY] intValue];
    self.iboFrequencySetepper.value = (double)iSyncFrequency;

    self.iboFlickrsyncSwitch.on = bSyncToFlickr;
    self.iboFrequencyValue.text = [frequencyStrings objectAtIndex:iSyncFrequency];
    self.iboFrequencySetepper.enabled = bSyncToFlickr;
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
/*  onSyncPicturesChanged:                                                 */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (IBAction)onSyncPicturesChanged:(id)sender
{
    bSyncToFlickr = self.iboFlickrsyncSwitch.on;
    self.iboFrequencySetepper.enabled = bSyncToFlickr;
    [appPreferences setObject:[NSNumber numberWithBool:bSyncToFlickr] forKey:PREFERENCE_SYNC_TO_FLKR_KEY];
    [appPreferences synchronize];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  onFrequencyValueChanged:                                               */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (IBAction)onFrequencyValueChanged:(id)sender
{
    iSyncFrequency = (double)self.iboFrequencySetepper.value;
    [appPreferences setObject:[NSNumber numberWithInt:iSyncFrequency] forKey:PREFERENCE_SYNC_FREQUENCY];
    [appPreferences synchronize];
    self.iboFrequencyValue.text = [frequencyStrings objectAtIndex:iSyncFrequency];    
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  onDropDatabaseChanged:                                                 */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (IBAction)onDropDatabaseChanged:(id)sender
{
    NSString* IDS_OK        = NSLocalizedString( @"IDS_OK", nil );
    NSString* IDS_CANCEL    = NSLocalizedString( @"IDS_CANCEL", nil );
    NSString* IDS_TITLE     = NSLocalizedString( @"IDS_DROP_DATABASE", nil );
    NSString* IDS_MESSAGE   = NSLocalizedString( @"IDS_CONFIRM_DROP_DATABASE", nil );
    
    UIActionSheet* actionSheet = [[UIActionSheet alloc]initWithTitle:IDS_MESSAGE
                                                            delegate:nil
                                                   cancelButtonTitle:IDS_CANCEL
                                              destructiveButtonTitle:IDS_OK
                                                   otherButtonTitles:nil];
    [actionSheet showInView:self.view withCompletion:^( UIActionSheet* actionSheet, NSInteger buttonIndex )
    {
        if( buttonIndex == 0 )
        {
            NSError* error = nil;
            if( ( error = [JMFUtility emptyApplicationDirectories ] ) == nil )
            {
                error = [self.model dropDatabaseData];
                [UIApplication sharedApplication]ex
            }
            NSString* IDS_RESULT_MESSAGE = ( error == nil ) ? NSLocalizedString( @"IDS_DATABASE_DROPPED_SUCCESSFULLY", nil )
                                                            : NSLocalizedString( @"IDS_DATABASE_DROPPED_WITH_ERROR", nil );
            [[[UIAlertView alloc]initWithTitle:IDS_TITLE message:IDS_RESULT_MESSAGE delegate:nil cancelButtonTitle:IDS_OK otherButtonTitles:nil] show];
        }
        self.iboDropSwitch.on = NO;
    }];

}
@end
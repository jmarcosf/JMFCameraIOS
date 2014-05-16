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
#define PREFERENCE_SYNC_FREQUENCY_KEY           @"PreferenceSyncFrequencyKey"
#define PREFERENCE_FLICKR_TOKEN_KEY             @"PreferenceFlickrTokenKey"
#define PREFERENCE_FLICKR_TOKEN_SECRET_KEY      @"PreferenceFlickrTokenSecretKey"

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
    JMFFlickrOAuth*     flickrOAuth;
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
    self.title = ResString( @"IDS_SETTINGS" );
    
    //Navigation Bar Buttons
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector( onDoneClicked: )];
    
    //Containers
    self.iboFlickrSyncContainer.layer.borderWidth = self.iboFrequencyContainer.layer.borderWidth = self.iboDropContainer.layer.borderWidth = 1;
    self.iboFlickrSyncContainer.layer.borderColor = self.iboFrequencyContainer.layer.borderColor = self.iboDropContainer.layer.borderColor = [Rgb2UIColor( 200, 200, 200 ) CGColor];

    //Titles
    self.iboFlickrSyncTitle.text = ResString( @"IDS_FLICKR_SYNC" );
    self.iboDatabaseTitle.text   = ResString( @"IDS_DATABASE" );

    //Labels
    self.iboFlickrSyncLabel.text = ResString( @"IDS_FLICKR_SYNC_PICTURES" );
    self.iboFrequencyLabel.text  = ResString( @"IDS_FREQUENCY" );
    self.iboDropLabel.text       = ResString( @"IDS_DROP_DATABASE" );

    //Frecuency
    NSString* minute = ResString( @"IDS_MINUTE" );
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
    iSyncFrequency = [[appPreferences objectForKey:PREFERENCE_SYNC_FREQUENCY_KEY] intValue];
    self.iboFrequencySetepper.value = (double)iSyncFrequency;

    self.iboFlickrSyncSwitch.on = bSyncToFlickr;
    self.iboFrequencyValue.text = [frequencyStrings objectAtIndex:iSyncFrequency];
    self.iboFrequencySetepper.enabled = bSyncToFlickr;
    
    flickrOAuth = [[JMFFlickrOAuth alloc]initWithWebView:self.iboWebView delegate:self];
    self.iboWebView.frame = self.view.frame;
    self.iboWebView.hidden = YES;
    self.iboWebView.layer.zPosition = 1000;
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
    bSyncToFlickr = self.iboFlickrSyncSwitch.on;
    NSString* flickrToken = [appPreferences valueForKey:PREFERENCE_FLICKR_TOKEN_KEY];
    
    if( bSyncToFlickr && !flickrToken )
    {
        self.iboWebView.hidden = NO;
        [flickrOAuth authenticate];
    }
    else
    {
        self.iboFrequencySetepper.enabled = bSyncToFlickr;
        [appPreferences setObject:[NSNumber numberWithBool:bSyncToFlickr] forKey:PREFERENCE_SYNC_TO_FLKR_KEY];
        [appPreferences synchronize];
    }
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  onDoneClicked:                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (IBAction)onDoneClicked:(id)sender
{

    CATransition *transition = [CATransition animation];
    transition.duration = 0.45;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionFromRight;
    [transition setType:kCATransitionPush];
    transition.subtype = kCATransitionFromRight;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController popViewControllerAnimated:NO];
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
    [appPreferences setObject:[NSNumber numberWithInt:iSyncFrequency] forKey:PREFERENCE_SYNC_FREQUENCY_KEY];
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
    NSString* IDS_OK        = ResString( @"IDS_OK" );
    NSString* IDS_CANCEL    = ResString( @"IDS_CANCEL" );
    NSString* IDS_TITLE     = ResString( @"IDS_DATABASE" );
    NSString* IDS_MESSAGE   = ResString( @"IDS_CONFIRM_DROP_DATABASE" );
    
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
            }
            NSString* IDS_RESULT_MESSAGE = ( error == nil ) ? ResString( @"IDS_DATABASE_DROPPED_SUCCESSFULLY" )
                                                            : ResString( @"IDS_DATABASE_DROPPED_WITH_ERROR" );
            [[[UIAlertView alloc]initWithTitle:IDS_TITLE message:IDS_RESULT_MESSAGE delegate:nil cancelButtonTitle:IDS_OK otherButtonTitles:nil] show];
        }
        self.iboDropSwitch.on = NO;
    }];
}

#pragma mark - JMFFlickrOAuthDelegate
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  JMFFlickrOAuthDelegate Methods                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  flickrDidAuthorize:                                                    */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)flickrDidAuthorize:(JMFFlickrOAuth*)flickr
{
    self.iboWebView.hidden = YES;
    [self.iboWebView loadHTMLString:nil baseURL:nil];
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Flickr" message:ResString( @"IDS_FLICKR_AUTHENTICATION_SUCCESS" ) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
    [appPreferences setValue:flickr.token forKey:PREFERENCE_FLICKR_TOKEN_KEY];
    [appPreferences setValue:flickr.tokenSecret forKey:PREFERENCE_FLICKR_TOKEN_SECRET_KEY];
    [appPreferences synchronize];
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  flickrDidNotAuthorize:                                                 */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)flickrDidNotAuthorize:(JMFFlickrOAuth*)flickr error:(NSError *)error
{
    self.iboWebView.hidden = YES;
    [self.iboWebView loadHTMLString:nil baseURL:nil];
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Flickr" message:ResString( @"IDS_FLICKR_AUTHENTICATION_FAILURE" ) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

@end
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
/*  JMFCameraIOS_SettingsViewController Class Interface                    */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@interface JMFCameraIOS_SettingsViewController ()
{
    NSArray*            intervalStrings;
    NSArray*            intervalValues;
    NSUserDefaults*     appPreferences;
    BOOL                bSyncToFlickr;
    int                 iSyncInterval;
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
    self.iboFlickrSyncContainer.layer.borderWidth = self.iboIntervalContainer.layer.borderWidth = self.iboDropContainer.layer.borderWidth = 1;
    self.iboFlickrSyncContainer.layer.borderColor = self.iboIntervalContainer.layer.borderColor = self.iboDropContainer.layer.borderColor = [Rgb2UIColor( 200, 200, 200 ) CGColor];

    //Titles
    self.iboFlickrSyncTitle.text = ResString( @"IDS_FLICKR_SYNC" );
    self.iboDatabaseTitle.text   = ResString( @"IDS_DATABASE" );

    //Labels
    self.iboFlickrSyncLabel.text = ResString( @"IDS_FLICKR_SYNC_PICTURES" );
    self.iboIntervalLabel.text   = ResString( @"IDS_INTERVAL" );
    self.iboDropLabel.text       = ResString( @"IDS_DROP_DATABASE" );

    //Interval
    NSString* second = ResString( @"IDS_SECOND" );
    NSString* minute = ResString( @"IDS_MINUTE" );
    intervalStrings  = [NSArray arrayWithObjects:[NSString stringWithFormat:@"5 %@s",  second],
                                                 [NSString stringWithFormat:@"10 %@s", second],
                                                 [NSString stringWithFormat:@"20 %@s", second],
                                                 [NSString stringWithFormat:@"30 %@s", second],
                                                 [NSString stringWithFormat:@"45 %@s", second],
                                                 [NSString stringWithFormat:@"1 %@",   minute],
                                                 [NSString stringWithFormat:@"2 %@s",  minute],
                                                 [NSString stringWithFormat:@"3 %@s",  minute],
                                                 [NSString stringWithFormat:@"5 %@s",  minute],
                                                 [NSString stringWithFormat:@"10 %@s", minute],
                                                 nil];
    intervalValues = [NSArray arrayWithObjects:@5, @10, @20, @30, @45, @60, @120, @180, @300, @600, nil];
    self.iboIntervalSetepper.maximumValue = 9;

    //Database
    self.iboDropSwitch.on = NO;
    
    //Read Defaults
    appPreferences = [NSUserDefaults standardUserDefaults];
    bSyncToFlickr  = NO;
    bSyncToFlickr  = [[appPreferences objectForKey:PREFERENCE_SYNC_TO_FLKR_KEY] boolValue];
    iSyncInterval = [[intervalValues objectAtIndex:0]intValue];
    iSyncInterval = [[appPreferences objectForKey:PREFERENCE_SYNC_INTERVAL_KEY] intValue];
    self.iboIntervalSetepper.value = [intervalValues indexOfObject:[NSNumber numberWithInt:iSyncInterval]];

    self.iboFlickrSyncSwitch.on = bSyncToFlickr;
    self.iboIntervalValue.text = [intervalStrings objectAtIndex:self.iboIntervalSetepper.value];
    self.iboIntervalSetepper.enabled = bSyncToFlickr;
    
    //JMFFlickrOAuth
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat navigationBarHeight = self.navigationController.navigationBar.frame.size.height;
    CGRect Rect = CGRectMake( 0, 0, screenRect.size.width, screenRect.size.height - statusBarHeight - navigationBarHeight );
    self.iboWebView.frame = Rect;
    self.iboWebView.hidden = YES;
    self.iboWebView.layer.zPosition = 10;
    flickrOAuth = [[JMFFlickrOAuth alloc]initWithWebView:self.iboWebView delegate:self];
    flickrOAuth.activityIndicator = self.iboActivityIndicator;
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  viewWillAppear:                                                        */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.iboActivityIndicator.hidden = YES;
    self.iboActivityIndicator.layer.zPosition = 15;
    [self.iboActivityIndicator stopAnimating];
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
        self.iboActivityIndicator.hidden = NO;
        [self.iboActivityIndicator startAnimating];
        [flickrOAuth authenticate];
    }
    else
    {
        self.iboIntervalSetepper.enabled = bSyncToFlickr;
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
/*  onIntervalValueChanged:                                                */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (IBAction)onIntervalValueChanged:(id)sender
{
    iSyncInterval = [[intervalValues objectAtIndex:(int)self.iboIntervalSetepper.value]intValue];
    [appPreferences setObject:[NSNumber numberWithInt:iSyncInterval] forKey:PREFERENCE_SYNC_INTERVAL_KEY];
    [appPreferences synchronize];
    self.iboIntervalValue.text = [intervalStrings objectAtIndex:(int)self.iboIntervalSetepper.value];
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
    
    [appPreferences setObject:[NSNumber numberWithBool:YES] forKey:PREFERENCE_SYNC_TO_FLKR_KEY];
    [appPreferences setValue:flickr.token forKey:PREFERENCE_FLICKR_TOKEN_KEY];
    [appPreferences setValue:flickr.tokenSecret forKey:PREFERENCE_FLICKR_TOKEN_SECRET_KEY];
    [appPreferences synchronize];
    self.iboFlickrSyncSwitch.on = YES;
    self.iboIntervalSetepper.enabled = YES;
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
    
    [appPreferences setObject:[NSNumber numberWithBool:NO] forKey:PREFERENCE_SYNC_TO_FLKR_KEY];
    [appPreferences synchronize];
    self.iboFlickrSyncSwitch.on = NO;
    self.iboIntervalSetepper.enabled = NO;
}

@end
/***************************************************************************/
/*                                                                         */
/*  JMFCameraIOS_MapViewController.m                                       */
/*  Copyright (c) 2014 Simarks. All rights reserved.                       */
/*                                                                         */
/*  Description: JMFCameraIOS                                              */
/*               U-Tad - Práctica iOS Avanzado                             */
/*               Map View Controller Class implementation file             */
/*                                                                         */
/*       Author: Jorge Marcos Fernandez                                    */
/*                                                                         */
/***************************************************************************/
#import "JMFCameraIOS_MapViewController.h"

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*  JMFCameraIOS_MapViewController Class Implemantation                    */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
@implementation JMFCameraIOS_MapViewController

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
/*  initWithLongitud:andLatitude:                                          */
/*                                                                         */
/*                                                                         */
/***************************************************************************/
- (id)initWithLongitude:(NSNumber*)longitude latitude:(NSNumber*)latitude andGeoPosition:(NSString*)geoPosition
{
    if( self = [super initWithNibName:nil bundle:nil] )
    {
        self.location = CLLocationCoordinate2DMake( [longitude doubleValue], [latitude doubleValue] );
        self.geoPosition = geoPosition;
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
    self.title = NSLocalizedString( @"IDS_LOCATION", nil );
    
    [self.iboMapView setMapType:MKMapTypeHybrid];
    self.iboMapView.rotateEnabled = YES;
    self.iboMapView.zoomEnabled = YES;
    self.iboMapView.showsBuildings = YES;
    self.iboMapView.showsUserLocation = YES;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance( self.location, 5000000, 5000000 );
    MKCoordinateRegion adjustedRegion = [self.iboMapView regionThatFits:viewRegion];
    [self.iboMapView setRegion:adjustedRegion animated:YES];
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time( DISPATCH_TIME_NOW, (int64_t)( delayInSeconds * NSEC_PER_SEC ) );
    __block MKMapView* weakMap = self.iboMapView;
    dispatch_after( popTime, dispatch_get_main_queue(), ^(void)
    {
        MKPointAnnotation* pinMark = [[MKPointAnnotation alloc]init];
        pinMark.coordinate = self.location;
        pinMark.title = NSLocalizedString( @"IDS_PICTURE_LOCATION", nil );
        pinMark.subtitle = self.geoPosition;
        [weakMap addAnnotation:pinMark];
    } );
}

/***************************************************************************/
/*                                                                         */
/*                                                                         */
/*  viewVillAppear:                                                        */
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

@end
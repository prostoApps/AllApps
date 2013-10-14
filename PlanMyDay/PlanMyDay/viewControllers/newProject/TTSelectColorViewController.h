//
//  TTSelectColorViewController.h
//  PlanMyDay
//
//  Created by Torasike on 30.09.13.
//  Copyright (c) 2013 prosto*. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "TTApplicationManager.h"

@interface TTSelectColorViewController : UIViewController <UICollectionViewDataSource ,UICollectionViewDelegate>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionViewOfColors;

@end

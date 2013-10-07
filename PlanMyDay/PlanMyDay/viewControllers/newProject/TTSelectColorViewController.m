//
//  TTSelectColorViewController.m
//  PlanMyDay
//
//  Created by Torasike on 30.09.13.
//  Copyright (c) 2013 prosto*. All rights reserved.
//

#import "TTSelectColorViewController.h"

#define COLOR_1 @"ff0000"
#define COLOR_2 @"00ff00"
#define COLOR_3 @"0000ff"


@interface TTSelectColorViewController ()
{
    NSArray * arrayOfColors;
}

@end

@implementation TTSelectColorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        arrayOfColors = [[NSArray alloc] initWithObjects:COLOR_1,COLOR_2,COLOR_3, nil];
        //self.collectionViewOfColors = [[UICollectionView alloc] init];
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [arrayOfColors count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"ColorCell"];
    
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ColorCell"
                                                                           forIndexPath:indexPath];
    
    cell.backgroundColor = [[TTAppDataManager sharedAppDataManager]colorWithHexString:[arrayOfColors objectAtIndex:indexPath.item]];

    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [[TTAppDataManager sharedAppDataManager] saveNewProjectFormDataValue:[arrayOfColors objectAtIndex:indexPath.item] byIndexPath:[[TTApplicationManager sharedApplicationManager] ipNewProjectSelectProperty]];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

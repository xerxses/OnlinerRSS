//
//  NewsFeedTableViewCell.h
//  OnlinerRSS
//
//  Created by Vladislav on 15.02.16.
//  Copyright © 2016 domik. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NewsFeedTableViewCell : UITableViewCell


@property (strong, nonatomic) UIImageView *newsImage;
@property (strong, nonatomic) UILabel *newsTitle;
@property (strong, nonatomic) UILabel *newsPubDate;
@property (strong, nonatomic) UILabel *newsDescription;


@end

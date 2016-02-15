//
//  NewsFeedTableViewCell.m
//  OnlinerRSS
//
//  Created by Vladislav on 15.02.16.
//  Copyright © 2016 domik. All rights reserved.
//

#import "NewsFeedTableViewCell.h"


#define kLabelHorizontalInsets      15.0f
#define kLabelVerticalInsets        5.0f


@interface NewsFeedTableViewCell ()

@property (nonatomic, assign) BOOL didSetupConstraints;

@end


@implementation NewsFeedTableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.newsImage = [UIImageView newAutoLayoutView];
        
        self.newsTitle = [UILabel newAutoLayoutView];
        [self.newsTitle setNumberOfLines:0];
        [self.newsTitle setTextAlignment:NSTextAlignmentLeft];
        [self.newsTitle setTextColor:[UIColor blueColor]];
        [self.newsTitle setFont:[UIFont systemFontOfSize:16]];
        
        self.newsPubDate = [UILabel newAutoLayoutView];
        [self.newsPubDate setNumberOfLines:1];
        [self.newsPubDate setTextAlignment:NSTextAlignmentLeft];
        [self.newsPubDate setTextColor:[UIColor darkGrayColor]];
        [self.newsPubDate setFont:[UIFont systemFontOfSize:10]];
        
        self.newsDescription = [UILabel newAutoLayoutView];
        [self.newsDescription setNumberOfLines:0];
        [self.newsDescription setTextAlignment:NSTextAlignmentLeft];
        [self.newsDescription setTextColor:[UIColor darkGrayColor]];
        [self.newsDescription setFont:[UIFont systemFontOfSize:14]];
        
        [self.contentView addSubview:self.newsImage];
        [self.contentView addSubview:self.newsTitle];
        [self.contentView addSubview:self.newsPubDate];
        [self.contentView addSubview:self.newsDescription];
    }
    
    return self;
}


- (void)updateConstraints
{
    if (!self.didSetupConstraints)
    {
        self.contentView.bounds = CGRectMake(0.0f, 0.0f, 99999.0f, 99999.0f);
        //image
        [NSLayoutConstraint autoSetPriority:UILayoutPriorityRequired forConstraints:^{
            [self.newsImage autoSetContentCompressionResistancePriorityForAxis:ALAxisVertical];
        }];
        [self.newsImage autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kLabelVerticalInsets];
        [self.newsImage autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kLabelHorizontalInsets];
        [self.newsImage autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kLabelHorizontalInsets];
//        [self.newsImage autoSetDimension:ALDimensionWidth toSize:220];
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        [self.newsImage autoSetDimension:ALDimensionHeight toSize:screenWidth/2];
        
//        [self.newsImage autoConstrainAttribute:ALAttributeWidth toAttribute:ALAttributeHeight ofView:self.newsImage withMultiplier:0.5f];
//        [self.newsImage autoMatchDimension:ALDimensionWidth toDimension:ALDimensionHeight ofView:self.newsImage withMultiplier:0.5f];
        
        //title
        [self.newsTitle autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.newsImage withOffset:kLabelVerticalInsets relation:NSLayoutRelationGreaterThanOrEqual];
        [NSLayoutConstraint autoSetPriority:UILayoutPriorityRequired forConstraints:^{
            [self.newsTitle autoSetContentCompressionResistancePriorityForAxis:ALAxisVertical];
        }];
        [self.newsTitle autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kLabelHorizontalInsets];
        [self.newsTitle autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kLabelHorizontalInsets];
        //pubDate
        [self.newsPubDate autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.newsTitle withOffset:kLabelVerticalInsets relation:NSLayoutRelationGreaterThanOrEqual];
        [NSLayoutConstraint autoSetPriority:UILayoutPriorityRequired forConstraints:^{
            [self.newsPubDate autoSetContentCompressionResistancePriorityForAxis:ALAxisVertical];
        }];
        [self.newsPubDate autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kLabelHorizontalInsets];
        [self.newsPubDate autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kLabelHorizontalInsets];
        //shortDesc
        [self.newsDescription autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.newsPubDate withOffset:kLabelVerticalInsets relation:NSLayoutRelationGreaterThanOrEqual];
        
        [NSLayoutConstraint autoSetPriority:UILayoutPriorityRequired forConstraints:^{
            [self.newsDescription autoSetContentCompressionResistancePriorityForAxis:ALAxisVertical];
        }];
        [self.newsDescription autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kLabelHorizontalInsets];
        [self.newsDescription autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kLabelHorizontalInsets];
//        [self.newsDescription autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kLabelVerticalInsets];
        [self.newsDescription autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kLabelVerticalInsets relation:NSLayoutRelationGreaterThanOrEqual];
        
        self.didSetupConstraints = YES;
    }
    
    [super updateConstraints];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // Make sure the contentView does a layout pass here so that its subviews have their frames set, which we
    // need to use to set the preferredMaxLayoutWidth below.
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    
    // Set the preferredMaxLayoutWidth of the mutli-line bodyLabel based on the evaluated width of the label's frame,
    // as this will allow the text to wrap correctly, and as a result allow the label to take on the correct height.
    self.newsDescription.preferredMaxLayoutWidth = CGRectGetWidth(self.newsDescription.frame);
}


@end

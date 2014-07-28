//
//  BubbleView.h
//  
//
//  Created by admin on 7/21/14.
//  Copyright (c) 2014 Jan Timar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BubbleView : UIView

typedef enum BubbleType : NSInteger {
    kSpeech,
    kThink
} BubbleType;

-(id)initWithText:(NSString *)text textColor:(UIColor *)textColor fillColor:(UIColor *)fillColor strokeColor:(UIColor *)strokeColor lineWidth:(float)lineWidth angle:(int)angle oppacity:(float)oppacity type:(BubbleType)type inFrame:(CGRect)frame;

@property (nonatomic,strong) NSString *text;

@property (nonatomic) int angle;

@property (nonatomic,strong) UIColor *textColor;

@property (nonatomic,strong) UIColor *strokeColor;

@property (nonatomic,strong) UIColor *fillColor;

@property (nonatomic) float oppacity;

@property (nonatomic) float bubbleLineWidth;

@property(nonatomic) BubbleType type;

// if is 0 or less then is set to 30.0f
@property(nonatomic) float fontSize;

@end

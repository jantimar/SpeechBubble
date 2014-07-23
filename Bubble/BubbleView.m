//
//  BubbleView.m
//  
//
//  Created by admin on 7/21/14.
//  Copyright (c) 2014 Jan Timar. All rights reserved.
//

#import "BubbleView.h"

@interface BubbleView()

@end

@implementation BubbleView


-(id)initWithText:(NSString *)text textColor:(UIColor *)textColor fillColor:(UIColor *)fillColor strokeColor:(UIColor *)strokeColor lineWidth:(float)lineWidth angle:(int)angle oppacity:(float)oppacity type:(BubbleType)type inFrame:(CGRect)frame
{
    self = [self initWithFrame:frame];
    if(self){
        _text = text;
        _textColor = textColor;
        _fillColor = fillColor;
        _strokeColor = strokeColor;
        _bubbleLineWidth = lineWidth;
        _angle = angle;
        _oppacity = oppacity;
        _type = type;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

// setters and getters
@synthesize fillColor = _fillColor;
@synthesize strokeColor = _strokeColor;
@synthesize textColor = _textColor;

-(void)setType:(BubbleType)type
{
    _type = type;
    [self setNeedsDisplay];
}

-(UIColor *)fillColor
{
    if(!_fillColor) _fillColor = [UIColor clearColor];
    return _fillColor;
}

-(void)setFillColor:(UIColor *)fillColor
{
    _fillColor = fillColor;
    [self setNeedsDisplay];
}

-(UIColor *)strokeColor
{
    if(!_strokeColor) _strokeColor = [UIColor blackColor];
    return _strokeColor;
}

-(void)setStrokeColor:(UIColor *)strokeColor
{
    _strokeColor = strokeColor;
    [self setNeedsDisplay];
}

-(UIColor *)textColor
{
    if(!_textColor) _textColor = [UIColor blackColor];
    return _textColor;
}

-(void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    [self setNeedsDisplay];
}

-(void)setAngle:(int)angle
{
    if(angle <= 360 && angle >= 0){
        _angle = angle;
        [self setNeedsDisplay];
    }
}

-(void)setOppacity:(float)oppacity
{
    _oppacity = oppacity;
    [self setNeedsDisplay];
}

-(void)setBubbleLineWidth:(float)bubbleLineWidth
{
    _bubbleLineWidth = bubbleLineWidth;
    [self setNeedsDisplay];
}

-(CGRect)contentRect
{
    CGRect bounds;
    if(self.bounds.size.height > self.bounds.size.width){
        bounds.origin = CGPointMake(1, self.bounds.size.height/2.0 - self.bounds.size.width/2.0 + 1);
        bounds.size = CGSizeMake(self.bounds.size.width - 2, self.bounds.size.width/2.0f - 2);
    }
    else{
        bounds.origin = CGPointMake(self.bounds.size.width/2.0 - self.bounds.size.height/2.0 + 1, self.bounds.size.height/4.0f + 1);
        bounds.size = CGSizeMake(self.bounds.size.height-2, self.bounds.size.height/2.0f -2);
    }
    return bounds;
}

-(void)setText:(NSString *)text
{
    _text = text;
    [self setNeedsDisplay];
}

// drawing methods

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [self drawCircleInRect:self.contentRect];
}

-(void)drawCircleInRect:(CGRect)rect
{
    [super drawRect:rect];
    
    // Fill background
    [[UIColor clearColor] setFill];
    UIRectFill(rect);
    
    // Get context
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGRect bubbleRect = self.contentRect;
    
    // Setup drawing values
    CGContextSetFillColorWithColor(ctx, self.fillColor.CGColor);
    CGContextSetStrokeColorWithColor(ctx, [self.strokeColor colorWithAlphaComponent:self.oppacity].CGColor);
    CGContextSetLineWidth(ctx, self.bubbleLineWidth);
    
    
    // Draw ellipse
    CGContextFillEllipseInRect(ctx, bubbleRect);
    CGContextStrokeEllipseInRect(ctx, bubbleRect);
    
    CGPoint p1 = CGPointZero;
    CGPoint p2 = CGPointZero;
    CGPoint p3 = CGPointZero;
    CGPoint endPoint = CGPointZero;
    
    
    p1 = [self pointOnEllipseRect:bubbleRect withAngle:((self.angle - 15.0f > 0) ? (self.angle - 15.0f + 360.0f) : (self.angle - 15.0f))];
    p2 = [self pointOnEllipseRect:bubbleRect withAngle:((self.angle + 15.0f > 0) ? (self.angle + 15.0f - 360.0f) : (self.angle + 15.0f))];
    p3 = CGPointMake(p2.x, p2.y);
    endPoint = [self pointOnEllipseRect:self.bounds withAngle:self.angle];    
    
    
    // Now draw the bubble arrow
    
    switch (self.type) {
        case kSpeech:{
            // Fill
            CGContextBeginPath(ctx);
            CGContextMoveToPoint(ctx, endPoint.x, endPoint.y);
            CGContextAddLineToPoint(ctx, p1.x, p1.y);
            CGContextAddQuadCurveToPoint(ctx, p3.x, p3.y, p2.x, p2.y);
            CGContextClosePath(ctx);
            CGContextFillPath(ctx);
            
            // Stroke
            CGContextBeginPath(ctx);
            CGContextMoveToPoint(ctx, endPoint.x, endPoint.y);
            CGContextAddLineToPoint(ctx, p1.x, p1.y);
            CGContextMoveToPoint(ctx, endPoint.x, endPoint.y);
            CGContextAddLineToPoint(ctx, p2.x, p2.y);
            CGContextStrokePath(ctx);
        }
            break;
        case kThink:{
            CGRect littleBubble1 = CGRectMake(
                                              (self.angle > 90 && self.angle <= 270) ? (endPoint.x + bubbleRect.size.width/5.0f) : (endPoint.x - bubbleRect.size.width/5.0f),
                                              (self.angle > 0 && self.angle <= 180) ? (endPoint.y - bubbleRect.size.height/5.0f) : (endPoint.y + bubbleRect.size.height/5.0f),
                                              bubbleRect.size.width/30.0f, bubbleRect.size.height/30.0f);
            
            
            CGRect littleBubble2 = CGRectMake(
                                              (self.angle > 90 && self.angle <= 270) ? (endPoint.x + bubbleRect.size.width/4.0f) : (endPoint.x - bubbleRect.size.width/4.0f),
                                              (self.angle > 0 && self.angle <= 180) ? (endPoint.y - bubbleRect.size.height/4.0f) : (endPoint.y + bubbleRect.size.height/4.0f),
                                              bubbleRect.size.width/20.0f, bubbleRect.size.height/20.0f);
            
            
            CGRect littleBubble3 = CGRectMake(
                                              (self.angle > 90 && self.angle <= 270) ? (endPoint.x + bubbleRect.size.width/3.0f) : (endPoint.x - bubbleRect.size.width/3.0f),
                                              (self.angle > 0 && self.angle <= 180) ? (endPoint.y - bubbleRect.size.height/3.0f) : (endPoint.y + bubbleRect.size.height/3.0f),
                                              bubbleRect.size.width/10.0f, bubbleRect.size.height/10.0f);
            
            
            CGContextFillEllipseInRect(ctx, littleBubble1);
            CGContextStrokeEllipseInRect(ctx, littleBubble1);
            CGContextFillEllipseInRect(ctx, littleBubble2);
            CGContextStrokeEllipseInRect(ctx, littleBubble2);
            CGContextFillEllipseInRect(ctx, littleBubble3);
            CGContextStrokeEllipseInRect(ctx, littleBubble3);
        }
            break;
            
        default:
            break;
    }
    
    
    // Draw text
    BOOL textFits = NO;
    float fontSize = 30.0f;
    float fontSizePaddingWidth = 60.0f;
    float fontSizePaddingHeight = 2.0f;
    
    NSString *content = [self stringToLines:self.text whereOneLineHaveMinimumChars:10];
    while(!textFits) {
        // Create attributes
        
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIFont fontWithName:@"Arial" size:fontSize], NSFontAttributeName,
                                    self.textColor, NSForegroundColorAttributeName,
                                    nil];
        
        NSAttributedString *currentText = [[NSAttributedString alloc] initWithString:content attributes: attributes];
        
        
        CGSize attrSize = [currentText size];
        if(attrSize.width > bubbleRect.size.width - fontSizePaddingWidth || attrSize.height > bubbleRect.size.height - fontSizePaddingHeight){
            fontSize-=2.0f;
        }
        else {
            float textX = bubbleRect.origin.x + bubbleRect.size.width/2 - attrSize.width/2;
            float textY = bubbleRect.origin.y + bubbleRect.size.height/2 - attrSize.height/2;
            [currentText drawAtPoint:CGPointMake(textX, textY)];
            
            textFits = YES;
        }
        
        // Stop infinite looping
        if(fontSize <= 1.0f) {
            textFits = YES;
        }
    }
}

-(NSString *)stringToLines:(NSString *)inputString whereOneLineHaveMinimumChars:(int)minimumChars
{
    NSUInteger length = [inputString length];
    for(int positionActualChar = minimumChars;positionActualChar < length;positionActualChar++){
        
        unichar actualChar = [inputString characterAtIndex:positionActualChar];
        if(actualChar == ' '){
            inputString = [inputString stringByReplacingCharactersInRange:NSMakeRange(positionActualChar, 0) withString:@"\n"];
            positionActualChar += minimumChars;
        }
    }
    return inputString;
}

-(CGPoint)pointOnEllipseRect:(CGRect)ellipseRect withAngle:(CGFloat)angle
{
    // Get the center of the ellipse
    CGPoint center = CGPointMake(ellipseRect.origin.x+ellipseRect.size.width/2, ellipseRect.origin.y+ellipseRect.size.height/2);
    
    // Convert angle to radians
    float angleRadians = DegreesToRadians(angle);
    
    // Calculate a, b
    float a = ellipseRect.size.width/2;
    float b = ellipseRect.size.height/2;
    
    // x = a cos t
    // y = b sin t
    float x = center.x + a * cosf(angleRadians);
    float y = center.y + b * sinf(angleRadians);
    
    // Create point
    CGPoint point = CGPointMake(x, y);
    
    return point;
}

CGFloat DegreesToRadians(CGFloat degrees)
{
    return degrees * M_PI / 180;
};

CGFloat RadiansToDegrees(CGFloat radians)
{
    return radians * 180 / M_PI;
};


@end

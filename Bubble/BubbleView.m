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
@synthesize fontSize = _fontSize;

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

-(float)fontSize
{
    if(_fontSize <= 0) return 30.0f;
    return _fontSize;
}

-(void)setFontSize:(float)fontSize
{
    _fontSize = fontSize;
    [self setNeedsDisplay];
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
    [super drawRect:rect];
    [self drawBabbleInRect:rect];
}

-(void)drawBabbleInRect:(CGRect)rect
{
    
    CGRect bubbleRect =  CGRectMake(rect.origin.x + rect.size.width/2.0f, rect.origin.y/2.0f + rect.size.height/2.0f, 0.0f, 0.0f);
    
    // Count bubble size depedency by text
    BOOL textFits = NO;
    float fontSize = self.fontSize;
    float fontSizePaddingWidth = 40.0f;
    float fontSizePaddingHeight = 40.0f;
    
    float bubbleSizePaddingWidth = 40.0f;
    float bubbleSizePaddingHeight = 40.0f;
    
    // set text view
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(bubbleRect.origin.x + fontSizePaddingWidth,
                                                                        bubbleRect.origin.y + fontSizePaddingHeight,
                                                                        bubbleRect.size.width - fontSizePaddingWidth*2,
                                                                        bubbleRect.size.height - fontSizePaddingHeight*2)];
    [textView setText:self.text];
    [textView setTextColor:self.textColor];
    [textView setBackgroundColor:[UIColor clearColor]];
    [textView setFont:[UIFont fontWithName:@"Arial" size:fontSize]];
    [textView setTextAlignment:NSTextAlignmentCenter];
    
    // count bubble size and font size
    while(!textFits) {
        [textView setFrame:CGRectMake(0,0,
                                     bubbleRect.size.width - fontSizePaddingWidth*2,
                                      bubbleRect.size.height - fontSizePaddingHeight*2)];
        
        [textView sizeToFit];
        
        if(textView.frame.size.width > bubbleRect.size.width - fontSizePaddingWidth*2 || textView.frame.size.height > bubbleRect.size.height - fontSizePaddingHeight*2){
            
            if(rect.size.height > bubbleRect.size.height + bubbleSizePaddingHeight && rect.size.width > bubbleRect.size.width + bubbleSizePaddingWidth){
                bubbleRect.size.height += 4.0f;
                bubbleRect.size.width += 8.0f;
                bubbleRect.origin.y -= 2.0f;
                bubbleRect.origin.x -= 4.0f;
            } else {
                fontSize -= 2.0f;
                [textView setFont:[UIFont fontWithName:@"Arial" size:fontSize]];
                [textView setTextAlignment:NSTextAlignmentCenter];
            }
        }
        else {
            CGRect newFrame = CGRectMake(bubbleRect.origin.x + bubbleRect.size.width/2.0f - textView.frame.size.width/2.0f,
                                         bubbleRect.origin.y + bubbleRect.size.height/2.0f - textView.frame.size.height/2.0f,
                                         textView.frame.size.width,
                                         textView.frame.size.height);
            [textView setFrame:newFrame];
            
            textFits = YES;
        }
        
        // Stop infinite looping
        if(fontSize <= 1.0f) {
            textFits = YES;
            self.frame = bubbleRect;
        }
    }
    
    // Fill background
    [[UIColor clearColor] setFill];
    UIRectFill(rect);
    
    // Get context
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // Setup drawing values
    CGContextSetFillColorWithColor(ctx, [self.fillColor colorWithAlphaComponent:self.oppacity].CGColor);
    CGContextSetStrokeColorWithColor(ctx, [self.strokeColor colorWithAlphaComponent:self.oppacity].CGColor);
    CGContextSetLineWidth(ctx, self.bubbleLineWidth);
    
    
    //Draw ellipse
    CGContextFillEllipseInRect(ctx, bubbleRect);
    
    // Draw the bubble arrow
    switch (self.type) {
        case kSpeech:{
            
            // Draw Strokes
            CGContextStrokeEllipseInRect(ctx, bubbleRect);
            
            /*CGContextSaveGState(ctx);
            CGPoint center = CGPointMake(bubbleRect.origin.x + bubbleRect.size.width / 2.0, bubbleRect.origin.y + bubbleRect.size.height / 2.0);
            UIBezierPath *clip = [UIBezierPath bezierPathWithArcCenter:center
                                                                radius:bubbleRect.size.width
                                                            startAngle:DegreesToRadians(self.angle + 15.0f)
                                                              endAngle:DegreesToRadians(self.angle - 15.0f)  clockwise:YES];
            
            [clip addLineToPoint:center];
            [clip closePath];
            [clip addClip]; UIBezierPath *arc = [UIBezierPath bezierPathWithOvalInRect:bubbleRect];
            
            //CGContextSetLineWidth(ctx, self.bubbleLineWidth);
            [arc setLineWidth:self.bubbleLineWidth];
            CGContextSetStrokeColorWithColor(ctx, [self.strokeColor colorWithAlphaComponent:self.oppacity].CGColor);
            [arc stroke];
            CGContextRestoreGState(ctx);*/
            
            CGPoint p1 = CGPointZero;
            CGPoint p2 = CGPointZero;
            CGPoint p3 = CGPointZero;
            CGPoint endPoint = CGPointZero;
            
            p1 = [self pointOnEllipseRect:bubbleRect withAngle:(self.angle + 15.0f)];
            p2 = [self pointOnEllipseRect:bubbleRect withAngle:(self.angle - 15.0f)];
            p3 = CGPointMake(p2.x, p2.y);
            endPoint = [self pointOnEllipseRect:self.bounds withAngle:self.angle];
            
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
            
            // Draw Strokes
            CGContextStrokeEllipseInRect(ctx, bubbleRect);
            
            CGRect littleBubble1;
            CGRect littleBubble2;
            CGRect littleBubble3;
            
            
            littleBubble1.size.height = bubbleRect.size.height/30.0f;
            littleBubble1.size.width = bubbleRect.size.width/30.0f;
            
            CGPoint littleBubblePoint1 = [self pointOnEllipseRect:CGRectMake(bubbleRect.origin.x - bubbleRect.size.width/10.0f*3.0f,
                                                                             bubbleRect.origin.y - bubbleRect.size.height/10.0f*3.0f,
                                                                             bubbleRect.size.width + (bubbleRect.size.width/10.0f*3.0f)*2.0f,
                                                                             bubbleRect.size.height + (bubbleRect.size.height/10.0f*3.0f)*2.0f)
                                                        withAngle:self.angle];
            
            littleBubble1.origin.y = littleBubblePoint1.y;
            littleBubble1.origin.x = littleBubblePoint1.x;
            
            
            //----
            littleBubble2.size.height = bubbleRect.size.height/20.0f;
            littleBubble2.size.width = bubbleRect.size.width/20.0f;
            
            
            CGPoint littleBubblePoint2 = [self pointOnEllipseRect:CGRectMake(bubbleRect.origin.x - bubbleRect.size.width/10.0f*2.0f,
                                                                             bubbleRect.origin.y - bubbleRect.size.height/10.0f*2.0f,
                                                                             bubbleRect.size.width + (bubbleRect.size.width/10.0f*2.0f)*2.0f,
                                                                             bubbleRect.size.height + (bubbleRect.size.height/10.0f*2.0f)*2.0f)
                                                        withAngle:self.angle];
            littleBubble2.origin.y = littleBubblePoint2.y;
            littleBubble2.origin.x = littleBubblePoint2.x;
            
            
            //----
            littleBubble3.size.height = bubbleRect.size.height/10.0f;
            littleBubble3.size.width = bubbleRect.size.width/10.0f;
            
            CGPoint littleBubblePoint3 = [self pointOnEllipseRect:CGRectMake(bubbleRect.origin.x - bubbleRect.size.width/10.0f,
                                                                             bubbleRect.origin.y - bubbleRect.size.height/10.0f,
                                                                             bubbleRect.size.width + (bubbleRect.size.width/10.0f)*2.0f,
                                                                             bubbleRect.size.height + (bubbleRect.size.height/10.0f)*2.0f)
                                                        withAngle:self.angle];
            
            littleBubble3.origin.y = littleBubblePoint3.y;
            littleBubble3.origin.x = littleBubblePoint3.x;
            
            
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
    for(UIView *view in [self subviews])
        [view removeFromSuperview];
    [self addSubview:textView];
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

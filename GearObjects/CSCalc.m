//
//  CSCalc.m
//  AppSlate
//
//  Created by 김 태한 on 12. 2. 24..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "CSCalc.h"

@implementation CSCalc

-(id) object
{
    return (csView);
}

//===========================================================================

-(void) setInput1Value:(NSNumber*) Value
{
    if( [Value isKindOfClass:[NSString class]] )
        value1 = [(NSString*)Value length];
    else if( [Value isKindOfClass:[NSNumber class]] )
        value1 = [Value floatValue];
}

-(NSNumber*) getInput1Value
{
    return [NSNumber numberWithFloat:value1];
}

-(void) setPlusValue:(NSNumber*) Value
{
    if( [Value isKindOfClass:[NSString class]] )
        value2 = [(NSString*)Value length];
    else if( [Value isKindOfClass:[NSNumber class]] )
        value2 = [Value floatValue];
    else
        return;
    
    if( USERCONTEXT.imRunning ){
        SEL act;
        NSNumber *nsMagicNum;
        
        act = ((NSValue*)[(NSDictionary*)[actionArray objectAtIndex:0] objectForKey:@"selector"]).pointerValue;
        if( nil != act ){
            nsMagicNum = [((NSDictionary*)[actionArray objectAtIndex:0]) objectForKey:@"mNum"];
            CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
            
            if( nil != gObj ){
                if( [gObj respondsToSelector:act] )
                    [gObj performSelector:act withObject:[NSNumber numberWithFloat: (value1 + value2)]];
                else
                    EXCLAMATION;
            }
        }
    }
}

-(NSNumber*) getInput2Value
{
    return [NSNumber numberWithFloat:value2];
}

-(void) setMinusValue:(NSNumber*) Value
{
    if( [Value isKindOfClass:[NSString class]] )
        value2 = [(NSString*)Value length];
    else if( [Value isKindOfClass:[NSNumber class]] )
        value2 = [Value floatValue];
    else
        return;
    
    if( USERCONTEXT.imRunning ){
        SEL act;
        NSNumber *nsMagicNum;
        
        act = ((NSValue*)[(NSDictionary*)[actionArray objectAtIndex:0] objectForKey:@"selector"]).pointerValue;
        if( nil != act ){
            nsMagicNum = [((NSDictionary*)[actionArray objectAtIndex:0]) objectForKey:@"mNum"];
            CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
            
            if( nil != gObj ){
                if( [gObj respondsToSelector:act] )
                    [gObj performSelector:act withObject:[NSNumber numberWithFloat: (value1 - value2)]];
                else
                    EXCLAMATION;
            }
        }
    }
}

-(void) setMultiValue:(NSNumber*) Value
{
    if( [Value isKindOfClass:[NSString class]] )
        value2 = [(NSString*)Value length];
    else if( [Value isKindOfClass:[NSNumber class]] )
        value2 = [Value floatValue];
    else
        return;
    
    if( USERCONTEXT.imRunning ){
        SEL act;
        NSNumber *nsMagicNum;
        
        act = ((NSValue*)[(NSDictionary*)[actionArray objectAtIndex:0] objectForKey:@"selector"]).pointerValue;
        if( nil != act ){
            nsMagicNum = [((NSDictionary*)[actionArray objectAtIndex:0]) objectForKey:@"mNum"];
            CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
            
            if( nil != gObj ){
                if( [gObj respondsToSelector:act] )
                    [gObj performSelector:act withObject:[NSNumber numberWithFloat: (value1 * value2)]];
                else
                    EXCLAMATION;
            }
        }
    }
}


-(void) setDivValue:(NSNumber*) Value
{
    if( [Value isKindOfClass:[NSString class]] )
        value2 = [(NSString*)Value length];
    else if( [Value isKindOfClass:[NSNumber class]] )
        value2 = [Value floatValue];
    else
        return;

    if( 0 == value2 ){
        EXCLAMATION;
        return;   // divide by zero ?
    }

    if( USERCONTEXT.imRunning ){
        SEL act;
        NSNumber *nsMagicNum;
        
        act = ((NSValue*)[(NSDictionary*)[actionArray objectAtIndex:0] objectForKey:@"selector"]).pointerValue;
        if( nil != act ){
            nsMagicNum = [((NSDictionary*)[actionArray objectAtIndex:0]) objectForKey:@"mNum"];
            CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
            
            if( nil != gObj ){
                if( [gObj respondsToSelector:act] )
                    [gObj performSelector:act withObject:[NSNumber numberWithFloat: (value1 / value2)]];
                else
                    EXCLAMATION;
            }
        }
    }
}

//===========================================================================

#pragma mark -

-(id) initGear
{
    if( ![super init] ) return nil;
    
    csView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 33, 33)];
    [(UIImageView*)csView setImage:[UIImage imageNamed:@"gi_calc.png"]];
    [csView setUserInteractionEnabled:YES];
    
    csCode = CS_CALC;

    csResizable = NO;
    csShow = NO;

    self.info = NSLocalizedString(@"Calculator + - x /", @"calc");
    
    NSDictionary *d1 = MAKE_PROPERTY_D(@"Input #1", P_NUM, @selector(setInput1Value:),@selector(getInput1Value));
    NSDictionary *d2 = MAKE_PROPERTY_D(@">Input for Plus", P_NUM, @selector(setPlusValue:),@selector(getInput2Value));
    NSDictionary *d3 = MAKE_PROPERTY_D(@">Input for Minus", P_NUM, @selector(setMinusValue:),@selector(getInput2Value));
    NSDictionary *d4 = MAKE_PROPERTY_D(@">Input for Multiplication", P_NUM, @selector(setMultiValue:),@selector(getInput2Value));
    NSDictionary *d5 = MAKE_PROPERTY_D(@">Input for Division", P_NUM, @selector(setDivValue:),@selector(getInput2Value));
    pListArray = [NSArray arrayWithObjects:d1,d2,d3,d4,d5, nil];
    
    NSMutableDictionary MAKE_ACTION_D(@"Output", A_NUM, a1);
    actionArray = [NSArray arrayWithObjects:a1, nil];
    
    return self;
}

-(id)initWithCoder:(NSCoder *)decoder
{
    if( (self=[super initWithCoder:decoder]) ) {
        [(UIImageView*)csView setImage:[UIImage imageNamed:@"gi_calc.png"]];
        value1 = [decoder decodeFloatForKey:@"value1"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
    [encoder encodeFloat:value1 forKey:@"value1"];
}

@end

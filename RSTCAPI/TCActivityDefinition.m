//
//  TCActivityDefinition.m
//  RSTCAPI
//
//  Created by Brian Rogers on 3/6/13.
/*
 Copyright 2013 Rustici Software
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import "TCActivityDefinition.h"

@interface TCActivityDefinition()
{
    TCLocalizedValues *_name;
    TCLocalizedValues *_description;
    NSString *_type;
    NSDictionary *_extensions;
    NSString *_interactionType;
    NSArray *_correctResponsesPattern;
    NSArray *_choices;
    NSArray *_scale;
    NSArray *_target;
    NSArray *_steps;
    
    NSMutableDictionary *_actDefDict;
}

@end

@implementation TCActivityDefinition

- (id) initWithName:(TCLocalizedValues *)name withDescription:(TCLocalizedValues *)description withType:(NSString *)type withExtensions:(NSDictionary *)extensions withInteractionType:(NSString *)interactionType withCorrectResponsesPattern:(NSArray *)correctResponsesPattern withChoices:(NSArray *)choices withScale:(NSArray *)scale withTarget:(NSArray *)target withSteps:(NSArray *)steps
{
    if ((self = [super init])) {
        _name = name;
        _description = description;
        _type = type;
        _extensions = extensions;
        _interactionType = interactionType;
        _correctResponsesPattern = correctResponsesPattern;
        _choices = choices;
        _scale = scale;
        _target = target;
        _steps = steps;
    }
    return self;
}

- (id) initWithDictionary:(NSDictionary *)dictionary
{
    if ((self = [super init])) {
        _name = [[TCLocalizedValues alloc] initWithDictionary:[dictionary valueForKey:@"name"]];
        _description = [[TCLocalizedValues alloc] initWithDictionary:[dictionary valueForKey:@"description"]];;
//        _type = type;
//        _extensions = extensions;
//        _interactionType = interactionType;
//        _correctResponsesPattern = correctResponsesPattern;
//        _choices = choices;
//        _scale = scale;
//        _target = target;
//        _steps = steps;
    }
    return self;
}

- (NSDictionary *)dictionary
{
    _actDefDict = [[NSMutableDictionary alloc] init];
    [_actDefDict setValue:[_name dictionary] forKey:@"name"];
    [_actDefDict setValue:[_description dictionary] forKey:@"description"];
    [_actDefDict setValue:_type forKey:@"type"];
    
    if(_extensions != nil){
        [_actDefDict setValue:_extensions forKey:@"extensions"];
    }
    if(_interactionType != nil){
        [_actDefDict setValue:_interactionType forKey:@"interactionType"];
    }
    if(_correctResponsesPattern != nil){
        [_actDefDict setValue:_correctResponsesPattern forKey:@"correctResponsesPattern"];
    }
    if(_choices != nil){
        [_actDefDict setValue:_choices forKey:@"choices"];
    }
    if(_scale != nil){
        [_actDefDict setValue:_scale forKey:@"scale"];
    }
    if(_target != nil){
        [_actDefDict setValue:_target forKey:@"target"];
    }
    if(_steps != nil){
        [_actDefDict setValue:_steps forKey:@"steps"];
    }
    
    return [_actDefDict copy];
}

@end

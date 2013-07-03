//
//  RSTCAPITests.m
//  RSTCAPITests
//
//  Created by Brian Rogers on 2/28/13.
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

#import "RSTCAPITests.h"
#import "TCUtil.h"


@interface RSTCAPITests()
{
    RSTinCanConnector *tincan;
}

@end

@implementation RSTCAPITests

- (void)setUp
{
    [super setUp];
    
    NSMutableDictionary *options = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *lrs = [[NSMutableDictionary alloc] init];
    [lrs setValue:@"https://lrs/endpoint" forKey:@"endpoint"];
    [lrs setValue:@"Basic ahutdpeurhks23865hkksiet84573authstringbase64=" forKey:@"auth"];
    
    [lrs setValue:@"0.95" forKey:@"version"];
    // just add one LRS for now
    [options setValue:[NSArray arrayWithObject:lrs] forKey:@"recordStore"];
    tincan = [[RSTinCanConnector alloc]initWithOptions:options];
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}



- (void)testSaveStatement
{

    STAssertNotNil(tincan, @"tincan is not nill");
    
    NSMutableDictionary *statementOptions = [[NSMutableDictionary alloc] init];
    [statementOptions setValue:@"http://tincanapi.com/test" forKey:@"activityId"];
    [statementOptions setValue:[[TCVerb alloc] initWithId:@"http://adlnet.gov/expapi/verbs/experienced" withVerbDisplay:[[TCLocalizedValues alloc] initWithLanguageCode:@"en-US" withValue:@"experienced"]] forKey:@"verb"];
    [statementOptions setValue:@"http://adlnet.gov/expapi/activities/course" forKey:@"activityType"];
    
    TCStatement *statementToSend = [self createTestStatementWithOptions:statementOptions];
     
    [tincan sendStatement:statementToSend withCompletionBlock:^(){
        [[TestSemaphor sharedInstance] lift:@"saveStatement"];
    }withErrorBlock:^(TCError *error){

        NSLog(@"ERROR: %@", error.localizedDescription);
        STAssertNil(error, @"There was no error with the request");
        [[TestSemaphor sharedInstance] lift:@"saveStatement"];
    }];
    
    [[TestSemaphor sharedInstance] waitForKey:@"saveStatement"];
}

- (void)testSaveStatements
{

    STAssertNotNil(tincan, @"tincan is not nill");
    
    TCStatementCollection *statementArray = [[TCStatementCollection alloc] init];
    
    NSMutableDictionary *statement1Options = [[NSMutableDictionary alloc] init];
    [statement1Options setValue:@"http://tincanapi.com/test" forKey:@"activityId"];
    [statement1Options setValue:[[TCVerb alloc] initWithId:@"http://adlnet.gov/expapi/verbs/experienced" withVerbDisplay:[[TCLocalizedValues alloc] initWithLanguageCode:@"en-US" withValue:@"experienced"]] forKey:@"verb"];
    [statement1Options setValue:@"http://adlnet.gov/expapi/activities/course" forKey:@"activityType"];
    TCStatement *statement1 = [self createTestStatementWithOptions:statement1Options];
    [statementArray addStatement:statement1];
    
    NSMutableDictionary *statement2Options = [[NSMutableDictionary alloc] init];
    [statement2Options setValue:@"http://tincanapi.com/test" forKey:@"activityId"];
    [statement2Options setValue:[[TCVerb alloc] initWithId:@"http://adlnet.gov/expapi/verbs/experienced" withVerbDisplay:[[TCLocalizedValues alloc] initWithLanguageCode:@"en-US" withValue:@"experienced"]] forKey:@"verb"];
    [statement2Options setValue:@"http://adlnet.gov/expapi/activities/course" forKey:@"activityType"];
    TCStatement *statement2 = [self createTestStatementWithOptions:statement2Options];
    [statementArray addStatement:statement2];
    
    NSMutableDictionary *statement3Options = [[NSMutableDictionary alloc] init];
    [statement3Options setValue:@"http://tincanapi.com/test" forKey:@"activityId"];
    [statement3Options setValue:[[TCVerb alloc] initWithId:@"http://adlnet.gov/expapi/verbs/experienced" withVerbDisplay:[[TCLocalizedValues alloc] initWithLanguageCode:@"en-US" withValue:@"experienced"]] forKey:@"verb"];
    [statement3Options setValue:@"http://adlnet.gov/expapi/activities/course" forKey:@"activityType"];
    TCStatement *statement3 = [self createTestStatementWithOptions:statement3Options];
    [statementArray addStatement:statement3];
    
    NSMutableDictionary *statement4Options = [[NSMutableDictionary alloc] init];
    [statement4Options setValue:@"http://tincanapi.com/test" forKey:@"activityId"];
    [statement4Options setValue:[[TCVerb alloc] initWithId:@"http://adlnet.gov/expapi/verbs/experienced" withVerbDisplay:[[TCLocalizedValues alloc] initWithLanguageCode:@"en-US" withValue:@"experienced"]] forKey:@"verb"];
    [statement4Options setValue:@"http://adlnet.gov/expapi/activities/course" forKey:@"activityType"];
    TCStatement *statement4 = [self createTestStatementWithOptions:statement4Options];
    [statementArray addStatement:statement4];
    
    [tincan sendStatements:statementArray withCompletionBlock:^(){
        [[TestSemaphor sharedInstance] lift:@"saveStatements"];
    }withErrorBlock:^(TCError *error){
        
        NSLog(@"ERROR: %@", error.localizedDescription);
        STAssertNil(error, @"There was no error with the request");
        [[TestSemaphor sharedInstance] lift:@"saveStatements"];
    }];
    
    [[TestSemaphor sharedInstance] waitForKey:@"saveStatement"];
}

- (void)testGetStatement
{
    
    STAssertNotNil(tincan, @"tincan is not nill");
    
    [tincan getStatementWithId:@"4d44e635-b8c5-4eed-9695-eb7cc95e7c1a" withOptions:nil
           withCompletionBlock:^(TCStatement *statement){
               NSLog(@"statement %@", statement);
               [[TestSemaphor sharedInstance] lift:@"getStatement"];
           }withErrorBlock:^(TCError *error){
               NSLog(@"ERROR: %@", error.localizedDescription);
               [[TestSemaphor sharedInstance] lift:@"getStatement"];
           }];
    
    [[TestSemaphor sharedInstance] waitForKey:@"getStatement"];
}

- (void)testGetStatements
{

    STAssertNotNil(tincan, @"tincan is not nill");
    
    TCVerb *verb = [[TCVerb alloc] initWithId:@"http://adlnet.gov/expapi/verbs/experienced" withVerbDisplay:[[TCLocalizedValues alloc] initWithLanguageCode:@"en-US" withValue:@"experienced"]];
    
    TCQueryOptions *queryOptions = [[TCQueryOptions alloc] initWithActor:[[TCAgent alloc] initWithName:nil withMbox:@"mailto:brian@tincanapi.com"] withVerb:verb withTarget:nil withInstructor:nil withRegistration:nil withContext:YES withSince:@"2013-03-07" withUntil:nil withLimit:[NSNumber numberWithInt:2] withAuthoritative:NO withSparse:NO withAscending:NO];
    
    [tincan getStatementsWithOptions:queryOptions withCompletionBlock:^(NSArray *statementArray){
        NSLog(@"statementArray %@", statementArray);
        NSLog(@"found %d statements", statementArray.count);
        STAssertNotNil(statementArray, @"statements were returned");
        [[TestSemaphor sharedInstance] lift:@"getStatements"];
    }withErrorBlock:^(TCError *error){
        STAssertNil(error, @"There was no error with the request");
        NSLog(@"ERROR: %@", error.localizedDescription);
        [[TestSemaphor sharedInstance] lift:@"getStatements"];
    }];
    
    [[TestSemaphor sharedInstance] waitForKey:@"getStatements"];
}

- (TCStatement *)createTestStatementWithOptions:(NSDictionary *)options
{
    TCAgent *actor = [[TCAgent alloc] initWithName:@"Brian Rogers" withMbox:@"mailto:brian@tincanapi.com"];
    
    TCActivityDefinition *actDef = [[TCActivityDefinition alloc] initWithName:[[TCLocalizedValues alloc] initWithLanguageCode:@"en-US" withValue:@"http://tincanapi.com/test"]
                                                              withDescription:[[TCLocalizedValues alloc] initWithLanguageCode:@"en-US" withValue:@"Description for test statement"]
                                                                     withType:[options valueForKey:@"activityType"]
                                                               withExtensions:nil
                                                          withInteractionType:nil
                                                  withCorrectResponsesPattern:nil
                                                                  withChoices:nil
                                                                    withScale:nil
                                                                   withTarget:nil
                                                                    withSteps:nil];
    
    TCActivity *activity = [[TCActivity alloc] initWithId:[options valueForKey:@"activityId"] withActivityDefinition:actDef];
    
    TCVerb *verb = [options valueForKey:@"verb"];
    
    TCStatement *statementToSend = [[TCStatement alloc] initWithId:[TCUtil GetUUID] withActor:actor withTarget:activity withVerb:verb withResult:nil withContext:nil];
    
    return statementToSend;
}


- (void) testQueryOptions
{
    TCQueryOptions *options = [[TCQueryOptions alloc] initWithActor:[[TCAgent alloc] initWithName:@"Test User" withMbox:@"mailto:test@tincanapi.com"] withVerb:[[TCVerb alloc] initWithId:@"http://adlnet.gov/exapi/verbs/attempted" withVerbDisplay:[[TCLocalizedValues alloc] initWithLanguageCode:@"en-US" withValue:@"attempted"]] withTarget:nil withInstructor:nil withRegistration:nil withContext:YES withSince:nil withUntil:nil withLimit:[NSNumber numberWithInt:25] withAuthoritative:NO withSparse:NO withAscending:NO];
    NSLog(@"%@", [options querystring]);
}

- (void) testState
{
    
    
    TCAgent *actor = [[TCAgent alloc] initWithName:@"Brian Rogers" withMbox:@"mailto:brian@tincanapi.com"];
    
    TCActivityDefinition *actDef = [[TCActivityDefinition alloc] initWithName:[[TCLocalizedValues alloc] initWithLanguageCode:@"en-US" withValue:@"http://tincanapi.com/test"]
                                                              withDescription:[[TCLocalizedValues alloc] initWithLanguageCode:@"en-US" withValue:@"Description for test statement"]
                                                                     withType:nil
                                                               withExtensions:nil
                                                          withInteractionType:nil
                                                  withCorrectResponsesPattern:nil
                                                                  withChoices:nil
                                                                    withScale:nil
                                                                   withTarget:nil
                                                                    withSteps:nil];
    
    
    NSMutableDictionary *stateContents = [[NSMutableDictionary alloc] init];
    [stateContents setValue:@"page 1" forKey:@"bookmark"];
    
    NSString *stateId = [TCUtil GetUUID];
    
    // put some state
    [tincan setStateWithValue:stateContents withStateId:stateId withActivityId:[TCUtil encodeURL:@"http://tincanapi.com/test"] withAgent:actor withRegistration:nil withOptions:nil withCompletionBlock:^{
        [[TestSemaphor sharedInstance] lift:@"saveState"];
    }withErrorBlock:^(NSError *error){
        [[TestSemaphor sharedInstance] lift:@"saveState"];
    }];
    [[TestSemaphor sharedInstance] waitForKey:@"saveState"];
    
    // get the state
    [tincan getStateWithStateId:stateId withActivityId:[TCUtil encodeURL:@"http://tincanapi.com/test"] withAgent:actor withRegistration:nil withOptions:nil
            withCompletionBlock:^(NSDictionary *state){
                    NSLog(@"state : %@", state);
                    [[TestSemaphor sharedInstance] lift:@"getState"];
                }
                 withErrorBlock:^(TCError *error){
                     [[TestSemaphor sharedInstance] lift:@"getState"];
                 }];
    [[TestSemaphor sharedInstance] waitForKey:@"getState"];
    
    // delete the state
    [tincan deleteStateWithStateId:stateId withActivityId:[TCUtil encodeURL:@"http://tincanapi.com/test"] withAgent:actor withRegistration:nil withOptions:nil
            withCompletionBlock:^(){
                [[TestSemaphor sharedInstance] lift:@"deleteState"];
            }
                 withErrorBlock:^(TCError *error){
                     [[TestSemaphor sharedInstance] lift:@"deleteState"];
                 }];
    [[TestSemaphor sharedInstance] waitForKey:@"deleteState"];
}

@end

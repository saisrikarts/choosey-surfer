*** Settings ***
Resource   ${EXEC_DIR}/HighLevelKeywords/StepLevelKeywords.resource




*** Test Cases ***

Scenario: As a choosey Surfer
    [Template]   Scenario Outline: As a choosey surfer help me pick a beach and dates

    #Examples:
    #beach1   #beach2
    Bentley    York
    Yanchep    Gayndah
    Maroubra    Wooroloo
    Earlwood    Woodside

*** Keywords ***
Scenario Outline: As a choosey surfer help me pick a beach and dates
    [Arguments]   ${beach1}  ${beach2}
    Given I like to surf in any of 2 beaches of Sydney  ${beach1}  ${beach2}
    And I only like to surf on Monday & Friday in next 16 days
    When I look up the the weather forecast for the next 16 days with POSTAL CODES
    Then I check to if see the temperature is between 12C and 30C
    And I check wind speed to be between 3 and 9
    And I check to see if UV index is less than equal 12
    And I pick best suitable spot out of top two spots, based upon suitable weather forecast for the day
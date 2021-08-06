*** Settings ***
Resource   ${EXEC_DIR}/GeneralKeywords/CommonKeywords.resource
Resource   ${EXEC_DIR}/APIKeywords/APIMethodKeywords.resource
Variables   ${EXEC_DIR}/TestData/APIVariables.py


*** Keywords ***
#Scenario Outline : I like to surf in any of 2 beaches of Sydney
#    [Arguments]    ${beach1}  ${beach2}
#    [Documentation]  This is test suite documentation
#    Select two beaches to surf ${beach1} or ${beach2}
#    First Preference of beach to surf on ${beach1}
#    Select Mondays or Fridays from 16 day forecast
#    Check the temperature forecast >12C and <30C
#    Check the wind speed forecast between 3 and 9
#    Check the uv index forecast less than 12
#    Pick good weather days for each spot
#
#    Second Preference of beach to surf on ${beach2}
#    Select Mondays or Fridays from 16 day forecast
#    Check the temperature forecast >12C and <30C
#    Check the wind speed forecast between 3 and 9
#    Check the uv index forecast less than 12
#    Pick good weather days for each spot

I like to surf in any of 2 beaches of Sydney
    [Documentation]  This is test suite documentation
    [Arguments]     ${beach1}   ${beach2}
    Select two beaches to surf ${beach1} or ${beach2}
    Fetch the post code from the datasheet  ${beach1}  ${beach2}

I only like to surf on Monday & Friday in next 16 days
    [Documentation]   This keyword finds the mondays and fridays over next 16 days
    Select Mondays or Fridays from 16 day forecast

I look up the the weather forecast for the next 16 days with POSTAL CODES
    [Documentation]   This keyword makes a call to the API to fetch forecast for next 16 days using post codes
    Make a call to the API for 16 day forecast  ${city_id1}  ${city_id2}

I check to if see the temperature is between 12C and 30C
    [Documentation]    This keyword checks for the temperature between 12 and 30C
    ${goodTempDays1}   Check the temperature forecast >12C and <30C  ${jsonData1}
    ${goodTempDays2}   Check the temperature forecast >12C and <30C  ${jsonData2}
    set suite variable    ${goodTempDays1}
    set suite variable    ${goodTempDays2}

I check wind speed to be between 3 and 9
    [Documentation]    This keyword checks for the wind speed between 3 and 9
    ${goodWindDays1}   Check the wind speed forecast between 3 and 9  ${jsonData1}
    ${goodWindDays2}   Check the wind speed forecast between 3 and 9  ${jsonData2}
    set suite variable    ${goodWindDays1}
    set suite variable    ${goodWindDays2}

I check to see if UV index is less than equal 12
    [Documentation]    This keyword checks for the UV index less than equal to 12
    ${goodUVDays1}    Check the uv index forecast less than or equal to 12  ${jsonData1}
    ${goodUVDays2}    Check the uv index forecast less than or equal to 12  ${jsonData2}
    set suite variable    ${goodUVDays1}
    set suite variable    ${goodUVDays2}

I pick best suitable spot out of top two spots, based upon suitable weather forecast for the day
    [Documentation]     this keyword picks the best days for each spot
    ${finaldays1}    Pick good weather days for each spot  ${goodTempDays1}   ${goodWindDays1}    ${goodUVDays1}
    ${finaldays2}    Pick good weather days for each spot  ${goodTempDays2}   ${goodWindDays2}    ${goodUVDays2}
    ${bestdays}  Get Common Values From Two Lists  ${finaldays1}  ${finaldays2}
    log to console    best days to visit ${beach1} ${city_id1} or ${beach2} ${city_id2} are ${bestdays}



*** Settings ***
Library     Collections
Library     ${EXEC_DIR}/CustomLibraries/compareLists.py
Resource    ${EXEC_DIR}/GeneralKeywords/CommonKeywords.resource
Variables   ${EXEC_DIR}/TestData/APIVariables.py

*** Keywords ***

Select two beaches to surf ${beach1} or ${beach2}
    [Documentation]   This keyword reads from a list of beaches and selects two beaches
    set suite variable   ${beach1}
    set suite variable   ${beach2}

Fetch the post code from the datasheet
    [Documentation]   This keyword selects suitable day for beach.
    [Arguments]  ${beach1}   ${beach2}
    ${getExcelData}=   Reading data from datasheet
    FOR   ${i}  IN RANGE   19
        Run keyword and ignore error   Should be equal as Strings  ${beach1}   ${getExcelData[${i}][1]}
        Run keyword and ignore error   Should be equal as Strings  ${beach2}   ${getExcelData[${i}][1]}
        Run keyword if   "${beach1}"=='${getExcelData[${i+1}][1]}'   Set Suite Variable  ${city_id1}  ${getExcelData[${i+1}][0]}
        Run keyword if   "${beach2}"=='${getExcelData[${i+1}][1]}'   Set Suite Variable  ${city_id2}  ${getExcelData[${i+1}][0]}
    END
    Set Suite Variable    ${city_id1}
    Set Suite Variable    ${city_id2}

Make a call to the API for 16 day forecast
   [Documentation]   This keyword calls the API using the city_id
   [Arguments]    ${city_id1}  ${city_id2}
   ${jsonData1}    Connect to the required API URL      ${Day16ForeCastEndpoint}${city_id1}  expectedResult=200
   Set Suite Variable   ${jsonData1}
   Set Test Message   Request:${Day16ForeCastEndpoint}${city_id1}\n\n\n\n
   #Set Test Message   Response:${jsonData1}
   ${jsonData2}    Connect to the required API URL      ${Day16ForeCastEndpoint}${city_id2}  expectedResult=200
   Set Suite Variable   ${jsonData2}
   Set Test Message   Request:${Day16ForeCastEndpoint}${city_id2}\n\n\n\n
   #Set Test Message   Response:${jsonData2}

Select Mondays or Fridays from 16 day forecast
    [Documentation]   This keyword calculates the mondays and fridays based on the the day API is called
    @{selecteddays}  Create List
    ${todayDate}   Get Current Date  result_format= %Y-%m-%d
    ${todayDay}    Get Current Date  result_format= %A
    ${i}  set variable   0
    FOR  ${i}  IN RANGE  16
            ${nextDate}=  Add Time To Date     ${todayDate}  ${i} days    result_format= %Y-%m-%d
            ${formatDay}=   Convert date   ${nextDate}  result_format= %A
            Run Keyword if  "${formatDay}"==" Monday"   Append to List  ${selecteddays}   ${nextDate.strip()}
            Run Keyword if  "${formatDay}"==" Friday"   Append to List  ${selecteddays}   ${nextDate.strip()}
     END
     Set Suite Variable   ${selecteddays}

#    Read the JSON response  ${jsonData}
#    @{selecteddays}  Create List
#    @{temperatureOnDays}    Create List
#    @{WindSpeedOnDays}    Create List
#    @{UVIndexOnDays}    Create List
#    FOR  ${i}  IN RANGE  16
#       ${forecastDays}  Convert date  ${jsonData['data'][${i}]['valid_date']}  result_format= %A
#       ${forecastDays}   Convert to String  ${forecastDays}
#       Run keyword and ignore error    Should be equal as strings   ${forecastDays}   Monday
#       Run keyword and ignore error    Should be equal as strings   ${forecastDays}   Friday
#       Run keyword if   "${forecastDays}"==" Monday"    Append to List  ${selecteddays}   ${jsonData['data'][${i}]['valid_date']}
#       Run keyword if   "${forecastDays}"==" Friday"    Append to List  ${selecteddays}   ${jsonData['data'][${i}]['valid_date']}
#
#       Run keyword if   "${forecastDays}"==" Monday"    Append to List  ${temperatureOnDays}   ${jsonData['data'][${i}]['temp']}
#       Run keyword if   "${forecastDays}"==" Friday"    Append to List  ${temperatureOnDays}   ${jsonData['data'][${i}]['temp']}
#
#       Run keyword if   "${forecastDays}"==" Monday"    Append to List  ${WindSpeedOnDays}   ${jsonData['data'][${i}]['wind_gust_spd']}
#       Run keyword if   "${forecastDays}"==" Friday"    Append to List  ${WindSpeedOnDays}   ${jsonData['data'][${i}]['wind_gust_spd']}
#
#       Run keyword if   "${forecastDays}"==" Monday"    Append to List  ${UVIndexOnDays}   ${jsonData['data'][${i}]['uv']}
#       Run keyword if   "${forecastDays}"==" Friday"    Append to List  ${UVIndexOnDays}   ${jsonData['data'][${i}]['uv']}
#       Set test variable   ${selecteddays}
#       Set test variable   ${temperatureOnDays}
#       Set test variable   ${WindSpeedOnDays}
#       Set test variable   ${UVIndexOnDays}
#
#    END


Check the temperature forecast >12C and <30C
    [Documentation]    This keyword find the temperature of certain monday or friday
    [Arguments]    ${jsonData}
    @{goodTempDays}    Create List
    FOR  ${index}  IN RANGE  16
       ${status}    Run keyword and return status    Should contain  ${selecteddays}    ${jsonData['data'][${index}]['valid_date']}
       Continue For Loop if  ${status}==False
       Run keyword if   12 < ${jsonData['data'][${index}]['temp']} < 30 and ${status}==True  Append To List   ${goodTempDays}  ${jsonData['data'][${index}]['valid_date']}
    END

    [return]   ${goodTempDays}


Check the wind speed forecast between 3 and 9
    [Documentation]    This keyword find the wind speed of certain monday or friday
    [Arguments]    ${jsonData}
    @{goodWindDays}   Create List
    FOR  ${index}  IN RANGE  16
       ${status}    Run keyword and return status    Should contain  ${selecteddays}    ${jsonData['data'][${index}]['valid_date']}
       Continue For Loop if  ${status}==False
       Run keyword if   3 < ${jsonData['data'][${index}]['wind_gust_spd']} < 9 and ${status}==True  Append To List   ${goodWindDays}  ${jsonData['data'][${index}]['valid_date']}
    END

    [return]   ${goodWindDays}


Check the uv index forecast less than or equal to 12
    [Documentation]    This keyword find the UV index of certain monday or friday
    [Arguments]    ${jsonData}
    @{goodUVDays}   Create List
    FOR  ${index}  IN RANGE  16
       ${status}    Run keyword and return status    Should contain  ${selecteddays}    ${jsonData['data'][${index}]['valid_date']}
       Continue For Loop if  ${status}==False
       Run keyword if   ${jsonData['data'][${index}]['uv']} <= 12 and ${status}==True  Append To List   ${goodUVDays}  ${jsonData['data'][${index}]['valid_date']}
    END
    [return]   ${goodUVDays}

Pick good weather days for each spot
    [Documentation]    This keyword is to pick the common good weather day
    [Arguments]    ${goodTempDays}   ${goodWindDays}   ${goodUVDays}
    ${finaldays}   Get Common Values From Three Lists   ${goodTempDays}   ${goodWindDays}   ${goodUVDays}
    [return]   ${finaldays}

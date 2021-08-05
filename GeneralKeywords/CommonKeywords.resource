*** Settings ***
Library   RequestsLibrary
Library   ExcelLibrary
Library   DateTime
Library    ${EXEC_DIR}/CustomLibraries/readFromCSV.py
Variables  ${EXEC_DIR}/TestData/APIVariables.py


*** Keywords ***

Connect to the required API URL
        [Documentation]   This keyword is to connect to the base url
        [Arguments]   ${EndPoint}  ${expectedResult}
        Create Session   mysession  ${BaseURL}   verify=true
        ${response}=   Get On Session  alias=mysession  url=${EndPoint}&key=${APIKey}  expected_status=${expectedResult}
        Set Test Variable  ${response}
        ${json_string}=  set variable     ${response.json()}
        Set Suite Variable   ${json_string}
        Set Test Message   Response for ${BaseURL}${EndPoint}&key=${APIKey} is ${response}
        [Return]   ${json_string}



Reading data from datasheet
        [Documentation]   This keyword is to accept names of the beaches for surfing
        ${CaptureData}    Read From CSV File  ${ExcelDataSheetPath}
        [Return]   ${CaptureData}

Get API request date
        [Documentation]   This keyword gets the date API is being called.
        ${todayDate}   Get Current Date  result_format= %Y-%m-%d
        ${todayDay}   Get Current Date  result_format= %A
        Set suite variable   ${todayDate}
        Set suite variable   ${todayDay}

Read the JSON response
        [Documentation]   This keyword is to consume the json file for accessing its fields.
        [Arguments]    ${json_string}
        ${jsonData}=   Evaluate   ${json_string}
        Set Suite Variable     ${jsonData}







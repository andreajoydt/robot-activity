*** Settings ***
Library    SeleniumLibrary
Library    String
Library     Collections
Library    ../Library/CustomLibrary.py
Variables    ../Variables/variables.py

Resource    Test_1.resource
Resource    Test_2.resource
Resource    Test_3.resource
Resource    Test_4.resource

*** Keywords ***
Launch browser
    [Arguments]    ${url}=${URL}
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method    ${options}    add_argument    --disable-popup-blocking
    Call Method    ${options}    add_argument    --disable-notifications
    Call Method    ${options}    add_argument    --disable-save-password-bubble
    Call Method    ${options}    add_argument    --start-maximized
    Call Method    ${options}    add_argument    --disable-password-manager-reauthentication
        
    ${prefs}=    Create Dictionary    credentials_enable_service=False    profile.password_manager_enabled=False    profile.default_content_setting_values.notifications=2
    Call Method    ${options}    add_experimental_option    prefs    ${prefs}
    Open Browser    ${url}    chrome    options=${options}

    Wait Until Keyword Succeeds    5x    .5s    Wait Until Element Is Visible    ${login_txt_username}

Login User
    [Arguments]    ${username}=${USERNAME}    ${password}=${PASSWORD}
    Input Text    ${login_txt_username}    ${username}
    Input Text    ${login_txt_password}    ${password}
    Click Button    //*[@id="root"]/div/div/form/div/button
    Wait Until Element Is Not Visible    ${loading_icon}    timeout=15s
    Wait Until Element Is Visible    ${nav_btn_customers}    timeout=15s

Go To Customer Page
    Log To Console    Navigating to Customers page
    Click Element    ${nav_btn_customers}
    Wait Until Element Is Visible    ${table_row}    

Refresh Current Page
    Click Button    ${btn_refresh}
    Wait Until Element Is Visible    ${loading_icon}
    Wait Until Element Is Not Visible    ${loading_icon}
    Log To Console    ${URL}
    Log To Console    ${USERNAME}


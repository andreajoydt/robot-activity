*** Settings ***
Resource    ../Resources/App.resource
Library     Collections

*** Keywords ***
Create Customer
    [Arguments]    ${customer}
    Click Element    ${customers_btn_create}
    Wait Until Element Is Visible    ${customers_txt_firstname}   

    ${first_name}    Set Variable    ${customer["name"].split(" ")[0]}
    ${last_name}     Set Variable    ${customer["name"].split(" ")[1]}

    Input Text    ${customers_txt_firstname}    ${first_name}
    Input Text    ${customers_txt_lastname}     ${last_name}
    Input Text    ${customers_txt_email}        ${customer["email"]}

    ${address}    Set Variable    ${customer["address"]["street"]} ${customer["address"]["suite"]}
    Input Text    ${customers_txt_address}      ${address}
    Input Text    ${customers_txt_city}         ${customer["address"]["city"]}
    Input Text    ${customers_txt_stateAbbr}    ${customer["address"]["stateAbbr"]}
    Input Text    ${customers_txt_zipcode}      ${customer["address"]["zipcode"]}

    ${password}   Set Variable    ${customer["password"]}
    Input Text    ${customers_txt_password}         ${password}
    Input Text    ${customers_txt_confirm_password}     ${password}
    
    Click Button    ${customers_btn_save}
    Wait Until Page Contains    Customer created    timeout=10s

Verify Customer Row Data By Email
    [Arguments]    ${customer}
    Go To Customer Page
    ${rows}=    Get WebElements    ${table_row}
    ${found}=   Set Variable    False
    FOR    ${row}    IN    @{rows}
        ${email_cell}=    Get WebElement    xpath=.//td[3] 
        ${email_text}=    Get Text    ${email_cell}
        IF    '${email_text}' == '${customer["email"]}'
            ${name_cell}=    Get WebElement    xpath=.//td[2]
            ${name_text}=    Get Text    ${name_cell}
            ${expected_name}=    Set Variable    ${customer["name"].split(" ")[0]} ${customer["name"].split(" ")[1]}
            Should Be Equal As Strings    ${expected_name}    ${name_text}
            Set Variable    ${found}    True
            Exit For Loop
        END
    END

Update And Verify Multiple Customers
    [Arguments]    @{customers}
    ${row_index}=    Set Variable    6
    FOR    ${user}    IN    @{customers}
        Update Existing Customer    ${user}    ${row_index}
        Verify Customer Row Data By Email    ${user}
        ${row_index}=    Evaluate    ${row_index} + 1
    END

Add And Verify Multiple Customers
    [Arguments]    @{customers}
    FOR    ${user}    IN    @{customers}
        Create Customer            ${user}
        Verify Customer Row Data By Email    ${user}
    END
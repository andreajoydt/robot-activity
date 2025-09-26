*** Settings ***
Resource    ../Resources/App.resource
Library     Collections

*** Keywords ***
Click Customer Row By Email
    [Arguments]    ${email}
    Go To Customer Page
    ${rows}=    Get WebElements    ${table_row}
    ${found}=   Set Variable    None
    FOR    ${row}    IN    @{rows}
        ${cell_email}=    Get Text    xpath=.//td[3]
        IF    '${cell_email}' == '${email}'
            Click Element    ${row}
            Set Variable    ${found}    ${row}
            Exit For Loop
        END
    END
    Run Keyword If    '${found}' == 'None'    Fail    Customer with email ${email} not found

Update Existing Customer
    [Arguments]    ${customer}    ${row_index}
    ${first_name}=    Set Variable    ${customer["name"].split(" ")[0]}
    ${last_name}=     Set Variable    ${customer["name"].split(" ")[1]}

    # Click the row itself
    Click Element    xpath=(${table_row})[${row_index}]
    Wait Until Element Is Visible    ${customers_txt_firstname}    timeout=10s

    # Clear and update the fields
    Press Keys            ${customers_txt_firstname}    CTRL+a     BACKSPACE
    Input Text            ${customers_txt_firstname}    ${first_name}

    Press Keys            ${customers_txt_lastname}    CTRL+a     BACKSPACE
    Input Text            ${customers_txt_lastname}     ${last_name}

    Press Keys            ${customers_txt_email}    CTRL+a     BACKSPACE
    Input Text            ${customers_txt_email}        ${customer["email"]}

    ${address}=    Set Variable    ${customer["address"]["street"]} ${customer["address"]["suite"]}
    Press Keys            ${customers_txt_address}    CTRL+a     BACKSPACE
    Input Text            ${customers_txt_address}      ${address}     

    Press Keys            ${customers_txt_birthday}    BACKSPACE    TAB    BACKSPACE    TAB    BACKSPACE
    Input Text            ${customers_txt_birthday}         ${customer["birthday"]}

    Press Keys            ${customers_txt_city}    CTRL+a     BACKSPACE
    Input Text            ${customers_txt_city}         ${customer["address"]["city"]}

    Press Keys            ${customers_txt_stateAbbr}    CTRL+a     BACKSPACE
    Input Text            ${customers_txt_stateAbbr}    ${customer["address"]["stateAbbr"]}

    Press Keys            ${customers_txt_zipcode}    CTRL+a     BACKSPACE
    Input Text            ${customers_txt_zipcode}      ${customer["address"]["zipcode"]}

    Press Keys            ${customers_txt_password}    CTRL+a     BACKSPACE
    Input Text            ${customers_txt_password}     ${customer["password"]}

    Press Keys            ${customers_txt_confirm_password}    CTRL+a     BACKSPACE
    Input Text            ${customers_txt_confirm_password}    ${customer["password"]}

    Click Element    ${customers_btn_save}

    Verify Customer Row Data By Email    ${customer}

Update And Verify Multiple Customers
    [Arguments]    @{customers}
    ${row_index}=    Set Variable    6
    FOR    ${user}    IN    @{customers}
        Update Existing Customer    ${user}    ${row_index}
        Verify Customer Row Data By Email    ${user}
        ${row_index}=    Evaluate    ${row_index} + 1
    END

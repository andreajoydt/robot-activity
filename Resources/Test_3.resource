*** Settings ***
Resource    ../Resources/App.resource
Library     Collections

*** Keywords ***
Log Table Data To Console
    ${rows}=    Get WebElements    ${table_row}
    ${index}=   Set Variable    1
    FOR    ${row}    IN    @{rows}
        Log To Console    ====== User ${index} ======

        ${name}=    Get Text    xpath=(//table//tr)[${index}+1]/td[2]
        Log To Console    Name: ${name}

        ${last_seen}=    Get Text    xpath=(//table//tr)[${index}+1]/td[3]
        Log To Console    Last seen: ${last_seen}

        ${orders}=    Get Text    xpath=(//table//tr)[${index}+1]/td[4]
        Log To Console    Orders: ${orders}

        ${total_spent}=    Get Text    xpath=(//table//tr)[${index}+1]/td[5]
        Log To Console    Total spent: ${total_spent}

        ${latest_purchase}=    Get Text    xpath=(//table//tr)[${index}+1]/td[6]
        ${latest_purchase}=    Set Variable If    '${latest_purchase}' != ''    ${latest_purchase}    No purchase
        Log To Console    Latest purchase: ${latest_purchase}

        ${has_newsletter}=    Get Element Attribute    xpath=(//table//tr)[${index}+1]/td[7]//*[name()='svg']     aria-label
        Log To Console    Has newsletter: ${has_newsletter}

        ${segment_elements}=    Get WebElements    xpath=(//table//tr)[${index}+1]/td[8]//span
        ${segments}=    Set Variable    None
        IF    ${segment_elements}
            ${segments}=    Get Text    ${segment_elements}[0]
            FOR    ${seg}    IN    @{segment_elements}[1:]
                ${text}=    Get Text    ${seg}
                ${segments}=    Catenate    SEPARATOR=,    ${segments}    ${text}
            END
        END
        Log To Console    Segments: ${segments}
        Log To Console    ${EMPTY}

        ${index}=    Evaluate    ${index} + 1
    END

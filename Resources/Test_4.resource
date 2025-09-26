*** Settings ***
Resource    ../Resources/App.resource
Library     Collections

*** Keywords ***
Display Users With Spending
    ${rows}=    Get WebElements    ${table_row}
    ${index}=   Set Variable    1

    FOR    ${row}    IN    @{rows}
        ${name}=    Get Text    xpath=(//table//tr)[${index}+1]/td[2]
        ${total_spent}=    Get Text    xpath=(//table//tr)[${index}+1]/td[5]
        ${amount}=    Evaluate    float(re.sub(r'[^0-9.]', '', '''${total_spent}''') or 0)    re
        IF    ${amount} > 0
            Log To Console    ${name}: ${total_spent}
        END
        ${index}=    Evaluate    ${index} + 1
    END

Calculate Total Spending
    ${rows}=    Get WebElements    ${table_row}
    ${index}=   Set Variable    1
    ${grand_total}=    Set Variable    0.0
    ${threshold}=    Set Variable    3500

    FOR    ${row}    IN    @{rows}
        ${total_spent}=    Get Text    xpath=(//table//tr)[${index}+1]/td[5]
        ${amount}=    Evaluate    float(re.sub(r'[^0-9.]', '', '''${total_spent}''') or 0)    re
        ${grand_total}=    Evaluate    ${grand_total} + ${amount}
        ${index}=    Evaluate    ${index} + 1
    END

    Log To Console    ========================================
    Log To Console    Total Customer Spending: $${grand_total}
    Log To Console    ========================================

    IF    ${grand_total} < ${threshold}
        Fail    FAIL: Total spending ($${grand_total}) is below minimum threshold ($${threshold})

    ELSE
        Log To Console    PASS: Total spending ($${grand_total}) meets minimum threshold ($${threshold})
    END


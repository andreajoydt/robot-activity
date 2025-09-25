*** Settings ***
Resource    ../Resources/App.resource
Library     ../Library/CustomLibrary.py
Library     Collections

Suite Setup    Run Keywords    Launch Browser    AND    Login User

*** Test Cases ***
TEST_1: ADD AND VERIFY FIRST 5 USERS
    ${first5}=    Get First Five Users
    Go To Customer Page
    Add And Verify Multiple Customers    @{first5}

TEST_2: UPDATE EXISTING CUSTOMERS
    ${last5}=    Get Last Five Users
    Go To Customer Page
    Update And Verify Multiple Customers    @{last5}

TEST_3: LOG TABLE DATA
    Go To Customer Page
    Log Table Data To Console

TEST_4: DISPLAY USERS WITH SPENDING
    Go To Customer Page
    Display Users With Spending
    Calculate Total Spending

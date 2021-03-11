# todo-list app

Mobile App Developer Assessment 


## Summary

This is an assessment assigned by Etiqa IT for a flutter mobile developer position.

The task was given on 10 March 2021 and the due date is 12 March 2021.
Initially, a UI was given with little description on how the app should behave.

Generally, it consists of two page where the first page is a list of entries while
the second page is the form for entries.

Candidate has to write a code that can navigate between both pages while passing a data
to each other.

It can be started by pressing a floating orange button at the center of the screen. This, will navigate
to the second screen. From this screen, it consist of text field for the user to input the title and
two dropdown button for the user to select the starting and ending date.

The second page also has a button at the bottom where the entries will be saved to the database.

In this apps, I am using an internal SQLite with the help of sqflite library. The entries will be saved
in the database then be displayed in the form of card in first page.

Other than that, the app also will calculate the time elapsed from current time until the task expired.
Additionally, the SQL helper will help arrranging the task from the most urgent to the task that has
been completed. This mean, any task that approacing the due date will be placed on top of the list.

There are several addition can be added to this app for better functionality such as

//TODO add notification for the incomplete task that approaching the due date
//TODO add objective section for each task
//TODO integrate the app to the cloud such as Firebase etc.

Unit test was not performed in this app, so does CI/CD.

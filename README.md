Grow Therapy Project 

by Blake Rogers


Features

List of Tasks
    When the client logs on they will see a list of tasks assigned to their account
    Upcoming tasks are locked
    Only the task for the current day is availble for selection
    Past completed tasks display the mood log by the client at the end of the session
    For convenience of testing the response of tasks has been altered so that one task within the next several days is viable for selection.
    When the client selects an assignment they are directed to the assignment view where they will enter the exercise section to begin their assigned exercise prior to meeting with the provider.
    If the client selects and the immediate fetch of the section discovers that the therapist is already in the session the client will be directed to the session instead to begin the meeting.
    
Exercise
    
    The client will see the instructions for the exercise.
    The client may tap on any part of the screen to begin the excercise
    The breathing animation will begin
    The client may tap on any part of the screen to pause the exercise
    If the response of the shared session is retrieved and the therapist is in the session the
    prompt to join the session will be displayed if the user is actively doing the exercise
    When the exercise is completed the user will be directed to the wait room
    
    
Waitroom

    When the client is directed to the wait the may merely wait for the provider
    A prompt will appear to allow client to join session when the provider is available
    For convenience of testing in the SessionClient file in the observeSessionFunction adjust the simulated
    wait time to return the observed Session sooner or later to see the change on the state of the Exercise or wait room for the provider available prompt
    When the client selects the prompt to join they are directed to the session
    
Session
    The client is in the session and may exit at any time
    Once the client selects exit they will be directed to the mood log

MoodLog
    
    The client may select a mood that they have been feeling generally throughout the week
    The assignment will be updated from the mood log and updated for completion for exercise and moodlog
    
    
    
    
    
    
    
    
    
Architectural Decisions

    Utilizing the Composable Architecture Design Pattern for its built in handling or 
    state management within SwiftUI in a declarative manner, refined testing framework, and ergonomics
    for an appplications dependencies both external and internal
    
    Instead of referring to the clients tasks as tasks they have been referred to as Assignments due to the conflicting naming convention between the inherent concurrency object of the same name.
    
    In the schedule view an an initial is called to fetch all of the assignments the user owns
    When the user returns to the schedule view after the completion of a session the assignments is updated
    This was done so that every view of the assignments is the latest result restored remotely
    
    I added a session id on the Assignemnt(Task) although only the exercise, date assigned, and mood were provided as required valuse
   
    This was done so that Sessions could be a complete model that is searchable and mutable. I assumed that the client would need to continually observe some remote value relative to the assignment they were in much like is done for chat features on typical applications with a chat or meeting feature.
    In this way both the client and the provider could retain a reference to the session.
    
    When the assignment is opened the session is observed for changes on the backend by referencing the session via the id. When the provider joins shared session is updated. (isTherapistInSession) which will trigger an observation stream on the client end.
    
    A notification could be utilized as well but I felt a live observation would be more reliable in that a user may choose to not allow notifications.
    
    By this way the Exercise and Waitroom feaetures did not require any network capability as they would be updated by the parent when the relevant Session was updated
    
    The MoodLog was enabled with a network capability to update the assignment. Since the MoodLog feature was implemented such that it was a requirement after the session, the Moodlog was made a child module of the SessionFeature and the assignment id passed through from the parent AssignmentFeature.
    
    For the convenience of testing the action to completed the mood save log was "fedback" to the parent assignment feature to update the list of assignments currently displayed in the app session for continuity.
    
    Possible Improvements
        A profile page for the client
        A separate page for the current or upcoming tasks and those that have been completed
        A feature to allow the client and/or the provider to add notes to the session after the session is completed. 
        A feature that would allow the provider to add talking points to discuss for the next session
        A companion provider application that will get the provider some private tools to assist the client
        A feedback feature for the client and/or therapist to note if the the client/therapist is inappropriate or is enjoyable to work with.
        A back button that will allow the client to back out of the any part of the application while retaining any completed status for assignment.
        Handling of error case when tasks are not fetched from remote server initially
        Instructions for the exercise could be more clear
        A reset feature on the breathing exercise to restart the breathing exercise if the client desires
        to start over or do it again.
        Instead of automatically navigating the user to the waiting give them a prompt to navigate to the wait room instead.
        Add feature to allow client to take notes prior to session beginning in the wait room or play a calming game

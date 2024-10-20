Grow Therapy Assignment

Features

List of Tasks
- Upon login, clients are presented with a list of tasks (referred to as "assignments") assigned to their account.
- Future tasks are locked, while only the task for the current day is available for selection.
- Completed tasks display the mood log submitted by the client at the end of the session.
- For testing purposes, one task within the next few days is made available for selection.
- Selecting an assignment takes the client to the assignment view, where they can begin the assigned exercise before meeting the provider.
- If the therapist is already in the session when the assignment is selected, the client is redirected to the session to begin the meeting.

Exercise
- Clients see the instructions for the exercise and can tap anywhere on the screen to start the exercise.
- A breathing animation plays, and the client can pause the exercise by tapping again.
- If the system detects that the therapist is in the session during the exercise, the client is prompted to join the session.
- Upon completion of the exercise, the client is directed to the waiting room.

Waiting Room
- Clients wait for the provider in the waiting room. When the provider becomes available, a prompt allows the client to join the session.
- For testing, you can modify the simulated wait time in the `SessionClient` file within the `observeSessionFunction` to trigger the session availability prompt sooner or later.
- When the prompt is selected, the client is directed to the session.

Session
- Clients can join the session and exit at any time. Upon exit, they are directed to complete a mood log.

Mood Log
- Clients can select a mood they have generally experienced throughout the week.
- The assignment is marked complete after the mood log is submitted, covering both the exercise and mood log components.

---

Architectural Decisions

- I used the **Composable Architecture Design Pattern** for its state management capabilities in SwiftUI, its robust testing framework, and its handling of external and internal dependencies.
- Assignments were referred to as such (instead of "tasks") to avoid conflicts with Swift's concurrency model.
- In the schedule view, an initial call fetches all assignments owned by the user. After completing a session, the assignments list is updated to reflect the latest remote data.
- I added a `sessionId` to the assignment model (in addition to exercise, date assigned, and mood) to allow for a more complete and mutable session model. This lets both the client and provider reference the same session object.
- Sessions are observed in real-time for changes on the backend via the `sessionId`. When a provider joins a session, the shared session is updated (e.g., `isTherapistInSession`), triggering an observation stream for the client.
- A live observation was favored over push notifications since users may opt-out of notifications, ensuring better reliability.
- Both the Exercise and Waiting Room features are updated based on changes in the parent session without needing additional network calls.
- The Mood Log utilizes network capabilities to update the assignment. Since it is required post-session, it was implemented as a child module of the `SessionFeature` and passed the assignment ID from the `AssignmentFeature`.
- For testing, completing the mood log "feeds back" into the parent assignment feature, updating the list of assignments displayed in the app.

---

Potential Improvements
- Add a profile page for the client.
- Separate completed and upcoming assignments into different views.
- Allow clients and providers to add notes after the session.
- Add a feature for providers to note talking points for the next session.
- Develop a companion provider app with private tools for assisting clients.
- Implement feedback features for both clients and therapists to report issues or praise.
- Add a back button to allow clients to exit any part of the app while retaining progress.
- Handle errors when tasks fail to fetch from the remote server.
- Clarify exercise instructions.
- Add a reset button to restart the breathing exercise.
- Offer a prompt to navigate to the waiting room, instead of automatic navigation.
- Allow clients to take notes or play a calming game while waiting for the session to start.


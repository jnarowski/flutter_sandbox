# User Invite System

This invite system will allow multiple users to share the same account.

## Team Management

- Create a team page that shows all active users and pending invitations.
- Create two cards that filter the users by status “active” and “invited”
- Allow invited users to be deleted or send invite
- This can be accessed from the account_screen
- Add a status column to the user with “active” or “invited”
- Add an inviteToken column
- Add an invitedById column (user id who invited)

## Invite a User

- Add an invite method to the user_service called “invite” to create a new user with an inviteToken and status of “invited”
- Send email to invite the user

## Accept the Invitation

- Load the app and the user from the users collection by the user.inviteToken
- Create a screen that shows the details of who invited them, and allows the user to accept the invitation.
- When accepted
  - Creates a Firebase Auth user
  - Calls acceptInvitation method to the user_service that sets the user status to “active”
  - Signs the user into the app
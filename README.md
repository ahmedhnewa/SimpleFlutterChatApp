# Chat App

A simple chat app and firebase as the backend using it's flutter SDK
If you want to try out this project, you have to set up firebase project
As I have excluded the credentials files from the project using .gitignore

Please notice the app is not suitable for use as it has some bugs and does not have push notifications.
for ios, and I don't have cloud functions so I can't implement it anyway, also
if you plan to publish it for real users, you have to setup rules for firestore and storage
and reduce image size for user profile, and also make sure to validate the fields that will be
in the firestore database, so users can't add any other fields, can't use invalid user uid when send message
for example and so on

<p float="left">
  <img width=35% src="https://user-images.githubusercontent.com/73608287/210568425-46e0fba6-5074-4182-8365-b6aa43a807a1.png">
  <img width=35% src="https://user-images.githubusercontent.com/73608287/210568423-89c24f72-bf88-4dd4-b29f-d5d2a0b19a20.png">
  <img width=35% src="https://user-images.githubusercontent.com/73608287/210568415-e2ba5d40-bd19-4770-9674-fff72e0426b2.png">
  <img width=35% src="https://user-images.githubusercontent.com/73608287/210568401-2d8489b8-94b8-4029-9e19-a7b9f21da149.png">
</p>

# Jira Counter Web

## Setup Jira Developer Account

Login to your Atlassian Developer Account and head to your [Jira Apps](https://developer.atlassian.com/console/myapps/)

</br></br>
`Click Create button and choose OAuth 2.0 Integration`<p>
![image](https://user-images.githubusercontent.com/31397565/202491237-cb44a95d-0f2e-4de3-8d77-bd6899a7d83e.png)

</br></br>
`Fill the app name and tick the requirment checkbox`<p>
![image](https://user-images.githubusercontent.com/31397565/202492570-f1229234-f9cd-4c82-8fb2-5e2fa4d16748.png)

</br></br>
`Go to Permissions section and add Jira Api`<p>
![image](https://user-images.githubusercontent.com/31397565/202494554-23cffe54-75ad-490c-8756-b49090e77fd4.png)

</br></br>
`Configure and edit the scoope of Jira platform REST API, then tick for View Jira issue data and save it`<p>
![image](https://user-images.githubusercontent.com/31397565/202496201-dbabb0ce-f86b-41b9-88db-073025c23db3.png)

</br></br>
`Head to Authorization section and fill the callback with your domain`<p>
![image](https://user-images.githubusercontent.com/31397565/202493856-3ac5e197-da8e-4568-9c79-b687ffdb5ea3.png)

</br></br>
`Go to Distribution section, change the distribution status to sharing with fill the requirments below`<p>
![image](https://user-images.githubusercontent.com/31397565/202497139-947a06cf-ffc5-4593-8e37-0eaeed5b1a96.png)

</br></br>
`Go to setting section and copy your client id and client secret`<p>
![image](https://user-images.githubusercontent.com/31397565/202499129-de25db6a-63a1-43ff-9f58-111eacff6cad.png)

</br></br>
Add your client id and client secret to your enviroment variable or export it to your .bashrc if you are using bash, use `JIRA_CLIENT_ID` and `JIRA_SECRET` as the variable name<p>

## Run the project
You can run the project by execute `flutter run web --dart-define=JIRA_CLIENT_ID=$JIRA_CLIENT_ID --dart-define=JIRA_SECRET=$JIRA_SECRET` to your terminal or cmd

## Build and deploy
Run `flutter build web --release --dart-define=JIRA_CLIENT_ID=$JIRA_CLIENT_ID --dart-define=JIRA_SECRET=$JIRA_SECRET` and wait patiently for it to be finished<p>
Then you can deploy `build/web` folder to your hosting

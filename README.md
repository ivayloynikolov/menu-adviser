# menu-adviser

The Menu Adviser app is intended to help people achieve their goals related to being overweight or underweight or to support their current weight status.

<img src="https://github.com/ivayloynikolov/menu-adviser/blob/dev/resources/01_SplashScreen.png" width="20%" alt="Splash screen">

The first screen of the app onboards users on what they should do to take advantage of the provided app's functionalities.
Other screens from the tab bar menu also depend on the entered personal data.
<p float="left">
<img src="https://github.com/ivayloynikolov/menu-adviser/blob/dev/resources/02_UserOnboarding.png" width="20%" alt="User onboarding">
<img src="https://github.com/ivayloynikolov/menu-adviser/blob/dev/resources/03_GoalOnboarding.png" width="20%" alt="Goal onboarding">
<img src="https://github.com/ivayloynikolov/menu-adviser/blob/dev/resources/04_ProgressOnboarding.png" width="20%" alt="Progress onboarding">
</p>

 
In the user details screen, users can add their name, age, sex, current weight, height, and physical activity. The app will calculate their current body mass index.

<img src="https://github.com/ivayloynikolov/menu-adviser/blob/dev/resources/04_UserDetails.png" width="20%" alt="User details">

The next screen allows users to enter their goals. It can be weight loss, weight gain, or keeping their current status. They can set their target activity, weight, and preferred pace for the transformation.
The app will calculate the target daily intake of calories and target body mass index. A comparison between current and target daily calorie intake and current and target body mass index is shown on that screen.
When all data is entered and the progress pace is selected, the app calculates the days needed to achieve set goals.

<img src="https://github.com/ivayloynikolov/menu-adviser/blob/dev/resources/05_GoalDetails.png" width="20%" alt="Goal details">

The next screen allows users to set their food preferences. They can mark if they are vegans or vegetarians as well as what allergens they want to be excluded from their daily menu.

<img src="https://github.com/ivayloynikolov/menu-adviser/blob/dev/resources/06_MenuPreferences.png" width="20%" alt="Menu preferences">

The progress screen shows a scroll view with estimated days needed to achieve the set goal. Each day allows the user to calculate the daily menu, considering the target daily calories and nutrient distribution based on set goals.
Daily menus can be generated subsequently, allowing the app to recalculate target daily calorie intake based on deviations from previous generated days.
There is a graphical representation of the progress, which follows a weight change and BMI all the way to the end of the challenge.
<p float="left">
<img src="https://github.com/ivayloynikolov/menu-adviser/blob/dev/resources/07_ProgressView.png" width="20%" alt="Progress view">
<img src="https://github.com/ivayloynikolov/menu-adviser/blob/dev/resources/07b_ProgressView.png" width="20%" alt="Progress view">
</p>

Pressing the Generate Daily Menu button sends a request to a specially prepared backend proxy server, which interprets requested data and redirects the request to a widespread public API - fat secret. The received response is filtered according to the requested calorie and nutrient distribution data.
The app receives a ready-for-use object, which is used to populate the scroll list with the summary of the dishes and the full details page on click.
<p float="left">
<img src="https://github.com/ivayloynikolov/menu-adviser/blob/dev/resources/10_GenerateMenu.png" width="20%" alt="Generate menu">
<img src="https://github.com/ivayloynikolov/menu-adviser/blob/dev/resources/08b_ProgressView.png" width="20%" alt="Generate menu">
<img src="https://github.com/ivayloynikolov/menu-adviser/blob/dev/resources/11_RecipeDetails.png" width="20%" alt="Recipe details">
</p>

The app uses Swift Data to store user data, goals data, food preferences, and generated menus. The initial allergens are loaded from the included local JSON file and later transferred to the Swift Data model.
AppStorage is used to store the last viewed page on application reload.

User data and goals can be edited or deleted. These actions are followed by resetting other data, such as progress, goals, etc. Notifications prevent incident deletion of the data.
<p float="left">
<img src="https://github.com/ivayloynikolov/menu-adviser/blob/dev/resources/12_UserDelete.png" width="20%" alt="Delete user">
<img src="https://github.com/ivayloynikolov/menu-adviser/blob/dev/resources/13_UserDelete.png" width="20%" alt="Delete user">
</p>

Error handling is also covered by different causes, which show alerts with appropriate information.
There is also network reachability detection. If a lack of connection happens, the alert shows to inform the user about the interruption. When the connection is back, missing images are reloaded.
<p float="left">
<img src="https://github.com/ivayloynikolov/menu-adviser/blob/dev/resources/12_UserDelete.png" width="20%" alt="Delete user">
<img src="https://github.com/ivayloynikolov/menu-adviser/blob/dev/resources/13_UserDelete.png" width="20%" alt="Delete user">
</p>
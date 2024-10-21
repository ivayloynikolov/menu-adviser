# menu-adviser
App for healthy eating according to the specified goals

The app is designed to assist individuals in enhancing their healthy habits. This goal can be achieved by providing daily and weekly menu suggestions that promote a more balanced and nutritious diet.
Users will be able to add their personal data like weight, height, age, gender, etc. According to the desired goals, these numbers can be used for proper calculation of recommended daily calorie consumption.
Based on these calculations, a public API will be used to get recipes that meet the conditions set.

Base schema of the used screens. 

![Basic schema](https://github.com/ivayloynikolov/menu-adviser/blob/checkpoint-1/resources/MenuAdviser_1.png)


## More detailed description and views' hierarchy schema

The user view shows the entered user's data. The rest of the properties will be used to calculate the current BMI value.

<img src="https://github.com/ivayloynikolov/menu-adviser/blob/dev/resources/01_UserView.png" width="20%" alt="User view">
<img src="https://github.com/ivayloynikolov/menu-adviser/blob/dev/resources/02_EditUserView.png" width="20%" alt="Edit user view">

The goals view shows the set goal (currently one of three options) and target weight. The rest of the properties are calculated based on scheduled goals, and some of the user's property values.

<img src="https://github.com/ivayloynikolov/menu-adviser/blob/dev/resources/03_GoalsView.png" width="20%" alt="Goals view">
<img src="https://github.com/ivayloynikolov/menu-adviser/blob/dev/resources/04_EditGoalsView.png" width="20%" alt="Edit goals view">

The generate menu view allows users to specify their meal preferences and generates the daily menu based on those preferences and current set goals.

<img src="https://github.com/ivayloynikolov/menu-adviser/blob/dev/resources/05_GenerateMenuView.png" width="20%" alt="Generate menu view">

The daily menu view shows the currently generated menu according to the provided parameters.

<img src="https://github.com/ivayloynikolov/menu-adviser/blob/dev/resources/06_DailyMenuView.png" width="20%" alt="Daily menu view">

The meal details view shows ingredients, macros, and directions for preparing the selected meal.

<img src="https://github.com/ivayloynikolov/menu-adviser/blob/dev/resources/07_MealDetailsView.png" width="20%" alt="Meal details view">

The progress view will show the current phase of the goals, including details for every day of the challenge.

<img src="https://github.com/ivayloynikolov/menu-adviser/blob/dev/resources/08_ProgressView.png" width="20%" alt="Progress view">
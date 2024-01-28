# Wisely.io

More info [here](https://www.notion.so/Wisely-io-195aaf253142480bb997f27a93f47ee6?pvs=4).

Wisely is a mobile application where the user can define budgets for certain moments and input their expenses for that budget, the application will help calculating the remaining budget, being a motivation for better money management.

------

## Main functionality

The user will have certain screens to work on, these being:

- Expense books: This is the main screen where the user will create or delete the expense books

  Sub-screen:

  - Add book: when pressing on the floating button on the bottom right it will open a

- Book: This screen will show on the top the name of the book and the expenses of it.

  Sub-screens:

  - Edit budget: If the user does a long press on the budget it will appear a menu with the option of editing the budget, and then it will appear a input so the user can modify the max budget.
  - Delete expense: if the user does a long press on the expense it will appear a menu with a button, if the user presses on “delete expense” it will appear a “confirmation”
  - Add expense: if the user presses on the floating button on the bottom right it will open a “add expense menu” where the user will input the “expense name” and the “value”

------

## Data Types

The main data to use is this, this is the way the data will be saved on the local storage.

```jsx
book: {
	id: 0
	name: "Secret santa" (string)
	budget: 30000 (float)
	expenses: [expense]
	date: date
}

expense: {
	id: 0
	name: "Toy"
	value: 2000
}
```

------

## Technical

In this section we will discuss the technical elements of the project, thinks like bugs, errors, or stuff to take in count for future projects.

- Material: for design purpose we will use material3 (since 3.16 in flutter its on by default) and cupertino for some elements
- Local Storage: for local storage access i will use the package of “shared preferences”.


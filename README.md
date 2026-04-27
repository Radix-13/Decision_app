# Decision Maker App

A Flutter-based decision-making application that helps users evaluate choices by comparing pros and cons using a weighted scoring system. The application converts subjective decisions into a measurable percentage score to support clearer and more structured decision-making.


## Overview

This application allows users to create a decision context, add supporting and opposing arguments, assign importance weights to each factor, and receive a real-time calculated score displayed in a visual format.

The goal of this project is to transform qualitative decision-making into a simple quantitative model.

---

## Features

- Create a decision with a custom title
- Add multiple pros and cons with descriptions
- Assign weight (1–10) to each entry
- Real-time score calculation based on weighted values
- Circular percentage visualization of decision score
- Dynamic color feedback based on score range
- Ability to delete individual pros and cons
- Instant UI updates with responsive interaction

---

## How It Works

1. The user enters a decision title (for example, "Should I change my job?")
2. The user adds pros and cons related to the decision
3. Each item is assigned a weight based on importance
4. The system calculates a score using weighted comparison
5. The result is displayed as a percentage in a circular indicator

---

## Score Calculation Logic

The decision score is calculated using the following formula:

Score = (Total Pros Weight / (Total Pros Weight + Total Cons Weight)) × 100

Score Interpretation:
- 70% and above: Positive decision outcome
- 40% to 69%: Neutral or uncertain decision
- Below 40%: Risky or unfavorable decision

---

## Tech Stack

- Flutter
- Dart
- percent_indicator package

---


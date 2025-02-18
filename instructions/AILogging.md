# AI Logging 

## Dependencies 

- intelligence
- speech_to_text

## Overview

Use voice and LLMs to help users log activities much faster than using a complex form. 

## Core Features

### LLM log text parsing service

See instructions/Logging.md for details on possible logging types, database structure etc. use this file to generate examples for the prompt. 

- Create an llm_logging_service that has the system prompt and all the specialized logic. It will use core/services/llm/llm_service internally to call llm apis. 
- Use this service to parse text from user and turn it into a structured json Log response
- Write a prompt to support all the log types and turn the result into structured json. 
- Provide the prompt with current time and the users time zone. 

#### Examples

Input: Oliver drank 5oz of formula at 4pm 
Output: {}

Input: Oliver slept for 30 mins at 4pm 
Output: {}

Input: Oliver had 2.5ml of Tylenol at 3:30
Output: {}

The key attributes to extract are:

- kid
- type
- startAt
- endAt (if relevant)

### Logging using AppIntents

- Performed in background
- Log baby activities using voice through Siri, AppIntents and flutter intelligence plugin
- Respond to the user telling them exactly what was created so they know it was accurate. 

### Query info using AppIntents

The user can ask the app information from the logs using app intents and Apple shortcuts to help them understand how the day is going. 

#### Examples 

- When did Oliver eat last?
- How much did he eat today?
- What was the last medicine he had?

### Logging in app 

The user will be able to open a modal and use voice (or type) which will use the logging llm service and system prompt to turn this into a log. 

- We will need a voice service to handle voice to text 
- The voice to text should start listening when the modal is opened 
- When the modal is closed the service should stop voice to text and clean it up 
- We need a service singleton that governs starting and stopping the voice to text
- The user will see voice text in an input and also the expected structured output as a preview. It will update when the user presses generate button 

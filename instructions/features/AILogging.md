# AI Logging

Use voice and LLMs to help users log activities much faster than using a complex form. 

## Dependencies

- intelligence
- speech_to_text

## Core Features

### LLM log text parsing service

This service will parse text from user and turn it into a structured json Log response.
See `instructions/Logging.md` for details log types, db schema etc. Use this file to generate examples for the prompt.

- Create a `features/logs/llm_logging_service` which contains the system prompt and all the specialized logic. It will use `lib/core/ai/llm_service.dart` internally to call llm apis.
- Write a system prompt for llm_logging_service to help turn text from the user into structured json.
- Provide the prompt with current time and the users time zone.

#### Examples

Input: Oliver drank 5oz of formula at 4pm
Output: {
    "kidId": "xxxxx",
    "type": "formula",
    "amount": 5,
    "startAt": "2024-01-01T16:00:00Z",
    "endAt": "2024-01-01T16:05:00Z"
}

Input: Oliver slept for 30 mins at 4pm
Output: {
    "kidId": "xxxxx",
    "type": "sleep",
    "duration": 30,
    "startAt": "2024-01-01T16:00:00Z",
    "endAt": "2024-01-01T16:30:00Z"
}

Input: Oliver had 2.5ml of Tylenol at 3:30
Output: {
    "kidId": "xxxxx",
    "type": "medicine",
    "amount": 2.5,
    "startAt": "2024-01-01T15:30:00Z",
}

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

- Create `core/services/voice_service.dart` which will leverage speech_to_text to listen to the user and convert it to text.
- The voice to text should start listening when the modal is opened
- When the modal is closed the service should stop voice to text and clean it up
- The user will see voice text in an input and also the expected structured output as a preview. It will update when the user presses generate button

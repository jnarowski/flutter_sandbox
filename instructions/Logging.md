# Baby Activity Logging

These represent different types of kid activities that can be logged. All of these will be logged in the same table, but the form fields displayed will change depending on the type selected. We will have a separate form component for each type and if the type has multiple categories, a separate form component for each category.

## Feature Location

Please place all widgets in the `lib/features/logs/widgets` folder.

## Table

Stores different baby activity logs (sleep, feeding, medicine, etc.).

| Field       | Type       | Description                               |
|------------|-----------|-------------------------------------------|
| `id`       | UUID      | Primary key                               |
| `type`     | STRING      | `formula`, `sleep`, `medicine`, etc.      |
| `category` | STRING      | changes dependent on the type. optional      |
| `subCategory` | STRING      | changes dependent on the category. optional   |
| `startAt` | DATETIME  | Start time of the logged event           |
| `endAt`   | DATETIME  | End time (for things like sleep). Not all types will have an end time.         |
| `amount`   | DECIMAL   | Used to store amount, duration, dosage, etc.  |
| `unit`     | STRING      | Example: `oz`, `ml`, `drops`, `tsp`, `hours`, `minutes`, `seconds`, dependent on the type. |
| `notes`    | STRING      | Any additional notes about the activity.      |
| `data`    | OBJECT      | Stores additional data that doesn't fit into the other fields. Will always be an object     |
| `createdAt` | DATETIME  | Record creation timestamp               |
| `updatedAt` | DATETIME  | Last modified timestamp                 |
| `accountId` | UUID      | Links to the current user's accountId              |
| `kidId`   | UUID      | Links to the `Kid` model                 |

## Types

### Feeding

Feeding has different categories and subcategories depending on the type.

#### Nursing

- type (value: feeding)
- kidId (field: dropdown, defaults to currentKidId)
- category (field: dropdown, value selected: nursing)
- startAt
- endAt
- data (object)
  - value (object)
    - durationLeft (total time in minutes and seconds spent nursing on the left breast)
    - durationRight (total time in minutes and seconds spent nursing on the right breast)
    - last (string, left or right)
- amount (duration of nursing, calculated as endAt - startAt)
- notes (string - optional)

#### Bottle

- type (value: feeding)
- kidId (field: dropdown, defaults to currentKidId)
- category (field: dropdown, value selected: bottle)
- subCategory (field: dropdown, options: breast milk, goat milk, cow's milk, formula, tube feeding, soy milk, other)
- startAt
- amount
- unit (enum - oz, ml, drops, tsp)
- notes (string - optional)

### Medicine

- type (value: medicine)
- kidId (field: dropdown, defaults to currentKidId)
- startAt
- amount
- unit (dropdown, options: oz, ml, drops, tsp)
- notes (optional)

### Sleep

- type (value: sleep)
- kidId (field: dropdown, defaults to currentKidId)
- startAt
- endAt
- amount (hidden, calculated, calculated as endAt - startAt)
- notes (optional)

### Solids

- type (value: solids)
- kidId (field: dropdown, defaults to currentKidId)
- data (object)
  - value (array of foods)
    - name (dropdown, options: banana, avacado, etc.)
    - notes (optional, for each food)
- category (label: Reaction, field: emoji list, options: loved it, meh, hated it, allergy or sensitivity.)
- startAt
- notes (optional)

### Pumping

- type (value: pumping)
- kid_id (field: dropdown, defaults to currentKidId)
- startAt
- endAt
- amount (total pumped)
- amountLeft (amount pumped on left side, specific to nursing)
- amountRight (amount pumped on right side, specific to nursing)
- notes (string, optional)

### Bathroom

- type (string, bathroom)
- kid_id (string, dropdown, defaults to currentKidId)
- category (enum - diaper, potty)
- subCategory (enum - pee, poo, mixed, dry) - only for diaper category
- subCategory (enum - sat but dry, potty, accident) - only for potty category
- date (datetime)
- notes (string, optional)

### Activity

- type (string, activity)
- kid_id (string, dropdown, defaults to currentKidId)
- category (enum - tummy time, baby sparks, story time, screen time, skin to skin, outdoor play, indoor play, brush teeth)
- date (datetime)
- notes (string, optional)

### Growth

I might need to rethink this depending on how complex it is to store the data in a sub-object

- type (string, growth)
- kid_id (string, dropdown, defaults to currentKidId)
- data (object)
  - height (float)
  - height_unit (string, inches, cm)
  - weight (float)
  - weight_unit (string, lbs, kg)
  - head_circumference (float)
  - head_circumference_unit (string, inches, cm)
- date (datetime)
- notes (string, optional)

# MongoDB Data Modeling and Querying Project

This project demonstrates data modeling and querying using MongoDB with different approaches implemented in Python.

## Project Structure

- **`Model1.py`**
  - Defines the `Model1` class that interacts with MongoDB.
  - Uses separate collections for `person` and `company`.
  - Establishes one-to-many relationships between people and companies using `company_id`.
  - Executes predefined queries (`query_q1`, `query_q2`, `query_q3`, `query_q4`) on the data.

- **`Model2.py`**
  - Defines the `Model2` class with an alternative MongoDB interaction approach.
  - Uses a single `person` collection where company details are embedded within each person document.
  - Executes similar predefined queries (`query_q1`, `query_q2`, `query_q3`, `query_q4`) on the data.

- **`Model3.py`**
  - Defines the `Model3` class with a unique MongoDB data modeling approach.
  - Uses a `company` collection where employee details are embedded as subdocuments within each company document.
  - Executes predefined queries (`query_q1`, `query_q2`, `query_q3`, `query_q4`) on the data.

## Usage

1. **Setup**
   - Ensure MongoDB is installed and running locally.
   - Install required Python packages: `pymongo`, `Faker`.

2. **Running the Scripts**
   - Execute each model script individually to generate data and perform queries.
   - Adjust parameters (`n_people`, `n_companies`) in the `data_generator` method to vary the data volume.

Example usage:
```bash
python Model1.py
python Model2.py
python Model3.py

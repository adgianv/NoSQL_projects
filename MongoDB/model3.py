import datetime
import time
from pymongo import MongoClient
from faker import Faker

# This Python script demonstrates data generation and querying using MongoDB.
# The Model3 class connects to a MongoDB database and generates random data 
# for companies, each containing embedded employee details.

# The 'company' collection represents companies with embedded documents 
# for employees, facilitating more complex queries for retrieving company info.

# Queries involve aggregations and updates on the 'company' 
# collection, leveraging MongoDB's capabilities effectively.
# Adjust the parameters in `data_generator` for desired data volume.

class Model3:
    def data_generator(self, n_people, n_companies):
        # Connect to MongoDB - Note: Change connection string as needed
        client = MongoClient('127.0.0.1:27017')
        db = client['test']

        # drop existing collections if they exist
        db.drop_collection("company")

        # create collection for companies
        company_collection = db.create_collection('company')

        # Create sample data using Faker
        fake = Faker()

        # Average number of employees per company
        employees_per_company = n_people // n_companies

        for _ in range(n_companies):
            company_data = {
                "name": fake.company(),
                "domain": fake.domain_name(),
                "email": fake.company_email(),
                "url": fake.url(),
                "vatNumber": fake.random_number(digits=9),
                "employees": []  # Embedded documents for employees
            }
  
            # Generate random employees for the company
            for _ in range(employees_per_company):
                birthdate = fake.date_of_birth(minimum_age=18, maximum_age=90)
                birthdate_datetime = datetime.datetime.combine(birthdate, datetime.datetime.min.time())
                employee_data = {
                    "fullName": fake.name(),
                    "firstName": fake.first_name(),
                    "sex": fake.random_element(elements=('Male', 'Female')),
                    "age": fake.random_int(min=18, max=90),
                    "dateOfBirth": birthdate_datetime,  # Convert date to datetime
                    "email": fake.email(),
                }
                company_data["employees"].append(employee_data)

            company_collection.insert_one(company_data)

        # close MongoDB connection
        client.close()

    def query_q1(self):
        client = MongoClient('127.0.0.1:27017')
        db = client['test']
        company_collection = db['company']

        query_start_time = time.time()
        results = company_collection.aggregate([
            {"$unwind": "$employees"},
            {"$project": {"_id": 0, "fullName": "$employees.fullName", "companyName": "$name"}}
        ])

        # for result in results:
        #     print(result)

        query_time = time.time() - query_start_time
        print("Query execution time for Q1: {:.6f} seconds".format(query_time))

        client.close()

    def query_q2(self):
        client = MongoClient('127.0.0.1:27017')
        db = client['test']
        company_collection = db['company']

        query_start_time = time.time()
        results = company_collection.find({})

        # for result in results:
        #     num_employees = len(result["employees"])
        #     print("Company:", result["name"], "has", num_employees, "employees")

        query_time = time.time() - query_start_time
        print("Query execution time for Q2: {:.6f} seconds".format(query_time))

        client.close()

    def query_q3(self):
        client = MongoClient('127.0.0.1:27017')
        db = client['test']
        company_collection = db['company']

        query_start_time = time.time()
        result = company_collection.update_many(
            {"employees.dateOfBirth": {"$lt": datetime.datetime(1988, 1, 1)}},
            {"$set": {"employees.$.age": 30}}
        )

        print("Number of documents updated for Q3:", result.modified_count)

        query_time = time.time() - query_start_time
        print("Query execution time for Q3: {:.6f} seconds".format(query_time))

        client.close()

    def query_q4(self):
        client = MongoClient('127.0.0.1:27017')
        db = client['test']
        company_collection = db['company']

        query_start_time = time.time()
        result = company_collection.update_many(
            {},
            {"$set": {"name": {"$concat": ["$name", " Company"]}}}
        )

        print("Number of documents updated for Q4:", result.modified_count)

        query_time = time.time() - query_start_time
        print("Query execution time for Q4: {:.6f} seconds".format(query_time))

        client.close()


# Example usage
if __name__ == "__main__":
    model3 = Model3()
    model3.data_generator(n_people=50000,
                           n_companies=1000)  # Generate random data for 50000 people and 1000 companies
    model3.query_q1()  # Execute Q1 query for Model 3
    model3.query_q2()  # Execute Q2 query for Model 3
    model3.query_q3()  # Execute Q3 query for Model 3
    model3.query_q4()  # Execute Q4 query for Model 3

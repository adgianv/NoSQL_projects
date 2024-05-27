import datetime
import time
from pymongo import MongoClient
from faker import Faker

# This Python script showcases data generation and querying using MongoDB with a 
# different approach compared to Model 1. The "Model2" class interacts with a MongoDB database, 
# generating random data for people and companies and executing predefined queries.

# The 'person' collection stores detailed information about individuals, 
# including their association with companies directly embedded within them.

# Queries leverage MongoDB's aggregation framework and update operations.
# Adjust the parameters in `data_generator` function call for desired data volume.

class Model2:
    def data_generator(self, n_people, n_companies):
        # Connect to MongoDB - Note: Change connection string as needed
        client = MongoClient('127.0.0.1:27017')
        db = client['test']

        # drop existing collections if they exist
        db.drop_collection("person")

        # create collection for people
        person_collection = db.create_collection('person')

        # Create sample data using Faker
        fake = Faker()

        # Generate companies data
        companies_data = []
        for _ in range(n_companies):
            company_data = {
                "name": fake.company(),
                "domain": fake.domain_name(),
                "email": fake.company_email(),
                "url": fake.url(),
                "vatNumber": fake.random_number(digits=9)
            }
            companies_data.append(company_data)

        # Generate people data
        for _ in range(n_people):
            birthdate = fake.date_of_birth(minimum_age=18, maximum_age=90)
            birthdate_datetime = datetime.datetime.combine(birthdate, datetime.datetime.min.time())
            person_data = {
                "fullName": fake.name(),
                "firstName": fake.first_name(),
                "sex": fake.random_element(elements=('Male', 'Female')),
                "age": fake.random_int(min=18, max=90),
                "dateOfBirth": birthdate_datetime,  # Convert date to datetime
                "email": fake.email(),
                "company": fake.random_element(companies_data)
            }
            person_collection.insert_one(person_data)

        # close MongoDB connection
        client.close()

    def query_q1(self):
        client = MongoClient('127.0.0.1:27017')
        db = client['test']
        person_collection = db['person']

        query_start_time = time.time()
        results = person_collection.find({}, {"fullName": 1, "company.name": 1})

        # for result in results:
        #     print(result)

        query_time = time.time() - query_start_time
        print("Query execution time for Q1: {:.6f} seconds".format(query_time))

        client.close()

    def query_q2(self):
        client = MongoClient('127.0.0.1:27017')
        db = client['test']
        person_collection = db['person']

        query_start_time = time.time()
        results = person_collection.aggregate([
            {
                "$group": {
                    "_id": "$company.name",
                    "num_employees": {"$sum": 1}
                }
            }
        ])

        # for result in results:
        #     print(result)

        query_time = time.time() - query_start_time
        print("Query execution time for Q2: {:.6f} seconds".format(query_time))

        client.close()

    def query_q3(self):
        client = MongoClient('127.0.0.1:27017')
        db = client['test']
        person_collection = db['person']

        query_start_time = time.time()
        result = person_collection.update_many(
            {"dateOfBirth": {"$lt": datetime.datetime(1988, 1, 1)}},
            {"$set": {"age": 30}}
        )

        print("Number of documents updated for Q3:", result.modified_count)

        query_time = time.time() - query_start_time
        print("Query execution time for Q3: {:.6f} seconds".format(query_time))

        client.close()

    def query_q4(self):
        client = MongoClient('127.0.0.1:27017')
        db = client['test']
        person_collection = db['person']

        query_start_time = time.time()
        result = person_collection.update_many(
            {},
            {"$set": {"company.name": {"$concat": ["$company.name", " Company"]}}}
        )

        print("Number of documents updated for Q4:", result.modified_count)

        query_time = time.time() - query_start_time
        print("Query execution time for Q4: {:.6f} seconds".format(query_time))

        client.close()


# Example usage
if __name__ == "__main__":
    model2 = Model2()
    model2.data_generator(n_people=50000,
                           n_companies=1000)  # Generate random data for 50000 people and 1000 companies
    model2.query_q1()  # Execute Q1 query for Model 2
    model2.query_q2()  # Execute Q2 query for Model 2
    model2.query_q3()  # Execute Q3 query for Model 2
    model2.query_q4()  # Execute Q4 query for Model 2

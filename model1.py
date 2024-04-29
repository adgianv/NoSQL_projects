import datetime
import time
from pymongo import MongoClient
from faker import Faker


class Model1:
    def data_generator(self, n_people, n_companies):
        # Connect to MongoDB - Note: Change connection string as needed
        client = MongoClient('127.0.0.1:27017')
        db = client['test']

        # drop existing collections if they exist
        db.drop_collection("person")
        db.drop_collection("company")

        # create collections for people and companies
        person_collection = db.create_collection('person')
        company_collection = db.create_collection('company')

        # Create sample data using Faker
        fake = Faker()

        # Generate companies data
        for _ in range(n_companies):
            company_data = {
                "name": fake.company(),
                "domain": fake.domain_name(),
                "email": fake.company_email(),
                "url": fake.url(),
                "vatNumber": fake.random_number(digits=9)
            }
            company_collection.insert_one(company_data)

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
                "company_id": fake.random_element(company_collection.distinct("_id")),
                # Assuming each person belongs to a single company
            }
            person_collection.insert_one(person_data)

        # close MongoDB connection
        client.close()

    def query_q1(self):
        client = MongoClient('127.0.0.1:27017')
        db = client['test']
        person_collection = db['person']
        company_collection = db['company']

        query_start_time = time.time()
        results = person_collection.aggregate([
            {
                "$lookup": {
                    "from": "company",
                    "localField": "company_id",
                    "foreignField": "_id",
                    "as": "company_info"
                }
            },
            {
                "$project": {
                    "fullName": 1,
                    "company_name": {"$arrayElemAt": ["$company_info.name", 0]}
                }
            }
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
        results = company_collection.aggregate([
            {
                "$lookup": {
                    "from": "person",
                    "localField": "_id",
                    "foreignField": "companyEmail",
                    "as": "employees"
                }
            },
            {
                "$project": {
                    "company_name": "$name",
                    "num_employees": {"$size": "$employees"}
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
    model1 = Model1()
    model1.data_generator(n_people=50000,
                          n_companies=1000)  # Generate random data for 50000 people and 1000 companies
    model1.query_q1()  # Execute Q1 query for Model 1
    model1.query_q2()  # Execute Q2 query for Model 1
    model1.query_q3()  # Execute Q3 query for Model 1
    model1.query_q4()  # Execute Q4 query for Model 1
    

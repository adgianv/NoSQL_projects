// UPDATING THE EXISTING GRAPH

// This file contains Cypher queries for updating an existing graph in a Neo4j database. The updates include loading 
// additional data and establishing new relationships based on the existing graph structure.


// LOADING THE OUTPUT FILES 

// Reviews:
LOAD CSV WITH HEADERS FROM 'file:///data_lab2/reviews.csv' AS row
CREATE (:Review {id: row.START_ID, review:row.review, author_id: row.END_ID, article_id:row.review_id, accepted: toBoolean(row.accepted)});

// Add the affiliation:
// Companies:
LOAD CSV WITH HEADERS FROM 'file:///data_lab2/company.csv' AS row
CREATE (:Company {id: row.ID, name:row.name,company_type: row.company_type});

// Universities:
LOAD CSV WITH HEADERS FROM 'file:///data_lab2/universities.csv' AS row
CREATE (:University {id: row.ID, name:row.name, uni_type: row.uni_type});


// RELATIONSHIPS

// Review - Author
LOAD CSV WITH HEADERS FROM 'file:///data_lab2/reviews.csv' AS row
MATCH (re:Review {id: row.START_ID}), (aut:Author {id: row.END_ID})
CREATE (rev)-[:WRITTEN_BY]->(aut);

// Review - Article
LOAD CSV WITH HEADERS FROM 'file:///data_lab2/reviews.csv' AS row
MATCH (rev:Review {id: row.START_ID}), (art:Article {id: row.review_id})
CREATE (rev)-[:REVIEW_OF]->(art);

// Author - University:
LOAD CSV WITH HEADERS FROM 'file:///data_lab2/author_affiliated_with_university.csv' AS row 
MATCH (au:Author{id:row.START_ID}), (uni:University{id:row.END_ID})
CREATE (au)-[:AFFILIATED_WITH]->(uni);

// Author - Company
LOAD CSV WITH HEADERS FROM 'file:///data_lab2/author_affiliated_with_company.csv' AS row 
MATCH (au:Author{id:row.START_ID}), (comp:Company{id:row.END_ID})
CREATE (au)-[:AFFILIATED_WITH]->(comp);


// Majority review:
MATCH (art:Article)<-[:REVIEW_OF]-(rev:Review)
WITH art, COUNT(rev) AS total_reviews, COUNT(FILTER(r IN COLLECT(rev) WHERE r.accepted)) AS accepted_reviews
SET art.accepted = (accepted_reviews > total_reviews / 2)
RETURN art.id, art.title, art.accepted;
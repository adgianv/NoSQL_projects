// This file contains a the Cypher queries used to load data into a Neo4j graph database from CSV files.
// The data represents a subset of an academic paper database with entities such as Journals, Authors, Articles, Keywords, and Conferences,
// and their relationships. 

// This schema for loading data into a Neo4j graph database is efficient due to its large separation of nodes and 
// relationships, utilization of indices, optimized relationship creation, and scalability 
// considerations. It leverages Neo4j's strengths in handling graph-based data structures to ensure optimal performance and maintainability in the long term.

// LOADING THE OUTPUT FILES

// Journals
LOAD CSV WITH HEADERS FROM 'file:///data_lab2/journal.csv' AS row
CREATE (:Journal {id: row.ID, name:row.journal});

// Authors
LOAD CSV WITH HEADERS FROM 'file:///data_lab2/author.csv' AS row
CREATE (:Author {id: row.ID, name: row.author});

// Articles
LOAD CSV WITH HEADERS FROM 'file:///data_lab2/article.csv' AS row FIELDTERMINATOR '|'
CREATE (:Article {id: row.ID, title: row.title, abstract: row.abstract});

// Keywords
LOAD CSV WITH HEADERS FROM 'file:///data_lab2/keyword.csv' AS row
CREATE (:Keyword {id: row.ID,keyword:row.keyword});

// Conferences
LOAD CSV WITH HEADERS FROM 'file:///data_lab2/conference.csv' AS row
CREATE (:Conference {id: row.ID, name: row.conference, edition:row.edition});


// RELATIONSHIPS

// Article (citation)
LOAD CSV WITH HEADERS FROM 'file:///data_lab2/article_has_citation.csv' AS row 
MATCH (ar:Article{id:row.START_ID}), (cit:Article{id:row.END_ID})
CREATE (ar)-[:HAS_CITATION]->(cit);

// Author - Article (write)
LOAD CSV WITH HEADERS FROM 'file:///data_lab2/author_writes_article.csv' AS row
MATCH (aut:Author{id: row.START_ID}), (art:Article{id: row.END_ID})
CREATE (aut)-[:WROTE{corresponding:toBoolean(row.corresponding)}]->(art);

// Author - Article (review)
LOAD CSV WITH HEADERS FROM 'file:///data_lab2/author_reviews_article.csv' AS row
MATCH (aut:Author{id: row.END_ID}), (art:Article{id: row.review_id})
CREATE (aut)-[:REVIEWED]->(art);

// Article - Journal
LOAD CSV WITH HEADERS FROM 'file:///data_lab2/journal_published_in.csv' AS row
MATCH (a:Article{id:row.START_ID}), (b:Journal{id:row.END_ID})
CREATE (a)-[:PUBLISHED_BY]->(b);

// Article - Conference:
LOAD CSV WITH HEADERS FROM 'file:///data_lab2/conference_published_in.csv' AS row 
MATCH (ar:Article{id:row.START_ID}), (conf:Conference{id:row.END_ID})
CREATE (ar)-[:PUBLISHED_BY]->(conf);

// Article - Keywords
LOAD CSV WITH HEADERS FROM 'file:///data_lab2/article_has_keyword.csv' AS row 
MATCH (art:Article{id:row.START_ID}), (keyword:Keyword{id:row.END_ID})
CREATE (art)-[:CONTAINS_KEYWORD]->(keyword);
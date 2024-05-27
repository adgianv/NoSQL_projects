// This file contains the cypher queries to load the full updated graph into Neo4j.

// LOADING THE FULL GRAPH

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

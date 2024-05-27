// QUERIES:

// This file contains some Cypher queries to run on the built graph.

// QUERY 1.
// Top 3 most cited papers per conference

MATCH (citedArticle:Article)<-[:HAS_CITATION]-(article:Article)-[:PUBLISHED_BY]->(conference:Conference)
WITH conference, article, COUNT(citedArticle) AS citationCount
ORDER BY conference.id, citationCount DESC
WITH conference, COLLECT([article, citationCount]) AS topPapers
RETURN conference.name AS conference_name,
       topPapers[0][0].title AS paper1, topPapers[0][1] AS num_cites1,
       topPapers[1][0].title AS paper2, topPapers[1][1] AS num_cites2,
       topPapers[2][0].title AS paper3, topPapers[2][1] AS num_cites3;


// QUERY 2.
// Community of each conference

// Find authors who have published papers in at least 4 different editions of the same conference
MATCH (conf:Conference)
WITH conf.name AS conferenceName, collect(conf.edition) AS editions
WHERE size(editions) >= 4

// Match authors who have published papers in the specified conference editions
MATCH (aut:Author)-[:WROTE]->(art:Article)-[:PUBLISHED_BY]->(conf:Conference)
WHERE conf.name = conferenceName AND conf.edition IN editions

// Group authors by conference
WITH conferenceName, aut, count(distinct conf) AS editionCount
WHERE editionCount >= 4

// Return the conference name and the community of authors
RETURN conferenceName AS Conference, COLLECT(aut.name) AS Community;


// QUERY 3:
// Impact Impact Factor

MATCH (j:Journal)<-[:PUBLISHED_BY]-(art:Article)
OPTIONAL MATCH (citingArt:Article)-[:HAS_CITATION]->(art)
WITH j, COUNT(art) AS totalPapers, COUNT(citingArt) AS totalCitations
WHERE totalPapers > 0
RETURN j.name AS Journal, (toFloat(totalCitations) / totalPapers) AS ImpactFactor
ORDER BY ImpactFactor DESC;


// QUERY 4.
// H-index

MATCH (author:Author)-[:WROTE]->(article:Article)
OPTIONAL MATCH (article)<-[:HAS_CITATION]-(citingArticle:Article)
WITH author, article, COUNT(citingArticle) AS numCitations
ORDER BY author.name, numCitations DESC
WITH author, COLLECT(numCitations) AS allCitations
WITH author, SIZE([index IN RANGE(0, SIZE(allCitations) - 1) WHERE allCitations[index] >= index + 1]) AS h_index
RETURN author.name AS Author, h_index AS HIndex
ORDER BY HIndex DESC;

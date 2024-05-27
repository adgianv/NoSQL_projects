// PageRank Algorithm
// Step 1: Project the graph
CALL gds.graph.project(
    'articlesRankGraph', // Name of the in-memory graph
    'Article',       		  // Node label
    'HAS_CITATION'  	 // Relationship type
) YIELD graphName, nodeCount, relationshipCount;

// Step 2: Run the PageRank algorithm
CALL gds.pageRank.stream('articlesRankGraph')
YIELD nodeId, score
RETURN gds.util.asNode(nodeId).title AS articleTitle, score
ORDER BY score DESC
LIMIT 20;
// Betweenness Centrality Algorithm

// This file contains the code to build and run a Betweenness algorith on the Academic Papers graph database.

// Building the graph
CALL gds.graph.project(
    'BetweennessGraph', // Name 
    'Article',                  // Node label
    'HAS_CITATION'              // Relationship label
) YIELD graphName, nodeCount, relationshipCount;


// Running the Betweenness Centrality algorithm
CALL gds.betweenness.stream('BetweennessGraph')
YIELD nodeId, score
RETURN gds.util.asNode(nodeId).title AS articleTitle, score
ORDER BY score DESC
LIMIT 20;
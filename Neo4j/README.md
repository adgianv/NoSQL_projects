# Academic Papers Graph Database

## Project Overview

This project involves building a graph database to store and analyze data on academic papers using Neo4j. The data includes information about authors, articles, journals, and more including their relationships. The project involves importing data from CSV files, running various queries, and applying the PageRank and Betweennes algorithms to analyze the influence of articles.

In the Review.pdf file you can find the explanations, evaluations and justifications of the different parts of the project.

## Features

- Import data from multiple CSV files into a Neo4j graph database
- Define and establish relationships
- Execute complex Cypher queries to extract meaningful insights
- Implement the PageRank and Betweennes algorithms to rank articles based on their influence
- Visualize the graph data using Neo4j Browser

## Data Sources

The project uses the CSV files in the 'data_lab2' repository

## Installation

### Prerequisites

- [Neo4j Desktop](https://neo4j.com/download/)
- Java 11 (required by Neo4j)

### Steps

1. **Clone the Repository:**
    ```bash
    git clone https://github.com/adgianv/NoSQL_projects.git
    cd NoSQL_projects/Neo4j
    ```

2. **Install Neo4j Desktop:**
    Download and install Neo4j Desktop from the [official website](https://neo4j.com/download/).

3. **Create a New Project in Neo4j Desktop:**
    Open Neo4j Desktop and create a new project.

4. **Create a New Database:**
    Within the project, create a new Neo4j database instance.

5. **Start the Database:**
    Start the Neo4j database instance you just created.

## Data Import

1. **Place CSV Files:**
    Place your CSV files in the `import` directory of your Neo4j database.

2. **Run Cypher Scripts:**
    Use the Cypher scripts to import data into Neo4j with their relationships.


## Usage

### Neo4j Browser

- **Access Neo4j Browser:** Open Neo4j Browser by navigating to `http://localhost:7474` in your web browser.

- **Run Queries:** Use the Cypher query editor to run queries and explore the graph data.


## Queries and Algorithms

- **PageRank and Betweenness Algorithms:**
    The PageRank and Betweenness algorithms are implemented to rank authors and articles based on their influence within the graph.

- **Other Analytical Queries:**
    Additional queries can be executed to gain insights into co-authorship, citation networks, and journal impact.

## Results

The results of the PageRank algorithm and various queries provide insights into the most influential authors and articles, collaboration patterns, and the overall structure of the academic network.

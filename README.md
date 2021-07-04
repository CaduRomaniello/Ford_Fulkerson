# Ford & Fulkerson
Here is implemented the Ford & Fulkerson algorithm to find the maximum flow in a graph with a feasible initial flow.

---
## Requirements 
To run the code you'll need to have [Julia](https://julialang.org/downloads/) compiler installed in your machine.

To verify if you have all the packages installed on your machine run the following command in the terminal, if you don't have them, the program will automatically install them for you.
```bash
> julia dependencies/install_dependencies.jl
```

---
## Execution
The execution line is the same for windows and linux. You'll need to provide 3 parameters

```bash
> julia main.jl <file.json> <sourceVertex> <targetVertex>
```

The parameters between <> are required
- **file.json** - a JSON file that needs to follow the pattern shown below. It'll contains the graph on which you want to run the algorithm;
- **sourceVertex** - this parameter represents the source vertex name which needs to be the same as the vertex name in the JSON;
- **targetVertex** - this parameter represents the target vertex name which needs to be the same as the vertex name in the JSON`.
---
## JSON
The algorithm uses a JSON file as input which represents the graph, because of it there are some patterns that need to be followed.

```JSON
{
    "vertices": [
        {"name": "A"},
        {"name": "B"},
        {"name": "C"}
    ],
    "edges": [
        {"name": "A->B", "origin": "A", "destiny": "B", "inferiorLimit": 0, "superiorLimit": 4, "viableFlow": 0},
        {"name": "A->C", "origin": "A", "destiny": "C", "inferiorLimit": 0, "superiorLimit": 4, "viableFlow": 0},
        {"name": "B->C", "origin": "B", "destiny": "C", "inferiorLimit": 0, "superiorLimit": 4, "viableFlow": 0}
    ]
}
```

- In 'vertices' field you need to provide all the vertices with their respective names (you can name them whatever you like, as long as they are the same names listed in the edge field. If there is more than one vertex with the same name, the algorithm will not work correctly);
- In the field 'edges' you need to provide all the edges in the graph with their respective names (you can name them whatever you like), the origin and destiny vertices (with the same names of the vertices in the 'vertices' field), the inferior and superior limits of the edge an the initial feasible flow on it.

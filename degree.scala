//equivalent of g.V().property('degree',bothE().count())

//replace graph_ip by the graph to use
val g = spark.dseGraph("graph_ip")

//loading the vertices
val df_v =spark.read.format("com.datastax.bdp.graph.spark.sql.vertex").option("graph","graph_ip").load() //optional .filter(col("~label") === "event") //if we want to apply it only to vertices of label "event"
//loading the edges
val df_e =spark.read.format("com.datastax.bdp.graph.spark.sql.edge").option("graph","graph_ip").load()

//the line below is to count in and out edges of vertices. Suppress the union and just use one side to compute in_degree or out_degree.
val df_gc = df_e.select("dst").withColumnRenamed("dst","src").union(df_e.select("src")).groupBy("src").count().withColumnRenamed("count","degree")
//joining calculated degree to the vertices
val df_merged = df_v.drop("degree").join(df_gc,$"id" === $"src").drop("src")
//updating the graph (only the degree property)
g.updateVertices(df_merged.select("id","~label","degree"))

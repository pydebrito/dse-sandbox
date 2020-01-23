val g = spark.dseGraph("ldbc")
import org.apache.spark.sql.functions.regexp_replace
import org.apache.spark.sql.functions.col
val df_v =spark.read.format("com.datastax.bdp.graph.spark.sql.vertex").option("graph","ldbc").load().filter(col("~label") === "person")
val df_v2 = df_v.withColumn("fullName", concat($"firstName", lit(" "), $"lastName")).withColumn("~label",lit("personFullName")).withColumn("id",regexp_replace(col("id"),"person","personFullName")).drop("firstName").drop("lastName")
g.updateVertices(df_v2)

val df_e = df_v.withColumn("src",col("id")).withColumn("~label",lit("is")).withColumn("dst",regexp_replace(col("id"),"person","personFullName")).select("src","dst","~label")
g.updateEdges(df_e)

//to check in gremin : g.V().hasLabel('person').limit(10).union(identity(),out("is"))

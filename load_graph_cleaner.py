from pyspark.sql import SparkSession
from pyspark.sql.types import *
from pyspark.sql.functions import *
import datetime

start = datetime.datetime.now()
print(datetime.datetime.now()-start)

#the input file is a csv with source & destination vertices for each edge (separator: ',')
#I got a test graph from here : https://snap.stanford.edu/data/#socnets
#the input file has to be copied to dse fs beforehand :
#>dse fs
#dsefs> put file:/home/py/data/graphs/soc-LiveJournal1_clean.txt soc-LiveJournal1_clean.txt

#input_file = "soc-sign-bitcoinalpha.csv"
#graph_name = "graph_sandbox"

input_file = "soc-LiveJournal1_clean.txt"
graph_name = "graph_live_journal"

EdgeInputDirectory = "/"
spark = SparkSession.builder.getOrCreate()

print(str(datetime.datetime.now()-start)+":reading input file")
DF = spark.read.csv(EdgeInputDirectory + input_file, inferSchema =True, sep=",", header=False)
print(DF.dtypes)
print(DF.count())
DF.show()

#print(str(datetime.datetime.now()-start)+":creating vertices DF")
#DF_vertices = DF.select("_c0").union(DF.select("_c1")).distinct().withColumnRenamed("_c0","_id").withColumn("~label", lit("account"))
#DF_vertices.show()
#print(DF_vertices.count())

g = SparkContext._jvm.com.datastax.bdp.graph.spark.graphframe.DseGraphFrameBuilder.dseGraph(graph_name, spark._jsparkSession)

#print(str(datetime.datetime.now()-start)+":reading vertices from the graph") #not useful (check)
#vertices = spark.read.format("com.datastax.bdp.graph.spark.sql.vertex").option("graph", graph_name ).load()
#vertices.show()
#print(vertices.count())

#print(str(datetime.datetime.now()-start)+":updating vertices...")
#DF_vertices.write.format("com.datastax.bdp.graph.spark.sql.vertex").option("graph", graph_name).save(mode="append")

#print(str(datetime.datetime.now()-start)+":reading vertices from the graph") #not useful (check)
#vertices = spark.read.format("com.datastax.bdp.graph.spark.sql.vertex").option("graph", graph_name ).load()
#vertices.show()
#print(vertices.count())

print(datetime.datetime.now()-start)

print(str(datetime.datetime.now()-start)+":edges:")
DF_edges = DF.select("_c0","_c1").withColumnRenamed("_c0","out_id").withColumnRenamed("_c1","in_id")
DF_edges.show()
print(DF_edges.dtypes)

#print(str(datetime.datetime.now()-start)+":reading edges from the graph...") #not useful (check)
#edges = spark.read.format("com.datastax.bdp.graph.spark.sql.edge").option("graph", graph_name ).load()
#edges.show()
#print(edges.count())
#print(edges.dtypes)

print(str(datetime.datetime.now()-start)+":writing edges to the graph") 
g.updateEdges("account","is_linked_to", "account", DF_edges._jdf)

#print(str(datetime.datetime.now()-start)+":reading edges from the graph") #not useful (check)
#edges = spark.read.format("com.datastax.bdp.graph.spark.sql.edge").option("graph", graph_name ).load()
#edges.show()
#print(edges.count())

print(str(datetime.datetime.now()-start)+":end")

#parking lot
#df = spark.read.format('json').load('python/test_support/sql/people.json')


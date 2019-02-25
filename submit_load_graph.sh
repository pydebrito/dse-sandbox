#dse spark-submit --conf spark.executor.memory=2g --conf spark.cassandra.output.concurrent.writes=1 load_graph.py
dse spark-submit --conf spark.executor.memory=2g --conf spark.cassandra.output.concurrent.writes=1 load_graph_cleaner.py

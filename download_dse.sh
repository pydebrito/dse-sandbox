#!/bin/bash

#set -e

cd "$(dirname "$0")"

echo $(pwd)

SCRIPT_PATH=$(pwd)


VERSION="6.8.0.20190726-LABS"
VERSION="6.7.5"
VERSION="5.1.17"
USER="pierre-yves.debrito_152942"
PWD="pycurlkey"

echo "curl --user $USER:$PWD -L https://downloads.datastax.com/enterprise/dse-$VERSION-bin.tar.gz | tar xz"
curl --user $USER:$PWD -L https://downloads.datastax.com/enterprise/dse-$VERSION-bin.tar.gz | tar xz

echo dse-$VERSION

mkdir -p dse-$VERSION/data/commitlog  dse-$VERSION/data/data  dse-$VERSION/data/hints  dse-$VERSION/data/saved_caches dse-$VERSION/spark/worker dse-$VERSION/spark/rdd  dse-$VERSION/log/spark/worker dse-$VERSION/log/spark/master dse-$VERSION/log/cassandra dse-$VERSION/data/dsefs dse-$VERSION/data/dsefs/data dse-$VERSION/resources/spark_rdd dse-$VERSION/data/metadata
sed -i '/data_file_directories:/s/^/#/' dse-$VERSION/resources/cassandra/conf/cassandra.yaml
sed -i '/     - \/var\/lib\/cassandra\/data/s/^/#/' dse-$VERSION/resources/cassandra/conf/cassandra.yaml
sed -i '/commitlog_directory:/s/^/#/' dse-$VERSION/resources/cassandra/conf/cassandra.yaml
sed -i '/saved_caches_directory:/s/^/#/' dse-$VERSION/resources/cassandra/conf/cassandra.yaml
sed -i '/hints_directory:/s/^/#/' dse-$VERSION/resources/cassandra/conf/cassandra.yaml
sed -i '/metadata_directory:/s/^/#/' dse-$VERSION/resources/cassandra/conf/cassandra.yaml
sed -i 's/endpoint_snitch: com.datastax.bdp.snitch.DseSimpleSnitch/endpoint_snitch: SimpleSnitch/g' dse-$VERSION/resources/cassandra/conf/cassandra.yaml
sed -i '/cdc_raw_directory:/s/^/#/' dse-$VERSION/resources/cassandra/conf/cassandra.yaml


sed -i "s/# dsefs_options:/dsefs_options:/g" dse-$VERSION/resources/dse/conf/dse.yaml
sed -i "s|#     work_dir: /var/lib/dsefs|      work_dir: $SCRIPT_PATH/dse-$VERSION/data/dsefs|g" dse-$VERSION/resources/dse/conf/dse.yaml
sed -i "s|#         - dir: /var/lib/dsefs/data|         - dir: $SCRIPT_PATH/dse-$VERSION/data/dsefs/data|g" dse-$VERSION/resources/dse/conf/dse.yaml
sed -i "s/#     data_directories:/      data_directories:/g" dse-$VERSION/resources/dse/conf/dse.yaml

sed -i "s/#-Xms4G/-Xms4G/g" dse-$VERSION/resources/cassandra/conf/jvm.options
sed -i "s/#-Xmx4G/-Xmx4G/g" dse-$VERSION/resources/cassandra/conf/jvm.options


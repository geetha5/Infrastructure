#!/bin/bash

aws kafka create-cluster --cluster-name "mg-kafka-dit-dev"  \
    --broker-node-group-info file://mg-kafka-dit.dev.json \
    --kafka-version "1.1.1" \
    --number-of-broker-nodes 3 \
    --enhanced-monitoring PER_TOPIC_PER_BROKER

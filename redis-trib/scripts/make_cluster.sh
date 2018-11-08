#! /bin/bash

PORT=6379
REPLICAS=1
ETCD_ENDPOINT="http://<ETCD_ENDPOINT>"
CURL=$(which curl)
NODES=()
NAMESPACE="redis-cluster"
ROLES=("master" "slave")
ARG=""

get_cluster_nodes() {
	local ROLE=$1
	echo "[ETCD] Getting redis cluster nodes from namespace key => "$NAMESPACE"/"$ROLE""
	result=$("$CURL" -s -L "$ETCD_ENDPOINT"/v2/keys/"$NAMESPACE"/"$ROLE" | jq '.node | .nodes[] | .key')
	for key in $result; do
		key=$(echo "$key" |  sed 's/^"\(.*\)"$/\1/')
		#echo "[DEBUG] Sending $CURL -s -L $ETCD_ENDPOINT/v2/keys$key"
		IP=$("$CURL" -s -L "$ETCD_ENDPOINT"/v2/keys"$key" | jq '.node | .nodes[] | .value')
		echo "[ETCD Analyze] => Got node IP: $IP"
		NODES+=("$IP")
	done
}


bootstrap() {

	for role in "${ROLES[@]}"; do
		get_cluster_nodes "$role"
	done

	for node in "${NODES[@]}"; do
		NODE=$(echo "$node" | sed 's/^"\(.*\)"$/\1/')
		ARG=$ARG" $NODE:$PORT";
	done

	echo "[TRIB] => Bootstrapping cluster using these args: $ARG"

	#redis-trib create --replicas "$REPLICAS" "$ARG"
}

bootstrap

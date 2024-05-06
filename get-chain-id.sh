get_chain_id() {
    JQ_FILTER='.[] | select( .id == "'"$1"'" ) | .chain_identifier'
    echo $JQ_FILTER
    curl https://api.coingecko.com/api/v3/asset_platforms | jq "$JQ_FILTER"
}

get_chain_id $1
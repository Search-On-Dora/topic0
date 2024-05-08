for chain in $(cat DORA_CHAIN_LIST);													      
do																	      
    echo "==== PULLING RESULTS FOR $chain ===="												      
    aws s3 sync --request-payer requester "s3://sourcify-backup-s3/stable/repository/contracts/full_match/$chain" "../sourcify-backup/latest/stable/repository/contracts/full_match/$chain" &
done																	      

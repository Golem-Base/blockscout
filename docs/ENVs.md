# Golem Base Environment Variables Reference

Configure Golem Base integration using these environment variables:

`GOLEMBASE_ENABLED`  
**Type:** Boolean  
**Default:** `false`
**Description:** Enables or disables Golem Base support in the Blockscout instance.

`GOLEMBASE_STORAGE_LIMIT`  
**Type:** Integer (bytes)  
**Default:** `1099511627776` (1 TB)  
**Description:** Sets the maximum storage limit for DB-Chain. Value must be specified in bytes.

`GOLEMBASE_CACHE_TTL_USED_SLOTS`  
**Type:** Duration string  
**Default:** `5m`  
**Description:** Time-to-live for the Used Slots cache. Controls how long slot usage data remains cached before refresh.

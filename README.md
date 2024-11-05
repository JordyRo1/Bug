## Issue ? 

Considering two contracts, Contract1 and Contract2. 
Contract1 implement classical view/write function to write/read in the storage. 
Contract2 implement ONLY view functions to write/read in Contract1 storage. The view functions implemented in Contract2 call write/read functions in Contract1 to read/write in the storage.
The issue is that **view** functions from Contract2 should not be able to call **write** functions from Contract1.
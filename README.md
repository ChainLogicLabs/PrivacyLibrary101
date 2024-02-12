# Privacy Storage Library

The `PrivacyStorageLibrary101` is a Solidity library crafted to manage and secure privacy-sensitive data while incorporating a simplified Merkle tree structure to ensure data integrity verification within smart contracts on the Ethereum blockchain.

## Overview

At its core, this library is designed to handle the secure storage and retrieval of data associated with specific salts, ensuring both privacy and data integrity through the utilization of a Merkle tree root hash.

## Contract Structure

### `PrivacyStorage` Struct

- `root`: The root hash of a Merkle tree used to maintain the integrity of the stored data.
- `userDataBySalt`: A mapping structure storing data strings associated with individual users and their respective salts.
- `hashedDataBySalt`: A mapping structure storing data hashes associated with users and their salts.

### Functions

- `storeDataWithSalt`: Stores both the hashed and original data, utilizing a custom salt.
- `computeRoot`: Computes the Merkle tree root hash based on the stored data.
- `retrieveOriginalDataWithSalt`: Retrieves the original data associated with a user's address and salt.
- `retrieveHashedDataWithSalt`: Retrieves the hashed data associated with a user's address and salt.

## Usage

1. **Storing Data**
   - Use `storeDataWithSalt` to securely store both the hashed and original data alongside a specified salt.
   - This function computes the hash of the original data and salt, updates the data mappings, and recalculates the Merkle tree root hash for data integrity.

2. **Retrieving Data**
   - `retrieveOriginalDataWithSalt` allows retrieval of the original data associated with a user's address and salt.
   - `retrieveHashedDataWithSalt` facilitates the retrieval of the hashed data linked to a user's address and salt.

3. **Merkle Tree Root**
   - The library recalculates the Merkle tree root hash every time new data is stored, ensuring the integrity and security of the stored data.
   - The calculated root hash is emitted in the `DataStored` event, fostering transparency and traceability.

## Considerations

- **Access Control & Validation**: Ensure robust access control mechanisms and stringent data validation to prevent unauthorized access or data corruption.
- **Gas Costs**: Be mindful of gas consumption, especially for larger datasets or frequent data updates.
- **Simplified Merkle Tree**: This example demonstrates a simplified Merkle tree with a single leaf node for educational purposes.

## License

This code is licensed under the [GPL-3.0](https://opensource.org/licenses/GPL-3.0).
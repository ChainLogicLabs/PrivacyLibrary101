// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.5.8;

library PrivacyStorageLibrary101 {
    // Struct to hold privacy-related data
    struct PrivacyStorage {
        bytes32 root; // Merkle tree root to maintain data integrity
        mapping(address => mapping(bytes32 => string)) userDataBySalt; // Map to store data strings associated with each user and salt
        mapping(address => mapping(bytes32 => bytes32)) hashedDataBySalt; // Map to store data hashes associated with each user and salt
    }

    event DataStored(address indexed user, bytes32 indexed salt, string originalData, bytes32 hashedData, bytes32 newRoot); // Event when data is stored

    /**
     * @dev Function to store hashed and original data in the privacy storage with a custom salt.
     * @param self The PrivacyStorage state.
     * @param _originalData The original data to be stored (as a string).
     * @param _salt The custom salt provided by the user.
     */
    function storeDataWithSalt(PrivacyStorage storage self, string memory _originalData, bytes32 _salt) public {
        require(bytes(_originalData).length > 0, "Data must not be empty");

        // Calculate hash of the original data combined with the salt
        bytes32 hashedData = keccak256(abi.encodePacked(_originalData, _salt));

        // Store original data and hashed data
        self.userDataBySalt[msg.sender][_salt] = _originalData;
        self.hashedDataBySalt[msg.sender][_salt] = hashedData;

        // Update Merkle tree root with the new hashed data
        bytes32[] memory proof = new bytes32[](1); // For simplicity, just using a single leaf node as an example
        proof[0] = hashedData; // Set leaf node as the hashed data
        self.root = computeRoot(proof); // Recalculate Merkle root with the new leaf node

        // Emit event for data storage
        emit DataStored(msg.sender, _salt, _originalData, hashedData, self.root);
    }

    /**
     * @dev Function to calculate the Merkle tree root hash.
     * @param _proof An array containing the leaf node(s).
     * @return The Merkle root hash.
     */
    function computeRoot(bytes32[] memory _proof) internal pure returns (bytes32) {
        uint256 len = _proof.length;
        require(len > 0, "No data to compute root");

        bytes32 node = _proof[0];
        for (uint256 i = 1; i < len; i++) {
            node = keccak256(abi.encodePacked(node, _proof[i]));
        }
        return node;
    }

    /**
     * @dev Function to retrieve original data associated with a user's address and salt.
     * @param self The PrivacyStorage state.
     * @param _userAddress The user's address.
     * @param _salt The custom salt associated with the data.
     * @return Original data associated with the user's address and salt.
     */
    function retrieveOriginalDataWithSalt(PrivacyStorage storage self, address _userAddress, bytes32 _salt) public view returns (string memory) {
        return self.userDataBySalt[_userAddress][_salt];
    }

    /**
     * @dev Function to retrieve hashed data associated with a user's address and salt.
     * @param self The PrivacyStorage state.
     * @param _userAddress The user's address.
     * @param _salt The custom salt associated with the data.
     * @return Hashed data associated with the user's address and salt.
     */
    function retrieveHashedDataWithSalt(PrivacyStorage storage self, address _userAddress, bytes32 _salt) public view returns (bytes32) {
        return self.hashedDataBySalt[_userAddress][_salt];
    }
}
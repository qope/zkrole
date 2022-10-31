pragma circom 2.0.0;

include "../node_modules/circomlib/circuits/poseidon.circom";
include "./tree.circom";
include "./partial.circom";

template CalculateSecretIdentity() {
    signal input identityTrapdoor;

    signal output out;

    component poseidon = Poseidon(1);

    poseidon.inputs[0] <== identityTrapdoor;

    out <== poseidon.out;
}


template CalculateRoleCommitment() {
    signal input role;
    signal input secretIdentity;

    signal output out;

    component poseidon = Poseidon(2);

    poseidon.inputs[0] <== role;
    poseidon.inputs[1] <==  secretIdentity;

    out <== poseidon.out;
}


// nLevels must be < 32.
template Zkrole(nLevels, N) {
    signal input identityTrapdoor;
    signal input role;
    signal input treePathIndices[nLevels];
    signal input treeSiblings[nLevels];

    signal input isInclusion;
    signal[] input candidates;

    signal input signalHash;

    signal output root;

    component calculateSecretIdentity = CalculateSecretIdentity();
    calculateSecretIdentity.identityTrapdoor <== identityTrapdoor;

    signal secretIdentity;
    secretIdentity <== calculateSecretIdentity.out;

    component calculateRoleCommitment = CalculateRoleCommitment();
    calculateRoleCommitment.role <== role;
    calculateRoleCommitment.secretIdentity <== secretIdentity;


    component inclusionProof = MerkleTreeInclusionProof(nLevels);
    inclusionProof.leaf <== calculateRoleCommitment.out;

    for (var i = 0; i < nLevels; i++) {
        inclusionProof.siblings[i] <== treeSiblings[i];
        inclusionProof.pathIndices[i] <== treePathIndices[i];
    }

    root <== inclusionProof.root;

    // Dummy square to prevent tampering signalHash.
    signal signalHashSquared;
    signalHashSquared <== signalHash * signalHash;

    isInclusion*(1-isInclusion) == 0;
    // Todo
}

component main {public [signalHash, externalNullifier]} = Semaphore(20);

pragma circom 2.0.0;
include "../node_modules/circomlib/circuits/comparators.circom";

template OneOf(N) {
    signal input in[N];
    signal input candidate;
    var totalMatch = 0;

    component ise[N];

    for (var i=0;i<N;i++) {
        ise[i] = IsEqual();
        ise[i].in[0] <== candidate;
        ise[i].in[1] <== in[i];
        totalMatch += ise[i].out;
    }
    totalMatch === 1;
}

template NotIn(N) {
    signal input in[N];
    signal input candidate;
    var totalMatch = 0;

    component ise[N];

    for (var i=0;i<N;i++) {
        ise[i] = IsEqual();
        ise[i].in[0] <== candidate;
        ise[i].in[1] <== in[i];
        totalMatch += ise[i].out;
    }
    totalMatch === 0;
}

component main = OneOf(5);
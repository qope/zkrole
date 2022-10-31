pragma circom 2.0.0;
include "../node_modules/circomlib/circuits/comparators.circom";

template OneOf(N) {
    signal input candidates[N];
    signal input role;
    signal output out;

    var totalMatch = 0;

    component ise[N];
    component isz = IsZero();

    for (var i=0;i<N;i++) {
        ise[i] = IsEqual();
        ise[i].in[0] <== role;
        ise[i].in[1] <== candidates[i];
        totalMatch += ise[i].out;
    }
    isz.in <== 1 - totalMatch;
    isz.out ==> out;
}

template NotIn(N) {
    signal input candidates[N];
    signal input role;
    signal output out;

    var totalMatch = 0;

    component ise[N];
    component isz = IsZero();

    for (var i=0;i<N;i++) {
        ise[i] = IsEqual();
        ise[i].in[0] <== role;
        ise[i].in[1] <== candidates[i];
        totalMatch += ise[i].out;
    }
    isz.in <== totalMatch;
    isz.out ==> out;
}

// component main = OneOf(5);
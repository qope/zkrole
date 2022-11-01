import {Group} from "@semaphore-protocol/group";
import { BigNumber } from "@ethersproject/bignumber";
import { poseidon } from "circomlibjs";
import { genRandomNumber, isJsonArray, sha256 } from "./utils";

async function main() {
    const group = new Group();
    const role = BigInt(1);
    const alice = new Identity(role);
    group.addMember(alice.generateCommitment());
    
}

export default class Identity {
    private _trapdoor: bigint
    private _role: bigint

    constructor(role:bigint) {
        this._trapdoor = genRandomNumber();
        this._role = role;
    }

    public getTrapdoor(): bigint {
        return this._trapdoor;
    }

    public getRole(): bigint {
        return this._role;
    }

    public generateCommitment(): bigint {
        return poseidon([poseidon([this._trapdoor, BigInt(1)]), this._role])
    }
}

main();
#[starknet::interface]
pub trait IContract1<TContractState> {
    fn set_value(ref self: TContractState, value: u256); 

    fn get_value(self: @TContractState) -> u256;
}

#[starknet::contract]
mod Contract1 {
    use super::IContract1;
    use starknet::storage::{
        StoragePointerReadAccess, StoragePointerWriteAccess,
    };
    #[storage]
    struct Storage {
        value: u256
    }

    #[abi(embed_v0)]
    impl IContract1Impl of IContract1<ContractState> {
        fn set_value(ref self: ContractState, value: u256) {
            self.value.write(value); 
        }

        fn get_value(self: @ContractState) -> u256 {
            self.value.read()
        }
    }
}
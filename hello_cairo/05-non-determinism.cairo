%builtins output range_check

from starkware.cairo.common.math import assert_nn_le
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.serialize import serialize_word
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.squash_dict import squash_dict
from starkware.cairo.common.alloc import alloc

struct KeyValue:
    member key: felt
    member value: felt
end

# Returns the value associated with the given key
func get_value_by_key{range_check_ptr}(list: KeyValue*, size, key) -> (value):
    alloc_locals

    local idx

    %{
        # Populate idx using a hint
        ENTRY_SIZE = ids.KeyValue.SIZE
        KEY_OFFSET = ids.KeyValue.key
        VALUE_OFFSET = ids.KeyValue.value

        for i in range(ids.size):
            addr = ids.list.address_ + ENTRY_SIZE * i + KEY_OFFSET
            if memory[addr] == ids.key:
                ids.idx = i
                break
        else:
            raise Exception(f'Key {ids.key} was not found in the list.')
    %}

    # Verify that we have the correct key
    let item: KeyValue = list[idx]
    assert item.key = key

    # Verify that the index is in range (0 <= idx <= size - 1)
    assert_nn_le(a=idx, b=size - 1)

    # Return the corresponding value
    return (value=item.value)
end

#
# Exercise
#

# Builds a DictAccess list for the computation of the cumulative
# sum for each key
func build_dict(list: KeyValue*, size, dict: DictAccess*) -> (dict: DictAccess*):
    if size == 0:
        return (dict=dict)
    end

    %{
        if ids.list.key not in cumulative_sums:
            cumulative_sums[ids.list.key] = 0

        ids.dict.prev_value = cumulative_sums[ids.list.key]
        cumulative_sums[ids.list.key] += ids.list.value
    %}

    assert dict.key = list.key
    assert dict.new_value = dict.prev_value + list.value

    return build_dict(
        list=list + KeyValue.SIZE,
        size=size - 1,
        dict=dict + DictAccess.SIZE
    )
end

# Verifies that the initial values were 0, and writes the final
# values to result
func verify_and_output_squashed_dict{output_ptr: felt*}(
    squashed_dict: DictAccess*,
    squashed_dict_end: DictAccess*, result: KeyValue*) -> (result: KeyValue*):
    tempvar diff = squashed_dict_end - squashed_dict
    if diff == 0:
        return (result=result)
    end

    assert squashed_dict.prev_value = 0
    assert result.key = squashed_dict.key
    assert result.value = squashed_dict.new_value

    return verify_and_output_squashed_dict(
        squashed_dict=squashed_dict + DictAccess.SIZE,
        squashed_dict_end=squashed_dict_end,
        result=result + KeyValue.SIZE
    )
end

# Given a list of KeyValue, sums the values, grouped by key,
# and returns a list of pairs (key, sum_of_values).
func sum_by_key{output_ptr: felt*, range_check_ptr}(list: KeyValue*, size) -> (result: KeyValue*, result_size):
    alloc_locals

    %{
        # Initialize cumulative_sums with an empty dictionary
        # This variable will be used by ``build_dict`` to hold
        # the current sum for each key
        cumulative_sums = {}
    %}

    let (local dict_start: DictAccess*) = alloc()
    let (local squashed_dict: DictAccess*) = alloc()
    let (local res_start: KeyValue*) = alloc()

    let (dict_end) = build_dict(list=list, size=size, dict=dict_start)
    let (squashed_dict_end) = squash_dict(
        dict_accesses=dict_start,
        dict_accesses_end=dict_end,
        squashed_dict=squashed_dict
    )

    let (res_end) = verify_and_output_squashed_dict(
        squashed_dict=squashed_dict,
        squashed_dict_end=squashed_dict_end,
        result=res_start
    )

    tempvar result_size = (res_end - res_start) / KeyValue.SIZE
    return (result=res_start, result_size=result_size)
end

func main{output_ptr: felt*, range_check_ptr}():
    alloc_locals

    # get_value_by_key
    local list: (KeyValue, KeyValue, KeyValue, KeyValue) = (
        KeyValue(key=1, value=2),
        KeyValue(key=2, value=3),
        KeyValue(key=3, value=4),
        KeyValue(key=4, value=5)
    )

    let (__fp__, _) = get_fp_and_pc()
    let (value) = get_value_by_key(list=cast(&list, KeyValue*), size=4, key=3)
    assert value = 4

    # sum_by_key
    local list2: (KeyValue, KeyValue, KeyValue, KeyValue, KeyValue) = (
        KeyValue(key=3, value=5),
        KeyValue(key=1, value=10),
        KeyValue(key=3, value=1),
        KeyValue(key=3, value=8),
        KeyValue(key=1, value=20)
    )

    let (__fp__, _) = get_fp_and_pc()
    let (result, result_size) = sum_by_key(list=cast(&list2, KeyValue*), size=3)

    assert result_size = 2

    return ()
end

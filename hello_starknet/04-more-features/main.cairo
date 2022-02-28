%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin

#
# Storage variable with multiple values
#

@storage_var
func range(user : felt) -> (res : (felt, felt)):
end

@external
func extended_range{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(user : felt):
    let (min_max) = range.read(user)
    range.write(user, (min_max[0] - 1, min_max[1] + 1))
    return ()
end

#
# Storage variable with struct arguments
#

struct User:
    member first_name : felt
    member last_name : felt
end

# A mapping from a user to 1 if they voted and 0 otherwise
@storage_var
func user_voted(user : User) -> (res : felt):
end

@external
func vote{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(user : User):
    user_voted.write(user, 1)
    return ()
end

#
# Array arguments in calldata
#

@external
func compare_arrays(a_len : felt, a : felt*, b_len : felt, b : felt*):
    assert a_len = b_len
    if a_len == 0:
        return ()
    end
    assert a[0] = b[0]
    return compare_arrays(a_len=a_len - 1, a=a + 1, b_len=b_len - 1, b=b + 1)
end

#
# Passing tuples and structs in calldata
#

struct Point:
    member x : felt
    member y : felt
end

@view
func sum_points(points : (Point, Point)) -> (res : Point):
    return (res=Point(x=points[0].x + points[1].x, y=points[0].y + points[1].y))
end

#
# Passing arrays of structs
#
@external
func sum_points_arr(a_len : felt, a : Point*) -> (res : Point):
    if a_len == 0:
        return (Point(0, 0))
    end

    let (res) = sum_points_arr(a_len=a_len - 1, a=&a[1])
    return (res=Point(x=res.x + a[0].x, y=res.y + a[0].y))
end

#
# Retrieving the transaction information
#

from starkware.starknet.common.syscalls import get_tx_info

func get_tx_max_fee{syscall_ptr : felt*}() -> (max_fee : felt):
    let (tx_info) = get_tx_info()

    return (max_fee=tx_info.max_fee)
end

#
# Block number and timestamp
#
from starkware.starknet.common.syscalls import get_block_number, get_block_timestamp

func foo{syscall_ptr : felt*}():
    let (block_number) = get_block_number()
    let (block_timestamp) = get_block_timestamp()

    return ()
end

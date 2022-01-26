# https://www.cairo-lang.org/docs/hello_cairo/intro.html#using-array-sum
%builtins output

# Computes the sum of the memory elements at addresses:
#   arr + 0, arr + 1, ..., arr + (size - 1).
func array_sum(arr : felt*, size) -> (sum):
    if size == 0:
        return (sum=0)
    end

    # size is not zero.
    let (sum_of_rest) = array_sum(arr=arr + 1, size=size - 1)
    return (sum=[arr] + sum_of_rest)
end

#
# Exercise
#

# Write a function that computes the product of all the even entries of an
# array ([arr] * [arr + 2] * ...). You may assume that the length is even. (You
# may want to wait with running it until you read Using array_sum().)
func array_even_prod(arr: felt*, size) -> (even_prod):
    if size == 0:
        return (even_prod=1)
    end

    # size >= 2
    let (even_prod_of_rest) = array_even_prod(arr=arr + 2, size=size - 2)
    return (even_prod=[arr] * even_prod_of_rest)
end

#
# Writing a main function
#

from starkware.cairo.common.serialize import serialize_word
from starkware.cairo.common.alloc import alloc

func test_array_sum{output_ptr: felt*}():
    const ARRAY_SIZE = 3

    # allocate an array and populate it
    let (ptr) = alloc()
    assert [ptr] = 9
    assert [ptr + 1] = 16
    assert [ptr + 2] = 25

    # Call array_sum to compute the sum of the elements
    let (sum) = array_sum(arr=ptr, size=ARRAY_SIZE)
    serialize_word(sum)

    return ()
end

func test_array_even_prod{output_ptr: felt*}():
    const ARRAY_SIZE = 4

    # allocate an array and populate it
    let (ptr) = alloc()
    assert [ptr] = 9
    assert [ptr + 1] = 1
    assert [ptr + 2] = 3
    assert [ptr + 3] = 20

    # Call array_sum to compute the sum of the elements
    let (even_prod) = array_even_prod(arr=ptr, size=ARRAY_SIZE)
    serialize_word(even_prod)

    return ()
end

func main{output_ptr: felt*}():
    # serialize
    serialize_word(1234)
    serialize_word(4321)

    test_array_sum()
    test_array_even_prod()

    return ()
end

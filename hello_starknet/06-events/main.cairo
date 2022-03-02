%lang starket

@event
func increase_balance_called(current_balance : felt, amount : felt):
end

# Emit the event
increase_balance_called.emit(current_balance=res, amount=amount)

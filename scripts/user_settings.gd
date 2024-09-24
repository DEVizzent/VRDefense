extends Node
class_name UserSettingsScript

enum HandController { LEFT , RIGHT}	

var main_hand := HandController.RIGHT
var off_hand := HandController.LEFT 

func get_main_hand() -> String:
	return hand_to_controller_name(main_hand)
	
func is_righ_main_hand() -> bool:
	return main_hand == HandController.RIGHT

func get_off_hand() -> String:
	return hand_to_controller_name(off_hand)

func hand_to_controller_name(hand: HandController) -> String:
	match hand:
		HandController.LEFT:
			return "LeftHand"
		HandController.RIGHT:
			return "RightHand"
		_:
			push_error("Invalid hand controller")
			return "RightHand"

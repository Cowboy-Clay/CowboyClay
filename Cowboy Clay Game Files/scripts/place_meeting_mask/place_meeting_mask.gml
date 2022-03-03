function place_meeting_mask(xPos,yPos,mask){
	for(i = 0; i < array_length(mask); i++)
	{
		if place_meeting(xPos, yPos, mask[i]) return true;
	}
	return false;
}
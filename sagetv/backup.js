function GetChannels() {
	var Channels = [];
	for (i = 0; i < ChannelAPI.GetAllChannels().length; i++) {
		var Channel = [];
		DiscoveredChannel = ChannelAPI.GetAllChannels()[i];
		Channel["StationID"] = DiscoveredChannel.getStationID();
		Channel["Number"] = DiscoveredChannel.getNumber();
		Channel["Name"] = DiscoveredChannel.getFullName();
		Channel["Physical"] = ChannelAPI.GetPhysicalChannelNumberForLineup(DiscoveredChannel, Global.GetAllLineups()[0]);
		Channel["Viewable"] = DiscoveredChannel.isViewable();
		Channel["Description"] = ChannelAPI.GetChannelDescription(DiscoveredChannel);
		Channels.push(Channel);
	}
	return Channels;
}

function RestoreChannels(CallSign, Description, Network, StationID, LogicalNumber, PhysicalNumber) {
	ChannelObject = ChannelAPI.AddChannel(CallSign, Description, Network, StationID);
	ChannelAPI.SetChannelMappingForLineup(ChannelObject, Global.GetAllLineups()[0], LogicalNumber);
	ChannelAPI.SetPhysicalChannelMappingForLineup(ChannelObject, Global.GetAllLineups()[0], PhysicalNumber);
	return LogicalChannelResponse;
}

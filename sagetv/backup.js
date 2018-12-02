function GetChannels() {
	var Channel = [];
	var Channels = [];
		for (i = 0; i < ChannelAPI.GetAllChannels().length; i++) {
			DiscoveredChannel = ChannelAPI.GetAllChannels()[i];
			var Channel = [];
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

function ClearChannels() {
	for (i = 0; i < ChannelAPI.GetAllChannels().length; i++) {
		DiscoveredChannel = ChannelAPI.GetAllChannels()[i];
		ChannelAPI.SetChannelViewabilityForChannelNumberOnLineup(DiscoveredChannel,DiscoveredChannel.getNumber(),Global.GetAllLineups()[0],false);
	}
	return i;
}

function RestoreChannels(CallSign, Description, Network, StationID, LogicalNumber, PhysicalNumber) {
	ChannelObject = ChannelAPI.AddChannel(CallSign, Description, Network, StationID);
	ChannelAPI.SetChannelMappingForLineup(ChannelObject, Global.GetAllLineups()[0], LogicalNumber);
	ChannelAPI.SetPhysicalChannelMappingForLineup(ChannelObject, Global.GetAllLineups()[0], PhysicalNumber);
	ChannelAPI.SetChannelViewabilityForChannelNumberOnLineup(ChannelObject,ChannelObject.getNumber(),Global.GetAllLineups()[0],true);
	return LogicalChannelResponse;
}

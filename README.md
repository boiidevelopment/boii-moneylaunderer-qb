# BOII | DEVELOPMENT - UTILITY: MONEY LAUNDERER

Here we have a simple money laundering script for your city.
You can choose to wash markedbills or any item, and receive payment in either money or an item reward.
Comes with a blacklisted job list to disable legal jobs from accessing.
Any service jobs added to the service job list will force the ped to move location when in range.
Enjoy! :) 

### INSTALL ###

1) Drag and drop `boii-moneylaunderer` into your server resources
2) Add `ensure boii-moneylaunderer` to your `server.cfg`
3) Customise `shared/config.lua` & `shared/language.lua` to fit your requirements
4) Add item information under **SHARED/ITEMS.LUA** into your `qb-core/shared/items.lua` if using items provided
5) Add images provided inside `images` into your `qb-core/inventory/html/images` if using items provided
6) Restart your server

### USAGE ### 

- Third eye ped to start washing money
- Disable blip in config if you do not want anyone to see locations
- Blacklisted jobs cannot access or see locations
- Service jobs cannot access or see locations and will also force ped to run away when within range
- Cancelling progressbar will return whatever was handed over

### SHARED/ITEMS.LUA ###
```
	--<!>-- MONEY --<!>--
	['cash'] 						= {['name'] = 'cash', 			 	  	  		['label'] = 'Cash', 					['weight'] = 1, 		['type'] = 'item', 		['image'] = 'cash.png', 				['unique'] = false, 	['useable'] = true, 	['shouldClose'] = false,   ['combinable'] = nil,   ['description'] = 'Cash to be used within the BOII Community city!'},
	['dirtycash'] 					= {['name'] = 'dirtycash', 			 	  	  	['label'] = 'Dirty Cash', 				['weight'] = 1, 		['type'] = 'item', 		['image'] = 'dirtycash.png', 			['unique'] = false, 	['useable'] = true, 	['shouldClose'] = false,   ['combinable'] = nil,   ['description'] = 'Dirty cash? You should find someone to clean this for you!'},
```

### PREVIEW ###
[YOUTUBE](https://www.youtube.com/watch?v=RZhfpvJ-Krw)

### SUPPORT ###
[DISCORD](https://discord.gg/MUckUyS5Kq)

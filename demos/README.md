# Running the Coronium GS Demos #

## Coronium GS (server-side) ##

### Update the Coronium GS modules  ###

Be sure to update your Coronium modules folder by [downloading the latest source](https://bitbucket.org/develephant/coronium-gs-server/get/default.zip) and overwriting the __modules__ folder to the server.

Upload the __main.lua__ for the example you want to run into the root directory of your server instance.

## Coronium GS (client-side) ##

### Update the client folder ###

In the source [bundle download](https://bitbucket.org/develephant/coronium-gs-bundle/get/default.zip), overwrite your __gs__ folder using the client of your choice in the Clients directory.

Open and compile the client example __main.lua__ to run in the client of your choice.

## Tips ##

Make sure to update the examples connection information in the the client side __main.lua__ to point at your server instance.

You must restart the __Coronium GS__ engine each time you upload new files to the server.  To restart from the command line, use:

    sudo service gs restart

# Inject custom pictures in your Game Boy Camera saves

The idea comes (once again) from the Game Boy Camera Club discord - https://disboard.org/nl/server/568464159050694666.

After a discussion about the vintage Game Boy Camera advertisements (like the Funtograpy guide for example) that present screen artworks that were clearly not made with D-pad only, comes the idea that a tool perhaps existed as presskit to make custom saves with pictures not coming from the camera.

So, despite the fact that extracting images from Game Boy Camera saves was made possible by fans since many years, it was virtually impossible to do the inverse : inject custom pictures into saves. At least until now. What could be the interest, dear reader ? It can be usefull to mess with pixel perfect artworks, reuse an image that was erased long ago from camera ago but still stored somewhere on a computer or internet, steal pictures from other people and claim they are yours or simply exchange pictures with friends if you have no friends. Be creative ! 

The two small codes presented here are intended to be easy to use. Here are the steps :
- Extract your save from Game Boy Camera with any tool like this: https://shop.insidegadgets.com/product/gbxcart-rw/
- Scan you save with the provided tool (slot_viewer.m) to identify memory slots available for injection ;
- prepare a 128x112 image and a 32x32 pixels thumbnail, 4 shades of gray ;  
- Inject the two pictures at once with the provided tool (image_injector.m) into any desired available memory slot ;
- Play with your old-new image.

The scanning code basically extracts and analyses values at addresses 0x011D7 to 0x011F4 that contains the state of any image slot on the save. These data are also available from addresses 0x011B2 to 0x011CF. Any number between 0 and 29 represents the image number (minus one) that shows on the cameras screen, FF is an unused slot (erased of never used). The number assignated to an image on camera is not related to the slot number where the data come from : any deleted image will free a memory slot and all images will be renumbered dynamically (at constant memory slot position). Any free memory slot will be reused in ascending order of priority to write a new image. Next image illustrate the working of this state vector :

![Vector state](https://github.com/Raphael-Boichot/Inject-pictures-in-your-Game-Boy-Camera-saves/blob/main/Pictures/Vector%20state.png)

Anyway, there is a checksum system somewhere that precludes any possibility of un-erasing a picture by simply changing its value from FF to any number. Doing this simply messes-up all the filesystem and forces the camera to self-erase all memory slots. 

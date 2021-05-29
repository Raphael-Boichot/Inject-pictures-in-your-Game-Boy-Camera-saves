# Inject custom pictures in your Game Boy Camera saves

![Time for creativity](https://github.com/Raphael-Boichot/Inject-pictures-in-your-Game-Boy-Camera-saves/blob/main/Pictures/Piece%20of%20cake.jpg)

By Raphaël BOICHOT, May 2021, a Matlab/Octave project.

The idea comes (once again) from the Game Boy Camera Club discord - https://disboard.org/nl/server/568464159050694666.

After a discussion about the vintage Game Boy Camera advertisements (like the Funtograpy guide for example) that present screen artworks, clearly not made with D-pad only, comes the idea that a tool perhaps existed as presskit to make custom saves with pictures not coming from the camera.

So, despite the fact that extracting images from Game Boy Camera saves was made possible by fans since many years, it was virtually impossible to do the inverse : inject custom pictures into saves. At least until now. What could be the interest, dear reader ? It can be usefull to mess with pixel perfect artworks, to reuse an image that was erased long ago from camera but still stored somewhere on a computer or internet, to steal pictures from other people and claim they are yours or simply exchange pictures with friends even if you have no friends. Be creative ! 

The two small codes presented here are intended to be easy to use. Here are the steps :
- Extract your save from Game Boy Camera with any tool like this: https://shop.insidegadgets.com/product/gbxcart-rw/
- Scan you save with the provided tool (slot_viewer.m) to identify memory slots available for injection ;
- prepare a 128x112 image and a 32x32 pixels thumbnail, 4 shades of gray ;  
- Inject the two pictures at once with the provided tool (image_injector.m) into any desired available memory slot ;
- Burn you modified save into the Game Boy Camera ;
- Enjoy with your old-new image.

The scanning code basically extracts and analyses values at addresses 0x011D7 to 0x011F4 that contains the state and numbering of any image slot on the save. These data are also duplicated from addresses 0x011B2 to 0x011CF. Any number between 0x00 and 0x1D on this state vector represents the image number (minus one) that shows on the cameras screen, FF is an unused slot (erased of never used). The number assignated to an image on camera is in consequence not related to the slot number (or physical address). Deleting an image on camera will simply write FF on the vector state and all images will be renumbered dynamically, but image data stay on their respective slots as long as another image is not written on it. When a picture is taken, memory slots marked as unused on the vector state will be used by writing data in priority to the lowest address one. Next image illustrates the principle of this state vector :

![Vector state](https://github.com/Raphael-Boichot/Inject-pictures-in-your-Game-Boy-Camera-saves/blob/main/Pictures/Vector%20state.png)

Anyway, there is a checksum system somewhere that precludes any possibility of un-erasing a picture by simply reversing the order of operation on the vector state and/or modifying the last byte of its corresponding picture data area that is supposedly used as a state indicator. Doing this simply messes-up all the filesystem and forces the camera to self-erase all memory slots. Additionnaly, each picture slot contains lots of additionnal information poorly documented.

SO

By trial-and-error I've found that an active image (not empty, not erased) could be replaced bytewise without activating any checksum issue. In consequence, the injection code targets only slots corresponding to active images and just substitutes the data corresponding to the image tiles (address range : 0xXX000-0xXXDEF for the image, address range : 0xXXDF0-0xXXEFF for the thumbnail, XX ranging from 02 to 1F). Additionnal data (range 0xXXF00-0xXXFFF), are not modified. Apart from that, data are arranged in Game Boy tile format, tile after tile, in reading order, so nothing particular for you Nintendo nerds.

Funfact, the thumbnail is dynamically rewritten each time the image is saved into the Game Boy Camera, even if just one pixel is changed. So I just provide a generic image thumbnail that will soon diseappear. 

# Research

I loosely continue trying to understand how the data are arranged into the savestate (see research folder). To what I understand now : 
- user ID (birthdate, gender and name) is embedded into image informations section only, address range 0xXXFB0-0xXXFF0 ;
- score at Ball is stored at adress 0x01C09 (at least) and 0x011A2 and modifies what seems to be a checksum at bytes 0x010D7-0x10D8 and bytes 0x011B0-0x011B1. It also modifies many bytes in image information.
- score at Space Fever is stored at adress 0x010C5-0x010C6 (at least) and 0x0118E-0x0119F and modifies the same bytes as Ball in what seems to be a checksum shared with the vector state.

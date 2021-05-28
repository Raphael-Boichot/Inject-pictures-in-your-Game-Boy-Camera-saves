# Inject custom pictures in your Game Boy Camera saves

The idea comes (once again) from the Game Boy Camera Club discord - https://disboard.org/nl/server/568464159050694666.

After a discussion about the vintage Game Boy Camera advertisements (like the Funtograpy guide for example) that present screen artworks that were clearly not made with D-pad only, comes the idea that a tool perhaps existed as presskit to make custom saves with pictures not coming from the camera.

So, despite the fact that extracting images from Game Boy Camera saves was made possible by fans, it is still virtually impossible to do the inverse : inject custom pictures into saves. What could be the interest, dear reader ? Messing with pixel perfect artworks, reuse an image that was erased long from camera ago but stored somewhere on computer, steal pictures from other people and claim they are yours or simply exchange pictures with friends if you have no friends, for example.

The codes presented are are intended to be easy to use. Here are the steps :
- Extract your save from Game Boy Camera with any tool like this: https://shop.insidegadgets.com/product/gbxcart-rw/
- Scan you save with the provided tool to identify memory slots available for injection ;
- prepare a 128x112 image and a 32x32 pixels thumbnail, 4 shades of gray ;  
- Inject the two pictures with the provided tool into any desired available memory slot ;
- Play with your new image.

The scanning code basically extracts and analyses values at addresses 0x11D8 to 0x11F5 that contains the state of any image slot on the save. Any number between 0 and 29 represents the image number (minus one) that shows on the cameras screen, FF is an unused slot (erased of never used). The number assignated to an image on camera is not related to the slot number: any deleted image will free a memory slot and all upper images will get a decreasing number (at constant memory slot position). Any free memory slot will be reused in ascending order of priority to write a new image. In other words : the image number will match the slot number during the first fillup of memory, but after erasing and taking new pictures, the slot number and picture number will become completely unrelated. 

Anyway, there is a checksum system somewhere that precludes any possibility of un-erasing a picture by simply changing its value from FF to any number. Doing this simply messes-up all the filesystem and forces the camera to self-erase all memory slots. 

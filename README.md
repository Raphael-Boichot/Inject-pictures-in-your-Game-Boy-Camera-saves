# Pimp your Game Boy Camera saves : inject custom pictures and scores !

![Time for creativity](https://github.com/Raphael-Boichot/Inject-pictures-in-your-Game-Boy-Camera-saves/blob/main/Pictures/Piece%20of%20cake.png)

By Raphaël BOICHOT, May 2021, a Matlab/Octave project. Last update: 2021-08-02.

The idea comes (once again) from the Game Boy Camera Club discord - https://disboard.org/nl/server/568464159050694666.

Some informations also come from the InsideGdget Discord, https://github.com/lesserkuma/FlashGBX and https://github.com/HerrZatacke/gb-printer-web

Great contributions from Game Boy Camera club mate Cristofer Cruz : https://github.com/cristofercruz

All started as a joke, as usual. After a discussion about the vintage Game Boy Camera advertisements (like the Funtograpy guide for example) that present screen artworks, clearly not made with D-pad only, comes the idea that a tool perhaps existed as presskit to make custom saves with pictures not coming from the camera, and perhaps cheating at minigames. I did not know initially what hexadecimal nightmare was hidden behind this.

So, despite the fact that extracting images from Game Boy Camera saves was made possible by fans since many years, it was virtually impossible in 2021 to do the inverse : inject custom pictures into saves. At least until now. What could be the interest, dear reader ? It can be usefull to mess with pixel perfect artworks, to reuse an image that was erased long ago from camera but still stored somewhere on a computer or internet or simply exchange pictures with friends if you have no friends. Be creative ! 

The small Matlab/Octave codes presented here are intended to be easy to use. Here are the steps :
- Extract your save from Game Boy Camera with any great tool like this: https://shop.insidegadgets.com/product/gbxcart-rw/
- Scan your save with slot_viewer.m to identify memory slots available for injection. By default an available slot is one ever occupied by an image. This is the "safe mode" of operation, your save will be 100% sure after the injection. Game face and address 0 are also writable as slots 0 and -1 respectively (they are by default active) ;
- In option, activate all memory slots with slot_activator.m if you want to occupy any slot on camera. Blank slots will become white images, erased images will appear again, images will be numbered according to their address in memory. This is the "unsafe mode" of operation as I did not extensively search if any wicked effet would appear. It must however be OK ;
- Prepare a 128x112 image and a 32x32 pixels thumbnail, 4 shades of gray ;  
- Inject the two pictures at once with image_injector.m into any desired memory slot ;
- You can check again the success of image injection with slot_viewer.m ;
- Burn your modified save into the Game Boy Camera ;
- Enjoy your new image and play with stamps.
- You can additionnaly extract your images from save in .png format with image_extractor.m

The scanning code basically extracts and analyses values at addresses 0x011B2 to 0x011CF that contains the state and numbering of any image slot on the save (which I will call "state vector"). These data are also duplicated from addresses 0x011D7 to 0x011F4. Any number between 0x00 and 0x1D on this state vector represents the image number (minus one) that shows on the cameras screen, FF is an unused slot (erased of never used). The number assignated to an image on camera is in consequence not related to the slot number (or physical address). Deleting an image on camera will simply write 0xFF on the vector state at the good place and all images will be renumbered dynamically, but image data stay on their respective slots as long as another image is not written on it. When a picture is taken, memory slots marked as unused on the vector state will be used by writing data in priority to the lowest address one. Next image illustrates the principle of this state vector :

![Vector state](https://github.com/Raphael-Boichot/Inject-pictures-in-your-Game-Boy-Camera-saves/blob/main/Pictures/Vector%20state.png)

Until this step, everything was fine and easy, tricky enough to occupy my brain for an evening but not much. Here came some bad surprise.
There is a checksum system at addresses 0x011D5-0x011D6 and 0x011FA-0x011FB that precludes any possibility of un-erasing a single picture or activating a new memory slot by simply manipulating the state vector. Doing this simply forces the camera to replace any value on state vector by 0xFF (means you've fucked your precious images in case you just own original hardware in 1998).

This is why I wrote slot_activator.m, which activates all slots (an unerases all pictures). This was the only operation that I was initially able to perform, knowing the checksum of this particular state vector. For doing this, I simply stuff addresses 0x011B2 to 0x011CF with a fake "camera full" state vector (0x00, 0x01, 0x02 ...0x1C, 0x1D) and addresses 0x011D5-0x011D6 with the corresponding checksum (0xE2, 0x14). Et voilà ! This means that range 0x011D7 to 0x011F4 and addresses 0x011FA-0x011FB are just echos. Activating the 30 slots of a camera after a factory reset gives you 30 white images but no bug apparently... To use at your own risks.

Hopefully, I've found that an active image could be replaced bytewise without activating any suicide code. In consequence, the injection code just substitutes the data corresponding to the image tiles (address range : 0xXX000-0xXXDEF for the image, address range : 0xXXDF0-0xXXEFF for the thumbnail, XX ranging from 02 to 1F). Additionnal data (range 0xXXF00-0xXXFFF), are not modified. Apart from that, data are arranged in Game Boy tile format, tile after tile, in reading order, so nothing particular for you Nintendo nerds.

Funfact, the thumbnail is dynamically rewritten each time the image is saved into the Game Boy Camera, even if just one pixel is changed. So I just provide a generic image thumbnail that will soon disappear. Invigorated by my half-a-success, I took a look around the state vector in search for any minigame score to manipulate, following the word "Magic" into the save signing the presence of interesting stuff. This is where another form of pain happens.

# Checksums and pain : why there is no cheating codes until now for the Game Boy Camera

I loosely continue collecting data to understand how bytes are arranged into the savestate (see research folder). The principle reason is that it seems that there is not any single cheating codes on the whole planet Earth for this device (except the CoroCoro save hack), even more than 20 years after the camera was released, which is quite annoying when you know the requirement to unlock the full B album (Yes, accomplish 1000 points at Ball, 7000 points at Space Fever II and less that 16 seconds at Run! Run! Run! means you were at some point of your life stuck at home with two broken legs and only a Game Boy to entertain yourself, believe me). So my motivation to open an hexadecimal editor was rather strong. 

My general strategy was to compare different savesates with some accomplishments made (not all, I'm not mad nor stuck at home), byte per byte, to understand where were targeted addresses. I systematically compared with a blank savestate (all data erased). Everything was made on real hardware (Game Boy Camera and Pocket Camera in parallel). So here are my conclusions: 

- The Game Boy Camera save uses several internal checksums systematically echoed one time to protect its own data : one for scores (minigames and counter for images), one for controlling the vector state and prevent any erased or transfered image to be recovered by byte attack (as data still exist in memory slots), one for camera owner informations and one for picture owner informations (In case the picture was exchanged). This means that when you play with a Gameboy Camera, you play with the rules. That may explain the scarcity, even the total absence of cheat codes for the Camera. The beast is robust !

- Each checksum have two bytes corresponding to two different calculation rules (see next sections) and is preceded by the ascii word "Magic";

- Any discrepancy between data, scores, states and checksums causes the camera to erase all informations into the save at reboot (camera must consider the savestate as corrupted or modified by cheating). Everything is set to zero, end of story, reward for cheating. I think that the long booting time of the Game Boy Camera is precisely due to the amount of verifications made; 

- Data protected by checksums are systematically echoed. First occurence seems to have priority on its echo (modifying the first occurence with correct checksum is enough to modify safely the save file);

- I suppose that all of this (obfusctation + checksum with different rules) was implemented as some Game Genie or other cheating hardware counter measure as it is twisted as hell. Clearly a single byte attack will inevitably lead to the activation of a suicide code as at least three bytes must be modified to hack something (one byte of data + 2 bytes of checksum);

- On the contrary, the data corresponding to picture tiles stored in memory slots of camera are not protected by any way;

- Forcing the minigame scores in memory with the correct checksum is enough to unlock image B album, there is no other trick necessary;

- Good new, Pocket Camera and Game Boy Camera seems to have the exact same save structure. They are fully intercompatibles.

So I can now propose a general structure of the Game Boy Camera save format for the first time since Jeff Frohwein proposed one in the early 2000's.

# Game Boy Camera save ram format by increasing adresses

- **0x00000-0x00FFF: the last image seen by the sensor (128x128 pixels, 256 tiles). The last line of 16 tiles is glitchy. The camera copies 0x0100-0x0EFF to memory slots when save is activated. The effective resolution is in fact only 128x123 as indicated in the datasheet of the M64282FP sensor so the last 5 lines of pixels are blank.;**
- **0x01000-0x0102E: filling with 0xFE**
- **0x0102F-0x010D8: game save area, see details:**
    - *0x0102F-0x01060: unknown data (perhaps some from Trippy-H);*
    - *0x01061-0x010B2: Trippy-H partitions;*
    - *0x010B3-0x010BA: unknown data (perhaps some from Trippy-H);*
    - *0x010BB-0x010BC: counter for image taken (on 2x2 digits reversed);*
    - *0x010BD-0x010BE: counter for image erased (on 2x2 digits reversed);*
    - *0x010BF-0x010C0: counter for image transfered (on 2x2 digits reversed);*
    - *0x010C1-0x010C2: counter for image printed (on 2x2 digits reversed);*
    - *0x010C3-0x010C4: counter for pictures received by males an females (2x2 digits);*
    - *0x010C5-0x010C6: Score at Space Fever II (on 4x2 digits reversed);*
    - *0x010C9-0x010CA: score at balls (on 2x2 digits reversed);*
    - *0x010CB-0x010CC: score at Run! Run! Run! (on 2x2 digits reversed, 99 minus value on screen);*
    - *0x010CD-0x010D1: unknown data;*
    - *0x010D2-0x010D6: "Magic" word in ascii;*
    - *0x010D7-0x010D8: checksum (2 bytes, range of data included not sure);*
- **0x010D9-0x01107: filling with 0xFE;**
- **0x01108-0x011B1: game save area, echo of 0x0102F-0x010D8;**
- **0x011B2-0x011D6: vector state, see details:**
    - *0x11B2-0x011CF: image number associated to memory slots (minus one), 0xFF means erased or blank;*   
    - *0x11D0-0x011D4: "Magic" word in ascii;*
    - *0x11D5-0x011D6: checksum (2 bytes, range of data included not sure);*
- **0x011D7-0x011FB: vector state, echo of 0x011B2-0x011D6;**  
- **0x011FC-0x01FFB: Game Face (128x112) - This area is not erased by booting while pressing START+SELECT;**
- **0x01FFC-0x01FFF: Possible camera tag (0x00, 0x56, 0x56, 0x53 to unlock Corocoro features) - This area is not erased by booting while pressing START+SELECT;**
- **0x02000-0x02DFF: image data tiles in memory slot 1 (128x112, 224 tiles);**
- **0x02E00-0x02EFF: image thumbnail (32x32, 16 tiles, black borders and 4 white lines on the bottom to not hide the hand). Image exchanged displays a small distinctive badge;**
- **0x02F00-0x02FFF: image tag or metadata (contains informations on the owner of camera and image);**
- **0x02F00-0x02F5B : User ID, data, comments and some other information from image owner**;
    - *0x02F00-0x02F03: user ID, 4 bytes sequence (equal to 11 + series of two digits among 8 in reading order);*
    - *0x02F04-0x02F0C: username (0x56 = A to 0xC8 = @, same tileset as first character stamps);*
    - *0x02F0D: User gender (0x00 no gender, 0x01 male, 0x02 female) and blood type (japanese only, +0x04 A, +0x08 B, +0x0C O, +0x10 AB);*
    - *0x02F0E-0x02F11: Birthdate (year, 2x2 bytes, day, 2 bytes, month, 2 bytes, each 2 bytes + 11);*
    - *0x02F12-0x02F14: 3 unknown bytes;*
    - *0x02F15-0x02F2F: Contains comments (0x56 = A to 0xC8 = @, same tileset as first character stamps);*
    - *0x02F30-0x02F32: 0x00;*
	- *0x02F33: 0x00 if image is original, 0x01 if image is a copy;*
	- *0x02F34-0x02F35: Probably a checksum from image data. Erasing these bytes do nothing particular, but camera rewrites them automatically. Two identical image copies have the same value.;*
	- *0x02F36-0x02F53: 0x00.*
    - *0x02F54: border number associated to the image;*
    - *0x02F55-0x02F59: "Magic" word in ascii;*
    - *0x02F5A-0x02F5B: checksum (2 bytes, range of data included not sure);*
- **0x02F5C-0x02FB7: User ID, data, comments and some other information from image owner, echo;**
- **0x02FB8-0x02FD0: User ID and data from camera owner (below the first image only, slot 1, just replaced by 0xAA on other slots);**
    - *0x02FB8-0x02FBB: User ID;*
    - *0x02FBC-0x02FC4: Username (0x56 = A to 0xC8 = @, same tileset as first character stamps);*
    - *0x02FC5: User gender (0x00 no gender, 0x01 male, 0x02 female) and blood type (japanese only, +0x04 A, +0x08 B, +0x0C O, +0x10 AB);*
    - *0x02FC6-0x02FC9: Birthdate (year, 2x2 bytes, day, 2 bytes, month, 2 bytes, each 2 bytes + 11);*
    - *0x02FCA-0x02FCE: "Magic" word in ascii;*
    - *0x02FCF-0x02FD0: checksum (2 bytes, range of data included not sure);*
- **0x02FD1-0x02FE9: User ID data echo (below the first image only, slot 1, just replaced by 0xAA on other slots);**
- **0x02FEA-0x02FFF: end of memory slot;**          
    - *0x02FEA-0x02FFA: 0xAA repeated;*
    - *0x02FFA-0x02FFF: may not be 0xAA, but without any logical, not protected by checksum anyway;*

**Images are then repeated from 0xXX000 to 0xXXFFF with XX ranging from 03 to 1F.**

# Visual representation of data at the beginning of the save ram
![Visual representation of data at the beginning of save ram](https://github.com/Raphael-Boichot/Inject-pictures-in-your-Game-Boy-Camera-saves/blob/main/Pictures/Image_ram_beginning2.png)
          
# Now let's reverse engineer the checksum system !

OK, at this point I was curious to understand how the checksum system worked. It was not a two bytes checksum like the Game Boy Printer protocol for sure, But some savestates comparisons showed that increasing values of scores or pictures taken always increased the left byte of the cheksum (low address). So this one was just a sum. The right byte (high address) had a weird behavior. It increased for small variations of scores but suddendly decreased for higher values. I initially though it was a kind of 4 bits operation or the sum of the difference between odd and even addresses bytes, but honestly, writing it is assembly would have been particularly tedious. I even though it was a decimal operation (even more tedious to code). These different hypotheses worked in some cases, but not all. I finally tried all the common operators available in assembly and XOR was (of course) the good one. So left byte is a 8-bit sum and right byte a 8 bit XOR of values considered in the checksum. I did not try to find the exact range of data included into the sum and the xor given that knowing the rule is enough to perform easy score attacks. The code score_injector.m allows you to manipulate scores into your save easily.

Well enough to enjoy all the crappy images of the B album of the camera (At least in the international version, Gold and Japanese are a bit better).

Time passing, I think more and more than the checksum is calculated based on the difference between the current vector of data in the sram and a reference vector of data written somewhere in the rom, very close from data written in sram after a factory reset. This may explain why modifying the checksum just with the XOR of a difference (which is surprising) works. If programmers had just chosen a reference vector containing random values, the protection would have been nearly unbreakable. Seeds of the checksum + Word "Magic" + sort of reference vectors appear several times into the rom, so it would be possible to make an absolute attack on the protection system.

# Example of state vector checksum attack
![State vector](https://github.com/Raphael-Boichot/Inject-pictures-in-your-Game-Boy-Camera-saves/blob/main/Pictures/Vector_state_checksum.png)

# Example of Minigame checksum attack
![Minigames](https://github.com/Raphael-Boichot/Inject-pictures-in-your-Game-Boy-Camera-saves/blob/main/Pictures/Minigame_checksum.png)

The next example is interesting : after a factory reset, the metadata range contains only the "Magic" word + lots of 0x00, so it could be concluded that the initial checksum is only made on those characters. The result is however not correct, which means that the checksum must use some starting value not equal to 0 or embed more bytes. Anyway, this weakness does not preclude a byte attack by difference.

# Example of Metadata checksums
![Metadata](https://github.com/Raphael-Boichot/Inject-pictures-in-your-Game-Boy-Camera-saves/blob/main/Pictures/Metadata_checksum.png)

# Examples of score attack on real hardware
![Scores you will never get in real](https://github.com/Raphael-Boichot/Inject-pictures-in-your-Game-Boy-Camera-saves/blob/main/Pictures/Scores%20hacked.png)
![Scores you will never get in real2](https://github.com/Raphael-Boichot/Inject-pictures-in-your-Game-Boy-Camera-saves/blob/main/Pictures/Scores%20hacked%202.png)

# 2021-07-01 Update : structure of the Hello Kitty Pocket Camera save

Thanks to Cristofer Cruz who built a real Hello Kitty Pocket Camera from the dead body of a Pocket Camera and a MX27C8000 EPROM, we were able to explore the SRAM structure from various dumps. The save format is about the same than the Game Boy Camera with some exceptions: 

- **0x00000-0x00FFF: same as Game Boy Camera**
- **0x01000-0x011B1: game save data (NOT PROTECTED), see details:**
    - *0x01000-0x01001: counter for image taken (on 2x2 digits reversed);*
    - *0x01002-0x01003: counter for image erased (on 2x2 digits reversed);*
    - *0x01004-0x01005: counter for image transfered (on 2x2 digits reversed);*
    - *0x01006-0x01007: counter for image printed (on 2x2 digits reversed);*
    - *0x01008-0x01009: counter for pictures received by males an females (2x2 digits);*
    - *0x0100A-0x0100C: counter for Kitts (on 3x2 digits reversed);*
    - *0x0100D-0x01011: Unknown data;*
    - *0x01012-0x01016: "Magic" word in ascii with NO CHECKSUM after, data are not protected;*
    - *0x01017-0x011B1: 0x00;*
- **0x011B2-0x011D6: vector state, same as Game Boy Camera, protected with checksum;**
- **0x011D7-0x011FB: vector state, echo of 0x011B2-0x011D6;**
- **0x011FC-0x0187B: user profile 3 photos animated, 40x56 pixels (5x7 tiles), written consecutively;**
- **0x0187C-0x01FFF: 0x00;**
- **0x02000-0x1FFFF: same as Game Boy Camera;**

The counter for images is followed by a nice flower meter just below. I think that the game save data are not protected just because the game is not finished. Indeed, the "Magic" word exists but without checksum after and the game save data are not echoed contrary to the state vector that may originate from the old Game Boy Camera code the Hello Kitty is based on. Means that SRAM functionality is enough for running and testing the game but not "polished" for antipiracy.

# Example of byte attack on Hello Kitty Pocket Camera (Created by Cristopher Cruz @ https://github.com/cristofercruz)
![Byte attack on Hello Kitty](https://github.com/Raphael-Boichot/Inject-pictures-in-your-Game-Boy-Camera-saves/blob/main/Pictures/Hello_Kitty.jpg)

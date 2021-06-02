# Inject custom pictures in your Game Boy Camera saves, cheat at minigames and unlock the B album

![Time for creativity](https://github.com/Raphael-Boichot/Inject-pictures-in-your-Game-Boy-Camera-saves/blob/main/Pictures/Piece%20of%20cake.png)

By Raphaël BOICHOT, May 2021, a Matlab/Octave project.

The idea comes (once again) from the Game Boy Camera Club discord - https://disboard.org/nl/server/568464159050694666.
Some informations also come from the InsideGdget Discord, https://github.com/lesserkuma/FlashGBX and https://github.com/HerrZatacke/gb-printer-web

After a discussion about the vintage Game Boy Camera advertisements (like the Funtograpy guide for example) that present screen artworks, clearly not made with D-pad only, comes the idea that a tool perhaps existed as presskit to make custom saves with pictures not coming from the camera, and perhaps cheating at minigames. I did not know initially what hexadecimal nightmare was hidden behind this.

So, despite the fact that extracting images from Game Boy Camera saves was made possible by fans since many years, it was virtually impossible in 2021 to do the inverse : inject custom pictures into saves. At least until now. What could be the interest, dear reader ? It can be usefull to mess with pixel perfect artworks, to reuse an image that was erased long ago from camera but still stored somewhere on a computer or internet or simply exchange pictures with friends if you have no friends. Be creative ! 

The small Matlab/Octave codes presented here are intended to be easy to use. Here are the steps :
- Extract your save from Game Boy Camera with any tool like this: https://shop.insidegadgets.com/product/gbxcart-rw/
- Scan you save with slot_viewer.m to identify memory slots available for injection. By default an available slot is one ever occupied by an image. This is the "safe mode" of operation, your save will be 100% sure after the injection. Game face and address 0 are also writable as slots 0 and -1 respectively (they are by default active) ;
- In option, activate all memory slots with slot_activator.m if you want to occupy any slot on camera. Blank slots will become white images, erased images will appear again, images will be numbered according to their address in memory. This is the "unsafe mode" of operation as I did not extensively search if any wicked effet would appear. It must however be OK ;
- Prepare a 128x112 image and a 32x32 pixels thumbnail, 4 shades of gray ;  
- Inject the two pictures at once with image_injector.m into any desired memory slot ;
- You can check again the success of image injection with slot_viewer.m ;
- Burn your modified save into the Game Boy Camera ;
- Enjoy your new image and play with stamps.
- You can additionnaly extract your images from save in .png format with image_extractor.m

The scanning code basically extracts and analyses values at addresses 0x011B2 to 0x011CF that contains the state and numbering of any image slot on the save (which I will call "state vector"). These data are also duplicated from addresses 0x011D7 to 0x011F4. Any number between 0x00 and 0x1D on this state vector represents the image number (minus one) that shows on the cameras screen, FF is an unused slot (erased of never used). The number assignated to an image on camera is in consequence not related to the slot number (or physical address). Deleting an image on camera will simply write 0xFF on the vector state at the good place and all images will be renumbered dynamically, but image data stay on their respective slots as long as another image is not written on it. When a picture is taken, memory slots marked as unused on the vector state will be used by writing data in priority to the lowest address one. Next image illustrates the principle of this state vector :

![Vector state](https://github.com/Raphael-Boichot/Inject-pictures-in-your-Game-Boy-Camera-saves/blob/main/Pictures/Vector%20state.png)

Until this step, everything was fine and easy, tricky enough to occupy my brain for an evening but not much. Here came some tricky surprise.
There is a checksum system at addresses 0x011D5-0x011D6 and 0x011FA-0x011FB that precludes any possibility of un-erasing a single picture or activating a new memory slot by simply manipulating the state vector. Doing this simply forces the camera to replace any value on state vector by 0xFF (means you've fucked your precious images in case you just own original hardware in 1998).

This is why I wrote slot_activator.m, which activates all slots. This is the only operation I'm able to perform, knowing the checksum of this particular state vector. For doing this, I simply stuff addresses 0x011B2 to 0x011CF with a fake "camera full" state vector (0x00, 0x01, 0x02 ...0x1C, 0x1D) and addresses 0x011D5-0x011D6 with the corresponding checksum (0xE2, 0x14). Et voilà ! This means that range 0x011D7 to 0x011F4 and addresses 0x011FA-0x011FB are just echos. Activating the 30 slots of a camera after a factory reset gives you 30 white images but no bug apparently... To use at your own risks.

Hopefully, I've found that an active image could be replaced bytewise without activating any suicide code. In consequence, the injection code just substitutes the data corresponding to the image tiles (address range : 0xXX000-0xXXDEF for the image, address range : 0xXXDF0-0xXXEFF for the thumbnail, XX ranging from 02 to 1F). Additionnal data (range 0xXXF00-0xXXFFF), are not modified. Apart from that, data are arranged in Game Boy tile format, tile after tile, in reading order, so nothing particular for you Nintendo nerds.

Funfact, the thumbnail is dynamically rewritten each time the image is saved into the Game Boy Camera, even if just one pixel is changed. So I just provide a generic image thumbnail that will soon diseappear. Invigorated by my half-a-success, I took a look around the state vector in search for any minigame score to manipulate, following the word "Magic" into the save signing the presence of interesting stuff. This is where another form of pain happens.

# Checksums and pain : why there is no cheating codes until now for the Game Boy Camera

I loosely continue collecting data to understand how bytes are arranged into the savestate (see research folder). The principle reason is that it seems that there is not any single cheating codes on the whole planet Earth for this device (except the CoroCoro save hack), even more than 20 years after the camera was released, which is quite annoying when you know the requirement to unlock the full B album (Yes, accomplish 1000 points at Ball, 7000 points at Space Fever II and less that 16 seconds at Run! Run! Run! means you were at some point of your life stuck at home with two broken legs and only a Game Boy to entertain yourself, believe me). So my motivation to open an hexadecimal editor rather was strong. 

My general strategy was to compare different savesates with some accomplishments made (not all, I'm not mad nor stuck at home), byte per byte, to understand where were targeted addresses. I systematically compared with a blank savestate (all data erased). Everything was made on real hardware (Game Boy Camera and Pocket Camera in parallel).
To what I understand now: 
- Address range 0x00000-0x00DEF contains FF or the last image seen by the Game Boy Camera sensor. It can be extracted as a normal image. It is persistent (Game Boy can be powered on and off) as long as you do not use the Camera sensor; 
- Address range 0x011FC to 0x01FFB contains the game face as a 128x112 pixels image (same as camera pictures without the border) ;
- Frame border associated to an image is indicated at adress 0xXXFB0, XX ranging from 02 to 1F, by a single byte. This means that the border information is contains into the image data;
- User ID (birthdate, gender and name) is embedded into image informations section (but not in clear ascii, there is a byte shifting), address range 0xXXFB0-0xXXFF0. At first power-up, ID data are contained in the footer of the first image (even if this image stays blank). This means that after exchange, the owner of an image is probably still identifiable.  Its is associated with at least one checksum (probably two) so it is strongly protected. In consequence images are tagged in a rather robust way;
- Score at Ball is stored at address 0x010C9-0x010CA and 0x011A2-0x011A3 and modifies what seems to be a checksum at address 0x010D7-0x10D8 and address 0x011B0-0x011B1. Score appears in clear, but in decimal, bytes reversed (a score of 170 is written 0x70, 0x01);
- Score at Space Fever is stored at adress 0x010C5-0x010C6 (possibly 0x010C7-0x010C8) and 0x0119E-0x0119F (possibly 0x011A0-0x011A1) and modifies the same bytes as Ball. Score appears in clear, but in decimal, bytes reversed (a score of 2034 is written 0x34, 0x20);
- Score at Run! Run! Run! is stored at address 0x010CB-0x010CC and 0x011A4-0x011A5 and modifies the same bytes as Ball. The value written in savestate at adress 0x010CB-0x010CC is equal to 99 minus the digits on screen, bytes reversed (example : 18s10' is written 0x89,0x81 in save). Why this weird format ? It probably alows the Camera to start from a blank save with a non zero time for this game;
- Bytes 0x010BB-0x010BC and 0x01194-0x01195 seem to be image counters for pictures taken. They also modifies 0x010D7-0x10D8 and 0x011B0-0x011B1 (the score checksums);
- Bytes 0x010BD-0x010BE and 0x01196-0x01197 seem to be image counters for picture erased (it always increments). They also modifies 0x010D7-0x10D8 and 0x011B0-0x011B1 (the score checksums);
- Bytes 0x010C1-0x010C2 and 0x0119A-0x0119B seem to be image counters for picture printed (it always increments). They also modifies 0x010D7-0x10D8 and 0x011B0-0x011B1 (the score checksums);
- bytes 0x010BF-0x010C0 and 0x01198-0x01199 seem to be image counters for picture transfered (it always increments). They also modifies 0x010D7-0x10D8 and 0x011B0-0x011B1 (the score checksums). 
- Bytes 0x010C3, 0x119C stored the number of pictures received from males, bytes 0x010C4, 0x119D received from females;
- bytes 0x011D6 and 0x011D6 repeated at 0x011FA and 0x11FB seem to be a checksum only related to vector state;
- Occurences of these checksums is preceded by the word "Magic" in ascii, so in clear from hexadecimal point of view, perhaps a kind of humor, considering that all is obfuscated except the placement of the checksums. I did not try any byte attack on this word to check if it participates also to the checksums;
- The last byte into an image slot (0xXXFFF) seems not related to the image state (despite some internet informations), as I was able to reactivate deleted image without modifying this byte;
- Any discrepancy between data, scores and checksums causes the camera to erase all informations into the save at reboot (camera must consider the savestate as corrupted or modified by cheating). Everything is set to zero, end of story, reward for cheating. I think that the long booting time of the Game Boy Camera is precisely due to amount of verifications made;

# Summary

- The Game Boy Camera uses (at least) two series of Checksum to protect its own data : one for scores (minigames and counter for images) and one for controlling the vector state and prevent any erased or transfered image to be recovered by byte attack (as data still exist in memory slots). This means that when you play with a Gameboy Camera, you play with the rules. That may explain the scarcity, even the total absence of cheat codes for the Camera. The beast is robust !
- Scores of minigames are stored in address range 0x010C5-0x010CC and repeated at range 0x0119E-0x011A5. Second range seems to be an echo only, as modifying the first range is enough to get an effect, but also to destroy the whole coherency of the checksum system in case of error. Second range is not a backup;
- Image counters are stored in range address range 0x010BB-0x010C4 and repeated at range 0x01194-0x0119D. Same remark concerning the first range as the checksum is common with minigame scores;
- Scores and image counters appear in decimal format (when red in hexadecimal editor) by batch of two digits, least significant batch of two digits first. I do not know if it is a kind of obfuscation or an ease for programmers to display scores on screen;
- Trippy-H data are stored at address 0x01061-0x10B2, repeated at range 0x0113A-0x0118B; 
- Trippy-H, Scores and image counters increment and decrement at the same time two checksum "bytes" at address 0x010D7-0x10D8, repeated at address 0x011B0-0x011B1 ;
- Left byte of the checksum (low address) seems to be equal to 47 + sum(left value of digits + right value of digits) by batch of two "bytes" from 0x010C5 to 0x010CC. I'm not 100% sure of the rule as I saw some unexpected deviations for high numbers ;
- Right byte of the checksum  (high address) seems to be equal to 63 - sum(left value of digits - right value of digits) by batch of two "bytes" from 0x010C5 to 0x010CC. I'm not 100% sure of the rule either for the same reasons ;  
- The vector states (0x011D7 to 0x011F4) seem to have their own independant checksum bytes at adresses 0x011D5-0x11D6, repeated at 0x011FA-0x011FB ;
- left byte of the checksum (low address) seems to be equal to 11 + sum(image number in the vector state + 1, FF excluded); 
- calculation of the right byte of the checksum  (high address) is not understood to me for the moment. It seems to be the simple sum or difference of vector state values, but I did not catch completely the logical behind;
- I suppose that all of this (obfusctation + multiple checksums with diffrent rules) was implemented as some Game Genie or other cheating hardware counter measure as it is twisted as hell. Clearly a single byte attack will inevitably lead to the activation of a suicide code as at least three bytes must be modified to hack something (one byte of data + 2 bytes of checksum);
- On the contrary, the data corresponding to picture tiles stored in memory slots of camera are not protected by any way;
- Setting the scores in memory with the correct checksum is enough to unlock image B album, there is no other trick necessary;
- Good new, Pocket Camera and Game Boy Camera seems to have the exact same save structure. They are fully intercompatibles.
- I suppose that some additionnal work would be necessary to make a proper dedicated cheating tool but hey, I propose here custom saves that makes the job ! 

# Game Boy Camera save ram format by order of adresses

- **0x00000-0x00FFF: the last image seen by the sensor (128x128 pixels). The last line of 16 tiles is glitchy;**
- **0x01000-0x0102E: filling with 0xFE**
- **0x0102F-0x010D8: game save area, see details:**
*0x01061-0x010B2: Trippy-H partitions;
*0x010BB-0x010BC: counter for image taken (on 2x2 digits reversed);*
- *0x010BD-0x010BE: counter for image erased (on 2x2 digits reversed);*
- *0x010BF-0x010C0: counter for image transfered (on 2x2 digits reversed);*
- *0x010C1-0x010C2: counter for image printed (on 2x2 digits reversed);*
- *0x010C3-0x010C4: counter for pictures received by males an females (2x2 digits);*
- *0x010C5-0x010C6: Score at Space Fever II (on 4x2 digits reversed);*
- *0x010C9-0x010CA: score at balls (on 2x2 digits reversed);*
- *0x010CB-0x010CC: score at Run! Run! Run! (on 2x2 digits reversed, 99 minus value on screen);*
- *0x010D2-0x010D6: "Magic" word in ascii;*
- *0x010D7-0x010D8: checksum (2 bytes, not 100% understood);*
- **0x010D9-0x01107: filling with 0xFE;**
- **0x01108-0x011B1: game save area, echo of 0x0102F-0x010D8;**
- **0x011B2-0x011D6: vector state, see details:**
- *0x11B2-0x011CF: image number associated to memory slots (minus one), 0xFF means erased or blank;*   
- *0x11D0-0x011D4: "Magic" word in ascii;*
- *0x11D5-0x011D6: checksum (2 bytes, not 100% understood);*
- **0x011D7-0x011FB: vector state, echo of 0x011B2-0x011D6;**  
- **0x011FC-0x01FFB: Game Face (128x112);**
- **0x01FFC-0x01FFF: Camera tag (0x00, 0x39, 0x00, 0x39 western, 0x00, 0x56, 0x56, 0x53 for Corocoro, etc.);**
- **0x02000-0x02DFF: image memory slot 1 (128x112);**
- **0x02E00-0x02EFF: image thumbnail (32x32) - black borders and 4 white lines on the bottom;**
- **0x02F00-0x02FFF: image tag, see details:**
- **0x2E00-0x02F54 : first unknown sequence, last byte 2F54 is the border associated to image**;
- *0x02F55-0x02F59: "Magic" word in ascii;*
- *0x02F5A-0x02F5B:  checksum (2 bytes, not understood at all);*
- **0x02F5C-0x02FB7: fisrt unknown sequence echo;**
- **0x02FB8-0x02FC9: User ID data;**
- *0x02FCA-0x02FCE: "Magic" word in ascii;*
- *0x02FCF-0x02FD0:  checksum (2 bytes, not understood at all);*
- **0x02FD1-0x02FE9: User ID echo;**
- **0x02FEA-0x02FFF: third unknown sequence, filled with 0xAA (last byte seems 0xAA, 0x6E or 0x6B without any particular logic);**          
          
          
# Pimp your save with minigame scores you will never get !

Based on those checksum rules, hexadecimal editor and brute force attack with two Game Boys, a serial cable and a printer emulator (plus some luck), I was able to make 2 saves with everything unlocked (all images of B album), with in bonus the images of the Corocoro comics for pocket camera. See the "Pimp your save" folder for picking ready-to-inject saves. There is also an hidden easter egg into the two saves that some clever nerds on Game Boy Camera Club Discord have soon discovered. I was typically able to manipulate the scores of the 3 minigames and the number of image taken with hexadecimal editor only, step by step, verifying that each step worked on real hardware, then I gave up and physically incremented the other "easy" counters (deleted, printed and exchanged images) on real hardware (it was way faster than messing with hexadecimal values on paper). The scores of minigames were chosen close to the limit to unlock features but reachable enough to stay challenging to overtake (yes, I could have put 10,000,000 at Space Fever II, but is is less fun).

![Scores you will never get in real](https://github.com/Raphael-Boichot/Inject-pictures-in-your-Game-Boy-Camera-saves/blob/main/Pictures/Scores%20hacked.png)

# Things to do next (optionally)

- Finding a way to fully break the chechsum system ;
- Taking a look at the Trippy-H format and data location.

Here is some hexadecimal porn to end. Changing a byte randomly in yellow areas is like walking on a mine field, it will erase everything at startup. The data presented here comes from my oldest Game Boy Camera that was loaded with tons of images (erased and printed) and not-too-bad minigame scores.

# Vector state and related checksum
![Vector state and checksum](https://github.com/Raphael-Boichot/Inject-pictures-in-your-Game-Boy-Camera-saves/blob/main/Pictures/State%20vectors.png)
# Scores, counter and related checksum
![Scores, counters and checksums](https://github.com/Raphael-Boichot/Inject-pictures-in-your-Game-Boy-Camera-saves/blob/main/Pictures/Scores%20and%20counters.png)


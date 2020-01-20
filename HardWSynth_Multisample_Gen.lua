 --[[
ReaScript Name: 
Description:
Author: John H. Smith (Xcribe)
Date: January 2020

]]--


--[[// DEBUG //--
function Msg( value )
  if console then
    reaper.ShowConsoleMsg( tostring( value ) .. "\n" )
  end
end]]--

----------------// Vars //------------------------- THESE CAN (AND SHOULD) BE CUSTOMIZED!!!!
usesFullKbd = true                                      --Instead just leave usesFullKbd as true. This renders the entire keyboard chromatically.

numMeasures = 1  
releaseTimeOff = 960 --(PPQ) The amount of time "cut-off" the end of each note, aka kind of like Release.



---------------// INIT //----------------      <----DON'T MESS WITH THESE!

reaper.Main_OnCommand(40296,0) --Selects all tracks
track =  reaper.GetSelectedTrack(0,0)
RECtrack = reaper.GetSelectedTrack(0,1)

item ={}
if usesFullKbd == true then
  item =  reaper.CreateNewMIDIItemInProj( track, 0, 2*108*numMeasures, false )
else
  item =  reaper.CreateNewMIDIItemInProj( track, 0, 2*22*numMeasures, false )
end
reaper.Main_OnCommand(40182,0)  --Select all Items
reaper.Main_OnCommand(40153,0)  --Opens MIDIEditor
active_midi_editor = reaper.MIDIEditor_GetActive()
take = reaper.MIDIEditor_GetTake(active_midi_editor)
--RECtake =

totalMeas = numMeasures*108 --??????

proj = reaper.GetCurrentProjectInLoadSave()

estRecordTime = 1.0*numMeasures*109*4/reaper.GetProjectTimeSignature2(proj)

------------------// FUNCTIONS //-----------------------------------
function MIDIgen(take)
  if usesFullKbd == true then
    for i=1, 108, 1 do
      reaper.MIDI_InsertNote( take, true, false, 3840*i*numMeasures, (3840*i*numMeasures + numMeasures*3840)-releaseTimeOff, 1, i+1, 110, true ) --I NEED TO FIGURE OUT HOW TO OfFSET EACH NOTE BY TWO MEASURES!!! Aka Convert Project Measures -->PPQ!
    end 
  else
    for j=0, 22-1, 1 do
      reaper.MIDI_InsertNote( take, true, false, 3840*j*numMeasures, (3840*j*numMeasures + numMeasures*3840)-releaseTimeOff, 1, sympNoteVals[j+1], 110, true )
    end
  end
  reaper.MIDI_Sort(take)
end

local clock = os.clock()
function sleep(n)
  local t0 = clock
    while clock-t0 <=n do end
end

local currTime = reaper.GetCursorPosition()
function RecordOutput()
  local m0 = currTime
  reaper.SetEditCurPos( 0, true, false ) --moves cursor to 0 mark
  reaper.Main_OnCommand(1013, 0) --START RECORDING!!!
  while currTime <= estRecordTime do currTime = reaper.GetCursorPosition() end --Busy wait
      
  reaper.Main_OnCommand(1016,0) --Stops Recording
end


function ConsoleDisp()
 reaper.ClearConsole()
  reaper.ShowConsoleMsg("Recording in Progress... :) ")
  reaper.ShowConsoleMsg("\n \n \n")
  reaper.ShowConsoleMsg("Est. Recording time is: " .. estRecordTime .. " MINUTES!!!")
end
--------------------------------------------//  *** MAIN METHOD ***  //--------------------------------------------
function Main(take) --Controls all the execution steps of the program aka big daddy method
 
  --reaper.SetMediaTrackInfo_Value( RECtrack, "I_RECMODE" , 3) --set track recording mode 
  reaper.SetMediaTrackInfo_Value( RECtrack, "I_RECARM" , 1 )  --arm track for recording
  reaper.SetMediaTrackInfo_Value( RECtrack, "I_RECMON", 1)  --enables monitoring
  
  MIDIgen(take)
  
 ConsoleDisp()
 
  RecordOutput()
  
  
  if usesFullKbd==true then       --Creates Markers
    for i=1, 108, 1 do
     reaper.SetEditCurPos( 2*i*numMeasures, true, false )
         reaper.Main_OnCommand(40157,0) 
    end
  else
    for j=0, 22-1, 1 do
    reaper.SetEditCurPos( 2*j*numMeasures, true, false )
    reaper.Main_OnCommand(40157,0)
    end
  end
  
 
 
 reaper.Main_OnCommand(40421,0) --selects the media items on selected track
 
 reaper.Main_OnCommand(40576,0) --Toggles Item Lock
 
 reaper.Main_OnCommand(40931,0) --Split Item(s) at Project Markers
 
 if usesFullKbd==true then       --Destroys Markers
     for i=1, 108, 1 do
      reaper.SetEditCurPos( 2*i*numMeasures, true, false )
          reaper.Main_OnCommand(40613,0) 
     end
   else
     for j=0, 22-1, 1 do
     reaper.SetEditCurPos( 2*j*numMeasures, true, false )
     reaper.Main_OnCommand(40613,0)
     end
   end

   reaper.Main_OnCommand(40153,0)
  --reaper.Main_OnCommand(40421,0) --selects the media items on selected track
  reaper.Main_OnCommand(40576,0) --Unlocks current item
  --reaper.Main_OnCommand(40576,0) --Unlocks current item
  
  --********** ADD FADE OUTS / SET FADE TO ZERO HERE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*********************************
  

end


-----// UNDO ENABLER //------
if take then -- IF MIDI EDITOR
  reaper.Undo_BeginBlock() -- Begining of the undo block. Leave it at the top of your main function.
  Main(take)
  reaper.Undo_EndBlock("Synth Patch --> .Wav Converter", 0) -- End of the undo block. Leave it at the bottom of your main function.
end 


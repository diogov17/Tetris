module PlaySound where

import Control.Monad ( when, unless )
import Data.List ( intersperse )
import Sound.ALUT
import System.Exit ( exitFailure )
import System.IO ( hPutStrLn, stderr )

-- This program loads and plays a variety of files.

playSound :: String -> IO ()
playSound song =
  withProgNameAndArgs runALUTUsingCurrentContext $ \_ _ ->
  do
    (Just device) <- openDevice Nothing
    (Just context) <- createContext device []
    currentContext $= Just context
    buffer1 <- createBuffer $ File song
    [source] <- genObjectNames 1
    queueBuffers source [buffer1]
    play [source]
    --sleep 4
    --closeDevice device
    --return ()

playFile :: FilePath -> IO ()
playFile fileName = do
   -- Create an AL buffer from the given sound file.
   buf <- createBuffer (File fileName)

   -- Generate a single source, attach the buffer to it and start playing.
   source <- genObjectName
   buffer source $= Just buf
   play [source]

   -- Normally nothing should go wrong above, but one never knows...
   errs <- get alErrors
   unless (null errs) $ do
      hPutStrLn stderr (concat (intersperse "," [ d | ALError _ d <- errs ]))
      exitFailure
   
   -- Check every 0.1 seconds if the sound is still playing.
   let waitWhilePlaying = do
          sleep 0.1
          state <- get (sourceState source)
          when (state == Playing) $
             waitWhilePlaying
   waitWhilePlaying

testPlay :: IO ()
testPlay = do
   -- Initialise ALUT and eat any ALUT-specific commandline flags.
   withProgNameAndArgs runALUT $ \progName args -> do
    -- Check for correct usage.
      unless (length args == 1) $ do
      hPutStrLn stderr ("usage: " ++ progName ++ " <fileName>")
      exitFailure

      -- If everything is OK, play the sound file and exit when finished.
      playFile (head args)
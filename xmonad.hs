import System.IO
import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run (spawnPipe)
import XMonad.Util.EZConfig (additionalKeys)

main = do
  xmproc <- spawnPipe "xmobar"
  xmonad . docks $
    def {
      borderWidth = 6,
      normalBorderColor = "#330055",
      focusedBorderColor = "#ff8800",
      modMask = mod4Mask,
      focusFollowsMouse = False,
      clickJustFocuses = False,
      
      terminal = "alacritty",
      
      layoutHook = avoidStruts $ layoutHook def,

      logHook =
        dynamicLogWithPP xmobarPP
          {
            ppOutput = hPutStrLn xmproc,
            ppTitle = xmobarColor "green" "" . shorten 50
          }
    }
    `additionalKeys`
    [
    ]

module Main where
import Control.Concurrent

import Data.Time
import Data.Text (Text)
import Graphics.UI.Gtk

main :: IO ()
main = do
  initGUI
  forkIO $ postGUIAsync run
  mainGUI

run :: IO ()
run = do
  window <- windowNew
  window `on` objectDestroy $ mainQuit

  model <- treeStoreNew []
  view <- treeViewNewWithModel model

  treeViewSetHeadersVisible view True

  timeColumn <- treeViewColumnNew
  textColumn <- treeViewColumnNew

  treeViewColumnSetTitle timeColumn "Time"
  treeViewColumnSetTitle textColumn "Message"

  timeRenderer <- cellRendererTextNew
  textRenderer <- cellRendererTextNew

  cellLayoutPackStart timeColumn timeRenderer True
  cellLayoutPackStart textColumn textRenderer True

  cellLayoutSetAttributes timeColumn timeRenderer model $ \row ->
    [ cellText := show (time row)
    ]
  cellLayoutSetAttributes textColumn textRenderer model $ \row ->
    [ cellText := message row
    ]

  treeViewAppendColumn view timeColumn
  treeViewAppendColumn view textColumn

  containerAdd window view
  widgetShowAll window


data Message = Message
  { time :: UTCTime
  , message :: Text
  }

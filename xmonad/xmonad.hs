import Control.Concurrent
import Data.Map (Map)
import qualified Data.Map as M
import System.Directory
import System.FilePath
import System.IO
import XMonad
import qualified XMonad.StackSet as W


main :: IO ()
main = do
    xmonad $ defaultConfig {
	  focusFollowsMouse = True
	, startupHook = startup
	, modMask = mod4Mask
	-- , keys = myKeys
	}


startup :: X ()
startup = do
    spawn "numlockx on"
    spawn "xloadimage -onroot ~/Pictures/firefox-star.jpg"
    spawn "dropbox start"


myKeys :: XConfig Layout -> Map (KeyMask, KeySym) (X ())
myKeys conf@(XConfig{XMonad.modMask = modMask}) = id
    $ M.insert (modMask .|. shiftMask, xK_Return) (openTerm conf)
    $ M.map setCurrDir
    -- TODO: remove pids from screen map
    $ keys defaultConfig conf


type ConcreteScreen = W.Screen String (Layout Window) Window ScreenId ScreenDetail


currentScreen :: X ConcreteScreen
currentScreen = gets $ W.current . windowset


myStateKeyPrefix :: String
myStateKeyPrefix = "EDING:"


toMyStateKey :: String -> String
toMyStateKey = (myStateKeyPrefix ++)


fromMyStateKey :: String -> String
fromMyStateKey = drop $ length myStateKeyPrefix


modifyExtensible :: (Map String (Either String StateExtension) -> Map String (Either String StateExtension)) -> X ()
modifyExtensible f = modify $ \s -> s { extensibleState = f $ extensibleState s }


openTerm :: XConfig Layout -> X ()
openTerm conf = do
    pid <- spawnPID $ terminal conf

    io $ threadDelay 5000

    screen <- currentScreen
    let sid = maybe (-666) id $ getXID screen
    modifyExtensible $ M.insert (toMyStateKey $ show sid) (Left $ show pid)


getXID :: ConcreteScreen -> Maybe XID
getXID screen = case W.stack $ W.workspace screen of
    Just stack -> Just $ W.focus stack
    _ -> Nothing


setCurrDir :: X () -> X ()
setCurrDir action = do
    action
    screen <- currentScreen
    let sid = maybe (-666) id $ getXID screen
    st <- gets extensibleState
    let pid = case M.lookup (toMyStateKey $ show sid) st of
		Just (Left pidStr) -> read pidStr `asTypeOf` (0 :: Integer)
		_ -> -666
    io $ do
	home <- getHomeDirectory
	handle <- flip openFile WriteMode $ home </> "xmonaddir"
	let msg = show ("sid", sid, "pid", pid)
	hPutStrLn handle msg
	hClose handle
        return ()






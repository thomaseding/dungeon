import Control.Concurrent
import Data.Map (Map)
import qualified Data.Map as M
import System.Directory
import System.FilePath
import System.IO
import XMonad as XM
import XMonad.Layout.IndependentScreens as IS
import XMonad.StackSet as W
import XMonad.Util.EZConfig as EZ


main :: IO ()
main = do
    xmonad $ defaultConfig {
	  focusFollowsMouse = True
	, startupHook = startup
	-- , modMask = mod4Mask
	, keys = myKeys3
	}


myWorkspaces = ["1","2","3","4","5","6","7","8","9"]


startup :: X ()
startup = do
    spawn "numlockx on"
    spawn "xloadimage -onroot ~/dungeon/img-tiles/3461917328_92f4bb2ab7.jpg"
    --spawn "dropbox start"


myKeys :: XConfig Layout -> Map (KeyMask, KeySym) (X ())
myKeys conf@(XConfig{XM.modMask = modMask}) = id
    $ M.insert (modMask .|. shiftMask, xK_Return) (openTerm conf)
    $ M.map setCurrDir
    -- TODO: remove pids from screen map
    $ keys defaultConfig conf


myKeys2 = [
      (otherModMasks ++ "M-" ++ [key], action tag)
    | (tag, key)  <- zip myWorkspaces "123456789"
    , (otherModMasks, action) <- [("", windows . v), ("S-", windows . W.shift)]
    ]
    where
        v = W.view
        --v = W.greedyView

myKeys3 conf = let
    m = XM.modMask conf
    oldKeys = undefined -- M.toList  XM.keys conf
    in M.fromList $ oldKeys ++ [
         ((m .|. shiftMask, k), windows $ onCurrentScreen f i)
        | (i, k) <- zip myWorkspaces [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]




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
modifyExtensible f = XM.modify $ \s -> s { extensibleState = f $ extensibleState s }


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






module Main (main) where

import Lib
import Data.ByteString.Lazy.Char8
import Control.Monad
import Control.Monad.Trans
import Happstack.Server (nullConf, simpleHTTP, dir,askRq, takeRequestBody,unBody, method, Method(POST), ServerPartT, composeFilter, mkHeaders, require)
import Happstack.Server.Types (Response(..))
import Data.String (fromString)

getBody :: ServerPartT IO ByteString
getBody = do
    req  <- askRq 
    body <- takeRequestBody req
    case body of 
        Just rqbody -> return . unBody $ rqbody 
        Nothing     -> return $ fromString ""

main :: IO ()
main = simpleHTTP nullConf $  msum [ 
            do 
                dir "run" $ 
                    do 
                        method POST
                        body <- getBody
                        lift $ Prelude.putStrLn $ "request body: " ++ unpack body
                        result <- lift $ evalCode $ unpack body
                        lift $ Prelude.putStrLn $ "response body: " ++ result
                        headers <- return $ mkHeaders [("Access-Control-Allow-Origin", "*")]
                        composeFilter (\r -> r{rsCode = 200,rsHeaders = headers}) >> return result
            ]


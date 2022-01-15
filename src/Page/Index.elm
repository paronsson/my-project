module Page.Index exposing (Data, Model, Msg, page)

import DataSource exposing (DataSource)
import Head
import Head.Seo as Seo
import Page exposing (Page, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Path exposing(Path)
import Browser.Navigation
import Shared
import View exposing (View)
import Html exposing (..)
import Html.Attributes  exposing (..)



type alias Model =
    ()


type alias Msg =
    Never


type alias RouteParams =
    {}


page : Page RouteParams Data
page =
    Page.single
        { head = head
        , data = data
        }
        |> Page.buildWithLocalState { init = init, view = view, subscriptions = subscriptions, update = update }


data : DataSource Data
data =
    DataSource.succeed ()


head :
    StaticPayload Data RouteParams
    -> List Head.Tag
head static =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = "elm-pages"
        , image =
            { url = Pages.Url.external "TODO"
            , alt = "elm-pages logo"
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = "TODO"
        , locale = Nothing
        , title = "TODO title" -- metadata.title -- TODO
        }
        |> Seo.website


type alias Data =
    ()

init :
          Maybe PageUrl
          -> Shared.Model
          -> StaticPayload Data RouteParams
          -> ( Model, Cmd Msg )
init maybeUrl sharedModel static =
    ( (), Cmd.none )


subscriptions :
          Maybe PageUrl
          -> RouteParams
          -> Path.Path
          -> Model
          -> Sub Msg
subscriptions _ _ _ _ = Sub.none

update :
          PageUrl
          -> Maybe Browser.Navigation.Key
          -> Shared.Model
          -> StaticPayload Data RouteParams
          -> Msg
          -> Model
          -> ( Model, Cmd Msg )
update _ _ _ _ _ _ = ( (), Cmd.none )

view maybeUrl sharedModel _ _ =
    { title = sharedModel.appName ++ " - " ++ "Root"
    , body = [ Html.a [href "xx"] [Html.text "link"] ]
    }

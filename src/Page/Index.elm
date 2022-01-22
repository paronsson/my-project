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
import Html.Attributes  exposing (..)
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)



type alias Model = Int


type Msg =
    Increment | Decrement


type alias RouteParams =
    {}


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
    ( 0, Cmd.none )


subscriptions :
          Maybe PageUrl
          -> RouteParams
          -> Path.Path
          -> Model
          -> Sub x
subscriptions _ _ _ _ = Sub.none

update :
          PageUrl
          -> Maybe Browser.Navigation.Key
          -> Shared.Model
          -> StaticPayload Data RouteParams
          -> Msg
          -> Model
          -> ( Model, Cmd Msg )
update _ _ _ _ msg model =  case msg of
                              Increment ->
                                (model + 1, Cmd.none)

                              Decrement ->
                                (model - 1, Cmd.none)


view maybeUrl sharedModel model _ =
    { title = sharedModel.appName ++ " - " ++ "Root"
    , body = [ Html.a [href "blog"] [Html.text "link"] ,
               div []
                   [ button [ onClick Decrement ] [ text "-" ]
                   , div [] [ text (String.fromInt model) ]
                   , button [ onClick Increment ] [ text "+" ]
               ]]
    }

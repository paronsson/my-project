module Page.Xx exposing (Data, Model, Msg, page)

import DataSource exposing (DataSource)
import DataSource.Glob as Glob
import Head
import Head.Seo as Seo
import Page exposing (Page, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Shared
import View exposing (View)
import Html exposing (..)
import Html.Attributes  exposing (..)
import DataSource.File as File
import OptimizedDecoder as Decode exposing (Decoder)


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
        , data = blogPosts
        }
        |> Page.buildNoState { view = view }


blogPosts :
    DataSource Data
blogPosts =
    Glob.succeed
        (\filePath ->filePath)
        |> Glob.captureFilePath
        |> Glob.match (Glob.literal "content/blog/")
        |> Glob.match Glob.wildcard
        |> Glob.match (Glob.literal ".md")
        |> Glob.toDataSource
        |> DataSource.andThen
            (\x -> DataSource.combine (List.map (File.bodyWithFrontmatter blogPostDecoder) x))

type alias BlogPostMetadata =
    { body : String
    , title : String
    }

blogPostDecoder : String -> Decoder BlogPostMetadata
blogPostDecoder body =
    Decode.map (BlogPostMetadata body)
        (Decode.field "title" Decode.string)

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


type alias Data = List BlogPostMetadata


viewPost data = List.map (\z -> Html.div [] [Html.text z.title, Html.text " ", Html.text z.body]) data


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    { title = sharedModel.appName ++ " - " ++ "Xx"
    , body = viewPost static.data
    }

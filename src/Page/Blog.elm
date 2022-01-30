module Page.Blog exposing (Data, Model, Msg, page)

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
import Markdown.Parser as Markdown
import Markdown.Renderer



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
        |> Glob.match (Glob.literal "public/content/blog/")
        |> Glob.match Glob.wildcard
        |> Glob.match (Glob.literal ".md")
        |> Glob.toDataSource
        |> DataSource.andThen
            (\x -> DataSource.combine (List.map (File.bodyWithFrontmatter blogPostDecoder) x))

type alias BlogPostMetadata =
    { body : String
    , title : String,
      publish : String
    }

blogPostDecoder : String -> Decoder BlogPostMetadata
blogPostDecoder body =
    Decode.map2 (BlogPostMetadata body)
        (Decode.field "title" Decode.string)
        (Decode.field "publish" Decode.string)

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

viewMarkup : String -> Html Msg
viewMarkup markdownInput =
    Html.div [ style "text-align" "center" ]
        [case
            markdownInput
                |> Markdown.parse
                |> Result.mapError deadEndsToString
                |> Result.andThen (\ast -> Markdown.Renderer.render Markdown.Renderer.defaultHtmlRenderer ast)
          of
            Ok rendered ->
                div [style "text-align" "left"] rendered

            Err errors ->
                text errors
        ]

deadEndsToString deadEnds =
    deadEnds
        |> List.map Markdown.deadEndToString
        |> String.join "\n"

viewPost data = [Html.h1 [style "text-align" "center"] [Html.b [] [text "BLOG"]]] ++
    (List.map (\z -> Html.div [style "border-radius" "10px", style "margin" "10px", style "margin-left" "auto", style "margin-right" "auto", style "padding" "10px", style "border" "4px solid", style "border-color" "rgb(180, 180, 180)"]
                             [Html.div [style "text-align" "right"]
                                       [Html.text (case (List.head (String.split "T" z.publish)) of
                                                                                       Just x -> x
                                                                                       Nothing -> ""),
                                        Html.h1 [style "text-align" "center"] [text z.title],
                            viewMarkup z.body]]) data)


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    { title = sharedModel.appName ++ " - " ++ "Blog"
    , body = viewPost static.data
    }

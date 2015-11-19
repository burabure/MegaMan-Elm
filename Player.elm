module Player where

import Graphics.Element as Element
import Graphics.Collage as Collage


-- MODEL
type alias Model =
  { x : Float
  , y : Float
  , dir : Direction
  }

type Direction = Left | Right


-- UPDATE
type Action
  = NoOp
  | MoveX Int


update : Action -> Model -> Model
update action player =
  case action of
    NoOp ->
      player

    MoveX direction ->
      let
        units =
          toFloat (direction * 5)

        newDir =
          case direction of
            0 -> player.dir
            1 -> Right
            (-1) -> Left
      in
        { player
          | x <- player.x + units
          , dir <- newDir
         }


-- VIEW
view : Model -> Collage.Form
view model =
  let
    direction =
      case model.dir of
        Left -> "left"
        Right -> "right"

    spriteSrc =
      "./sprites/player/" ++ direction ++ ".gif"
  in
    Element.image 60 60 spriteSrc
    |> Collage.toForm
    |> Collage.move (model.x, model.y)

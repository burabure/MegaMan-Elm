module Player where

import Graphics.Element as Element
import Graphics.Collage as Collage


-- MODEL
type alias Model =
  { id : String
  , x : Float
  , y : Float
  , w : Float
  , h : Float
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
          if direction < 0 then
            Left
          else if direction > 0 then
            Right
          else
            player.dir
      in
        { player
          | x = player.x + units
          , dir = newDir
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
    Element.image (truncate model.w) (truncate model.h) spriteSrc
    |> Collage.toForm
    |> Collage.move (model.x, model.y)

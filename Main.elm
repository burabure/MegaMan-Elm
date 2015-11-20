import Graphics.Element as Element
import Graphics.Collage as Collage
import Color
import Keyboard
import Time
--import Debug

import Player
import Entity


-- STAGE
type alias Stage =
  { background : Collage.Form
  , playerStartingPoint : (Float, Float)
  }


stage : Stage
stage =
  { background =
      Collage.rect 500 250
      |> Collage.filled (Color.rgb 230 230 255)
  , playerStartingPoint =
      (0, -90)
  }


-- ENTITIES
boxEntity : Entity.Entity
boxEntity =
  Entity.Entity "box" 90 -90 30 60


box : Collage.Form
box =
  Collage.rect boxEntity.w boxEntity.h
  |> Collage.filled (Color.rgb 75 75 75)
  |> Collage.move (boxEntity.x, boxEntity.y)


-- INPUT
directions : Signal Action
directions =
  Keyboard.arrows
  |> Signal.sampleOn (Time.fps 60)
  |> Signal.map (.x >> Player.MoveX >> PlayerAction)


-- MODEL
type alias Model =
  { player : Player.Model }


initialModel : Model
initialModel =
  let
    playerX = fst stage.playerStartingPoint
    playerY = snd stage.playerStartingPoint
  in
    { player =
        Player.Model "player1" playerX playerY 60 60 Player.Right
    }


models : Signal Model
models =
  Signal.foldp update initialModel directions


-- UPDATE
type Action
  = PlayerAction Player.Action


update : Action -> Model -> Model
update action model =
  case action of
    PlayerAction action ->
      { model | player = Player.update action model.player }


-- VIEW
view : Model -> Element.Element
view model =
  let
    playerCollision =
      Entity.colliding ((Entity.toEntity model.player), boxEntity)
  in
    Collage.collage 500 250
      [ stage.background
      , (Player.view model.player)
      , box
      , log "Collision" playerCollision
      ]


log : String -> a -> Collage.Form
log title stringable =
  title ++ ": " ++ (toString stringable)
  |> Element.show
  |> Collage.toForm


main : Signal Element.Element
main =
  Signal.map view models

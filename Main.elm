import Graphics.Element as Element
import Graphics.Collage as Collage
import Color
import Keyboard
import Time
import Player
--import Debug

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
        Player.Model playerX playerY Player.Right
    }


models : Signal Model
models =
  Signal.foldp update initialModel directions


-- UPDATE
type Action
  = NoOp
  | PlayerAction Player.Action


update : Action -> Model -> Model
update action model =
  case action of
    PlayerAction action ->
      { model | player <- Player.update action model.player }


-- VIEW
view : Model -> Element.Element
view model =
  Collage.collage 500 250 [stage.background, (Player.view model.player)]


main : Signal Element.Element
main =
  Signal.map view models

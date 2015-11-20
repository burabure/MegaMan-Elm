module Entity where

import Maybe


-- ENTITY
type alias Entity =
  { id : String
  , x : Float
  , y : Float
  , w : Float
  , h : Float
  }


toEntity : { a | id : String
               , x : Float
               , y : Float
               , w : Float
               , h : Float } -> Entity
toEntity record =
  Entity record.id record.x record.y record.w record.h


-- COLLISION
type Overlap
  = Right
  | Left
  | Center


colliding : (Entity, Entity) -> Maybe.Maybe Overlap
colliding (focus, entity) =
  let
    leftOf ent =
      ent.x - (ent.w / 2)
    rightOf ent =
      ent.x + (ent.w / 2)
    focusDiffLeft =
      (leftOf focus) - (leftOf entity)
    focusDiffRight =
      (rightOf focus) - (rightOf entity)
  in
    if focusDiffLeft < 0 && focusDiffRight > 0 then
      Just Center
    else if focusDiffLeft - entity.w <= 0 && focusDiffLeft >= 0 then
      Just Left
    else if focusDiffRight + entity.w >= 0 && focusDiffRight <= 0 then
      Just Right
    else
      Nothing

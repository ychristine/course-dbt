{{
  config(
    materialized='table'
  )
}}

SELECT 
    id AS superhero_id,
    name,
    gender,
    eye_color,
    race,
    hair_color,
    NULLIF(height, -99) AS height,
    {{ lbs_to_kgs('height') }} AS height_kg,
    publisher,
    skin_color,
    alignment,
    NULLIF(weight, -99) AS weight,
    {{ lbs_to_kgs('weight') }} AS weight_kg
FROM {{ source('tutorial', 'superheroes') }}
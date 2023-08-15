# frozen_string_literal: true
module Drinks
  BASIC_DRINKS = %w[sparkling_water izze san_pellegrino soda].freeze
  SPECIALTY_DRINKS = %w[rootbeer redbull tea].freeze

  def self.basic
    [
      {
        name: "Sparkling water",
        img_url: "https://images.costcobusinessdelivery.com/ImageDelivery/imageService?profileId=12028466&itemId=1146604&recipeName=680"
      },
      {
        name: "Izze",
        img_url: "https://images.costcobusinessdelivery.com/ImageDelivery/imageService?profileId=12028466&itemId=1549086&recipeName=680"
      },
      {
        name: "San Pellegrino",
        img_url: "https://images.costcobusinessdelivery.com/ImageDelivery/imageService?profileId=12028466&itemId=1633020&recipeName=680"
      },
      {
        name: "Soda",
        img_url: "https://images.costcobusinessdelivery.com/ImageDelivery/imageService?profileId=12028466&itemId=891742&recipeName=680"
      }
    ]
  end

  def self.specialty
    [
      {
        name: "Root beer",
        img_url: "https://images.costcobusinessdelivery.com/ImageDelivery/imageService?profileId=12028466&imageId=1414982__1&recipeName=350"
      },
      {
        name: "Red Bull",
        img_url: "https://images.costcobusinessdelivery.com/ImageDelivery/imageService?profileId=12028466&itemId=184554&recipeName=680"
      },
      {
        name: "Ito En Tea",
        img_url: "https://images.costcobusinessdelivery.com/ImageDelivery/imageService?profileId=12028466&imageId=1392860__1&recipeName=350"
      }
    ]
  end
end

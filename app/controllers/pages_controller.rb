class PagesController < ApplicationController
  def home
  end

  def services
    @services = [
      { name: "Tune-up", price: 40 },
      { name: "Wheel true", price: 30 },
      { name: "Brake bleed", price: 30 },
      { name: "Chain replacement", price: 35 },
      { name: "Flat tyre repair", price: 20 },
      { name: "Brake adjustment", price: 25 },
      { name: "Gear adjustment", price: 25 },
      { name: "Tire replacement", price: 30 },
      { name: "Cable replacement", price: 20 },
      { name: "Fork service", price: 60 },
      { name: "Bearing service", price: 35 },
      { name: "Bike inspection", price: 25 }
    ]
  end

  def visit
  end

  def about
  end
end
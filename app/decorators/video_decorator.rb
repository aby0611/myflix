class VideoDecorator < Draper::Decorator
  delegate_all

  def rating
    object.reviews.average(:rating).present? ? "#{object.reviews.average(:rating)}/5.0" : "N/A"
  end
end
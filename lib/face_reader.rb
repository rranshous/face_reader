require 'aws-sdk'
require 'ostruct'

class FaceReader

  def is_happy? image_data
    face_details(image_data).is_happy?
  end

  def to_h image_data
    client.detect_faces({
      image: { bytes: image_data },
      attributes: ["ALL"]
    }).to_h
  end

  private

  def face_details data
    resp = client.detect_faces({
      image: { bytes: data },
      attributes: ["ALL"]
    })
    how_happy = resp.face_details.map do |details|
      emotions = details.emotions || []
      happiness = emotions.detect{ |e| e.type == 'HAPPY' }
      happiness ? happiness.confidence : 0
    end
    puts "how happy: #{how_happy}"
    happiness = how_happy.first ? how_happy.first > 80 : nil
    OpenStruct.new({ is_happy?: happiness })
  end

  def client
    @client ||= Aws::Rekognition::Client.new(region: 'us-east-1')
  end
end


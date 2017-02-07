require 'aws-sdk'

class FaceReader
  def is_happy? image_data
    face_details(image_data)[:is_happy?]
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
    { is_happy?: happiness }
  end

  def client
    @client ||= Aws::Rekognition::Client.new(region: 'us-east-1')
  end
end


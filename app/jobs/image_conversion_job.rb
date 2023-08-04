class ImageConversionJob < ApplicationJob
  queue_as :default

  def perform(post_id)
    post = Post.find_by(id: post_id)
    return unless post

    convert_post_image_to_jpeg(post)

    Rails.logger.info("Image conversion completed for Post #{post.id}")
  end

  private

  def convert_post_image_to_jpeg(post)
    image_blob = post.image.blob

    return if image_blob.content_type == 'image/jpeg'

    # Load the image data with Vips
    image = Vips::Image.new_from_buffer(image_blob.download, '')

    # Convert the image to JPEG format
    jpeg_image = image.jpegsave_buffer

    # Create a new attachment with the converted JPEG data and variant options
    new_attachment = ActiveStorage::Blob.create_and_upload!(
      io: StringIO.new(jpeg_image),
      filename: "#{post.image.filename.base}.jpg",
      content_type: 'image/jpeg'
    )

    # Create a variant and attach it to the new attachment
    variant = new_attachment.variant(resize_to_fill: [800, nil])
    post.image.attach(variant.blob)
  end
end

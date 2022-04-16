# frozen_string_literal: true

# name: discourse-webhook-payload-mod
# about: TODO
# version: 0.0.1
# authors: Discourse
# url: TODO
# required_version: 2.7.0
# transpile_js: true

enabled_site_setting :discourse_webhook_payload_mod_enabled

after_initialize do
    add_to_serializer(:web_hook_topic_view, :post, false) {
        Post.where("topic_id = #{object.topic.id} and post_number = 1")   
    }

    add_to_serializer(:web_hook_topic_view, :category_import_id, false) {
        category = Category.where(id: object.topic.category_id)[0]
        category_import_id = nil
        unless category.respond_to?('custom_fields') && !category.is_blank?
            category_import_id = category.custom_fields["import_id"]
        end
        return if category_import_id.blank?
        category_import_id
    }

    add_to_serializer(:web_hook_topic_view, :user_import_id, false) {
        user = User.where(id: object.topic.user_id)[0]
        wp_user_id = nil
        unless user.respond_to?('custom_fields') && !category.is_blank?
            wp_user_id = user.custom_fields["import_id"]
        end
        return if wp_user_id.blank?
        wp_user_id
    }

end

# name: discourse-credits
# about: Credit mechanism for new topics
# version: 0.1
# author: DiscourseHosting
# url: https://www.github.com/discoursehosting/discourse-credits


after_initialize do

#  class ::NewPostManager
  NewPostManager.class_eval do

    alias_method :orig_perform, :perform

    def perform

      field_no = UserField.where(name: "Credits").pluck('id').first
      if field_no && @args[:topic_id].nil?

        credits = @user.custom_fields["user_field_#{field_no}"].to_i
        if credits < 1
          result = NewPostResult.new(:created_post, false)
          result.errors[:base] << "you have #{credits} credits <a href='https://nu.nl/?h=#{Discourse.current_hostname}&u=#{@user.username}' target='_blank'>Crap</a>"
          return result
        else
          credits -= 1
          @user.custom_fields["user_field_#{field_no}"] = credits.to_s
          @user.save_custom_fields
        end

      end 

      orig_perform

    end
  end
end

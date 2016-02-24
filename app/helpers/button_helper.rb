module ButtonHelper
  def add_friend_button(user, options = {})
    unless current_user.friend?(user) or user == current_user
      if options[:value].present?
        link_to new_friendship_path(user), class: options[:class] do
          "<i class=\"material-icons left\">library_add</i> #{options[:value]}".html_safe
        end
      else
        link_to new_friendship_path(user), class: options[:class] do
          '<i class="material-icons">library_add</i>'.html_safe
        end
      end
    end
  end

  def delete_user_button(user, options = {})
    if current_user.admin? && !current_user?(user)
      if options[:value].present?
        link_to user, method: :delete, data: { confirm: 'Are you sure?' }, class: options[:class] do
          "<i class=\"material-icons left delete\">delete</i> #{options[:value]}".html_safe
        end
      else
        link_to user, method: :delete, data: { confirm: 'Are you sure?' }, class: options[:class] do
          '<i class="material-icons delete">delete</i>'.html_safe
        end
      end
    end
  end

  def money_transfer_button(user)
    link_to new_money_transfer_path(receiver_id: user.id), class: 'waves-effect waves-light btn' do
      '<i class="material-icons left">send</i> Money trasfer'.html_safe
    end
  end
end

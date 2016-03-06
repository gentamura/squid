=begin
sender_id == current_user.id => receiver_id, sent 側の表示
- receiver icon
- receiver picture
- receiver name
- received time
- memo
- attachment
- amount

receiver_id == current_user.id => sender_id, receiverd 側の表示
- sender icon
- sender picture
- sender name
- sent time
- amount (added plus sign)
=end

module MoneyTransferHelper
  def timeline_content(transfer, current_user)
    if transfer.sender_id == current_user.id
      inner_content(transfer, transfer.receiver, sprintf("%+d", transfer.amount))
    elsif transfer.receiver_id == current_user.id
      inner_content(transfer, transfer.sender, transfer.amount)
    end
  end

  def money_transfer_detail(transfer, current_user)
    if transfer.sender_id == current_user.id
      inner_detail(transfer, transfer.receiver, sprintf("%+d", transfer.amount))
    elsif transfer.receiver_id == current_user.id
      inner_detail(transfer, transfer.sender, transfer.amount)
    end
  end

  private
    def inner_content(transfer, user, amount)
      content_tag(:div) do
        concat tag :img, src: FFaker::Avatar.image(user.name, '50x50'), class: 'circle'
        concat content_tag(:p, user.name)
        concat content_tag(:p, amount)
        concat content_tag(:p, transfer.message)
        concat content_tag(:p, transfer.created_at)
      end
    end

    def inner_detail(transfer, user, amount)

    end
end

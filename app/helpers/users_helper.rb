module UsersHelper
  def toggle_user_state(user)
    link_to (user.active? ? 'disable' : 'enable').to_s,
            toggle_user_state_user_path(user),
            method: :post,
            data: { confirm: 'Are you sure?' },
            class: toggle_user_button_class(user).to_s

  end

  def delete_user_button(user)
    link_to 'delete',
            user,
            method: :delete,
            data: { confirm: 'Are you sure?' },
            class: "btn btn-xs btn-danger #{disable_button(user)}"
  end

  def toggle_flash_message(user)
    "User was #{user.active ? 'enabled' : 'disabled'}."
  end

  def toggle_user_button_class(user)
    if user.active?
      "btn btn-xs btn-danger #{disable_button(user)}"
    else
      "btn btn-xs btn-success #{disable_button(user)}"
    end
  end

  def disable_button(user)
    'disabled' if user.current_user?
  end
end
